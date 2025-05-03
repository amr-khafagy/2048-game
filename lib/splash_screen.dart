import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/game.dart';
import 'package:game/manager/board_manager.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _moveController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100))
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(boardManager.notifier).merge();
        _scaleController.forward(from: 0.0);
      }
    });
  late final AnimationController _scaleController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100))
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (ref.read(boardManager.notifier).endRound()) {
          _moveController.forward(from: 0.0);
        }
      }
    });

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '2048',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Color(0xFF776E65),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Join the numbers and get to the 2048 tile!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Color(0xFF776E65)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(boardManager.notifier).newGame();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Game()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8F7A66),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Game()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8F7A66),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Setting',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8F7A66),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
