import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/const/colors.dart';

class EmptyBoard extends StatelessWidget {
  const EmptyBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));
    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;
    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
          color: boardColor, borderRadius: BorderRadius.circular(6)),
      child: Stack(
        children: List.generate(16, (i) {
          var x = ((i + 1) / 4).ceil();
          var y = x - 1;
          var top = y * (tileSize) + (x * 12.0);
          var z = (i - (4 * y));
          var left = z * (tileSize) + ((z + 1) * 12.0);
          return Positioned(
              top: top,
              left: left,
              child: Container(
                width: tileSize,
                height: tileSize,
                decoration: BoxDecoration(
                    color: emptyTileColor,
                    borderRadius: BorderRadius.circular(6)),
              ));
        }),
      ),
    );
  }
}
