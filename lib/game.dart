import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:game/component/empty_board.dart';
import 'package:game/component/score_board.dart';
import 'package:game/component/tile_board.dart';
import 'package:game/const/colors.dart';
import 'package:game/manager/board_manager.dart';

class Game extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameState();
}

class _GameState extends ConsumerState<Game>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _moveController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100))
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(boardManager.notifier).merge();
        _scaleController.forward(from: 0.0);
      }
    });
  late final AnimationController _scaleController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 100))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (ref.read(boardManager.notifier).endRound()) {
              _moveController.forward(from: 0.0);
            }
          }
        });
  late final CurvedAnimation _moveAnimation =
      CurvedAnimation(parent: _moveController, curve: Curves.easeInOut);
  late final CurvedAnimation _scaleAnimation =
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut);
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (ref.read(boardManager.notifier).onKey(event)) {
            _moveController.forward(from: 0.0);
          }
        },
        child: SwipeDetector(
            onSwipe: (direction, Offset) {
              if (ref.read(boardManager.notifier).move(direction)) {
                _moveController.forward(from: 0.0);
              }
            },
            child: Scaffold(
              backgroundColor: Color(0xffeee3d2),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, right: 20, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '2048',
                            style: TextStyle(
                                color: Color(0xff645544),
                                fontWeight: FontWeight.bold,
                                fontSize: 52),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ScoreBoard(),
                              const SizedBox(
                                height: 32.0,
                              ),
                              // Row(
                              //   children: [
                              //     ButtonWidget(
                              //       onPressed: () {
                              //         ref.read(boardManager.notifier).undo();
                              //       },
                              //       icon: Icons.undo,
                              //     ),
                              //     const SizedBox(
                              //       width: 16,
                              //     ),
                              //     // ButtonWidget(
                              //     //   onPressed: () {
                              //     //     ref.read(boardManager.notifier).newGame();
                              //     //   },
                              //     //   icon: Icons.refresh,
                              //     // )
                              //   ],
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Stack(
                      children: [
                        const EmptyBoard(),
                        TileBoard(
                            moveAnimation: _moveAnimation,
                            scaleAnimation: _scaleAnimation)
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
