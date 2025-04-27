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
        ),
        const SizedBox(
          width: 10,
        ),
        Score(label: 'High Score', score: highScore.toString())
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
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          color: scoreColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: color2),
          ),
          Text(
            score.toString(),
            style: const TextStyle(fontSize: 15, color: color2),
          )
        ],
      ),
    );
  }
}
