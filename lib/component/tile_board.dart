import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/component/animated_tile.dart';
import 'package:game/component/button_widget.dart';
import 'package:game/const/colors.dart';
import 'package:game/manager/board_manager.dart';

class TileBoard extends ConsumerWidget {
  final CurvedAnimation moveAnimation;
  final CurvedAnimation scaleAnimation;
  TileBoard(
      {super.key, required this.moveAnimation, required this.scaleAnimation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(boardManager);
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boarSize = sizePerTile * 4;
    return SizedBox(
      width: boarSize,
      height: boarSize,
      child: Stack(
        children: [
          ...List.generate(board.tiles.length, (i) {
            var tile = board.tiles[i];
            return AnimatedTile(
                key: ValueKey(tile.id),
                size: tileSize,
                tile: tile,
                moveAnimation: moveAnimation,
                scaleAnimation: scaleAnimation,
                child: Container(
                  width: tileSize,
                  height: tileSize,
                  decoration: BoxDecoration(
                      color: tileColors[tile.value],
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Center(
                      child: Text(
                    '${tile.value}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: tile.value < 8 ? textColor : textColorWhite),
                  )),
                ));
          }),
          if (board.isGameOver)
            Positioned.fill(
                child: Container(
              color: overlayColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    board.isGameWon ? 'You win!' : 'Game over!',
                    style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 64.0),
                  ),
                  ButtonWidget(
                    text: board.isGameWon ? 'New Game' : 'Try again',
                    onPressed: () {
                      ref.read(boardManager.notifier).newGame();
                    },
                  )
                ],
              ),
            ))
        ],
      ),
    );
  }
}
