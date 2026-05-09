import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisibleStateNotifier extends StateNotifier<bool> {
  VisibleStateNotifier(super.state);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

final visibleStateProvider = StateNotifierProvider<VisibleStateNotifier, bool>(
  (ref) => VisibleStateNotifier(true),
);
