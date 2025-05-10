import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/const/colors.dart';
import 'package:game/manager/board_manager.dart';

class ScoreBoard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(boardManager.select((board) => board.score));
    final highScore =
        ref.watch(boardManager.select((selector) => selector.highScore));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Score(
          label: 'score',
          score: score.toString(),
          // padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        const SizedBox(
          width: 10,
        ),
        // Score(label: 'High Score', score: highScore.toString())
      ],
    );
  }
}

class Score extends StatelessWidget {
  final String score;
  final EdgeInsets? padding;
  final String label;
  const Score(
      {super.key, required this.score, this.padding, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
          color: scoreColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 30,
                color: Color(0xff5d4c39),
                fontWeight: FontWeight.bold),
          ),
          Text(
            score.toString(),
            style: const TextStyle(
                fontSize: 30,
                color: Color(0xff5d4c39),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
