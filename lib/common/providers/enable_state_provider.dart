import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnableStateNotifier extends StateNotifier<bool> {
  EnableStateNotifier(super.state);

  void enable() {
    state = true;
  }

  void disable() {
    state = false;
  }
}

final enableStateProvider = StateNotifierProvider<EnableStateNotifier, bool>(
  (ref) => EnableStateNotifier(true),
);
