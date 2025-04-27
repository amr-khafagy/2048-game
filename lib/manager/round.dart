import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundManager extends StateNotifier<bool> {
  RoundManager() : super(true);
  void end() {
    state = true;
  }

  void start() {
    state = false;
  }
}

final roundManager = StateNotifierProvider<RoundManager, bool>((ref) {
  return RoundManager();
});
