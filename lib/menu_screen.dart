import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/game.dart';
import 'package:game/manager/board_manager.dart';
import 'package:game/setting_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
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
      backgroundColor: const Color(0xfffef4de),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffe79d5d),
                ),
                child: const Center(
                  child: Text(
                    '2048',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfffef3e2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Join the numbers and get to the 2048 tile!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 40,
                  color: Color(0xff64452d),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(boardManager.notifier).newGame();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Game()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff0d6b1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                'Start Game',
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0xff5f4225),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff0d6b1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                'Exit',
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0xff5f4225),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
