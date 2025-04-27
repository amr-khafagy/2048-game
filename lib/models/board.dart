// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import 'package:game/models/tile.dart';

part 'board.g.dart'; // Add this line

@JsonSerializable(explicitToJson: true, anyMap: true)
class Board {
  final int score;
  final int highScore;
  final List<Tile> tiles;
  final bool isGameOver;
  final bool isGameWon;
  final Board? undo;

  Board(this.score, this.highScore, this.tiles,
      {this.isGameOver = false, this.isGameWon = false, this.undo});

  Board.newGame(this.highScore, this.tiles)
      : score = 0,
        isGameOver = false,
        isGameWon = false,
        undo = null;

  Board copyWith(
          {int? score,
          int? highScore,
          List<Tile>? tiles,
          bool? isGameOver,
          bool? isGameWon,
          Board? undo}) =>
      Board(
        score ?? this.score,
        highScore ?? this.highScore,
        tiles ?? this.tiles,
        isGameOver: isGameOver ?? this.isGameOver,
        isGameWon: isGameWon ?? this.isGameWon,
        undo: undo ?? this.undo,
      );

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}
