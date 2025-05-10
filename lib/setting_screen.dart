import 'package:flutter/material.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({super.key});

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'High Score',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 40,
                color: Color(0xff64452d),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
