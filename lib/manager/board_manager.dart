import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:game/manager/next_direction_manager.dart';
import 'package:game/manager/round.dart';
import 'package:game/models/board.dart';
import 'package:game/models/tile.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BoardManager extends StateNotifier<Board> {
  final verticalOrder = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];
  final StateNotifierProviderRef ref;
  BoardManager(this.ref) : super(Board.newGame(0, [])) {
    load();
  }
  void load() async {
    var box = await Hive.openBox<Board>('boardBox');
    state = box.get(0) ?? _newGame();
  }

  int maxScore() {
    return state.score > state.highScore ? state.score : state.highScore;
  }

  Board _newGame() {
    return Board.newGame(maxScore(), [random([])]);
  }

  void newGame() {
    state = _newGame();
  }

  bool _inRange(index, int nextIndex) {
    return index < 4 && nextIndex < 4 ||
        index >= 4 && index < 8 && nextIndex >= 4 && nextIndex < 8 ||
        index >= 8 && index < 12 && nextIndex >= 8 && nextIndex < 12 ||
        index >= 12 && nextIndex >= 12;
  }

  Tile _calculate(Tile tile, List<Tile> tiles, direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    int index = vert ? verticalOrder[tile.index] : tile.index;
    int nextIndex = ((index + 1) / 4).ceil() * 4 - (asc ? 4 : 1);
    if (tiles.isNotEmpty) {
      var last = tiles.last;
      var lastIndex = last.nextIndex ?? last.index;
      lastIndex = vert ? verticalOrder[lastIndex] : last.index;
      if (_inRange(index, lastIndex)) {
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }
    return tile.copyWith(
        nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);
  }

  bool move(SwipeDirection direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;

    state.tiles.sort(((a, b) =>
        (asc ? 1 : -1) *
        (vert
            ? verticalOrder[a.index].compareTo(verticalOrder[b.index])
            : a.index.compareTo(b.index))));
    List<Tile> tiles = [];
    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];
      tile = _calculate(tile, tiles, direction);
      tiles.add(tile);
      if (i + 1 < l) {
        var next = state.tiles[i + 1];
        if (tile.value == next.value) {
          var index = vert ? verticalOrder[tile.index] : tile.index,
              nextIndex = vert ? verticalOrder[next.index] : next.index;
          if (_inRange(index, nextIndex)) {
            tiles.add(next.copyWith(nextIndex: tile.nextIndex));
            i += 1;
            continue;
          }
        }
      }
    }
    state = state.copyWith(tiles: tiles, undo: state);
    return true;
  }

  Tile random(List<int> indexes) {
    var i = 0;
    var rng = Random();
    do {
      i = rng.nextInt(16);
    } while (indexes.contains(i));
    return Tile(const Uuid().v4(), 2, i);
  }

  void merge() {
    List<Tile> tiles = [];
    var tilesMoved = false;
    List<int> indexes = [];
    var score = state.score;
    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];
      var value = tile.value, merged = false;
      if (i + 1 < l) {
        var next = state.tiles[i + 1];
        if (tile.nextIndex == next.nextIndex ||
            tile.index == next.index && tile.nextIndex == null) {
          value = tile.value + next.value;
          merged = true;
          score += value;
          i += 1;
        }
      }
      if (merged || tile.nextIndex != null && tile.index != tile.nextIndex) {
        tilesMoved = true;
      }
      tiles.add(tile.copyWith(
          value: value,
          nextIndex: null,
          merged: merged,
          index: tile.nextIndex ?? tile.index));
      indexes.add(tiles.last.index);
    }
    if (tilesMoved) {
      tiles.add(random(indexes));
    }
    state = state.copyWith(score: score, tiles: tiles);
  }

  void _endRound() {
    var gameOver = true, gameWon = false;
    List<Tile> tiles = [];
    if (state.tiles.length == 16) {
      state.tiles.sort(((a, b) => a.index.compareTo(b.index)));
      for (int i = 0, l = state.tiles.length; i < l; i++) {
        var tile = state.tiles[i];
        if (tile.value == 2048) {
          gameWon = true;
        }
        var x = (i - (((i + 1) / 4).ceil() * 4 - 4));
        if (x > 0 && i - 1 >= 0) {
          var left = state.tiles[i - 1];
          if (tile.value == left.value) {
            gameOver = false;
          }
        }
        if (x < 3 && i + 1 < l) {
          var right = state.tiles[i + 1];
          if (tile.value == right.value) {
            gameOver = false;
          }
        }
        if (i - 4 >= 0) {
          var top = state.tiles[i - 4];
          if (tile.value == top.value) {
            gameOver = false;
          }
        }
        if (i + 4 < l) {
          var bottom = state.tiles[i + 4];
          if (tile.value == bottom.value) {
            gameOver = false;
          }
        }
        tiles.add(tile.copyWith(merged: false));
      }
    } else {
      gameOver = false;
      for (var tile in state.tiles) {
        if (tile.value == 2048) {
          gameWon = true;
        }
        tiles.add(tile.copyWith(merged: false));
      }
    }
    state =
        state.copyWith(tiles: tiles, isGameOver: gameOver, isGameWon: gameWon);
  }

  bool endRound() {
    _endRound();
    ref.read(roundManager.notifier).end();
    var nextDirection = ref.read(nextDirectionManager);
    if (nextDirection != null) {
      move(nextDirection);
      ref.read(nextDirectionManager.notifier).clear();
      return true;
    }
    return false;
  }

  void undo() {
    if (state.undo != null) {
      state = state.copyWith(
          score: state.undo!.score,
          highScore: state.undo!.highScore,
          tiles: state.undo!.tiles);
    } else {
      state = state.copyWith(undo: null);
    }
  }

  bool onKey(RawKeyEvent event) {
    SwipeDirection? direction;
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      direction = SwipeDirection.up;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      direction = SwipeDirection.down;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      direction = SwipeDirection.left;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      direction = SwipeDirection.right;
    }
    if (direction != null) {
      move(direction);
      return true;
    }
    return false;
  }

  void save() async {
    var box = await Hive.openBox<Board>('boardBox');
    try {
      box.putAt(0, state);
    } catch (e) {
      box.add(state);

      debugPrint('Error saving board: $e');
    }
  }
}

final boardManager = StateNotifierProvider<BoardManager, Board>((ref) {
  return BoardManager(ref);
});
