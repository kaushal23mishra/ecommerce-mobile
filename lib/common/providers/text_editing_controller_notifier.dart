import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldControllerNotifier
    extends StateNotifier<List<TextEditingController>> {
  TextFieldControllerNotifier() : super([]);
  final Map<int, void Function(String)> _listeners = {};

  void addController({String? text, void Function(String)? onChanged}) {
    final controller = TextEditingController(text: text ?? "");
    if (onChanged != null) {
      final index = state.length;
      _listeners[index] = onChanged;
      controller.addListener(() {
        _listeners[index]?.call(controller.text);
      });
    }
    state = [...state, controller];
  }

  void removeController(int index) {
    state[index].dispose();
    _listeners.remove(index);
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void removeAll() {
    disposeAll();
    state = [];
  }

  void disposeAll() {
    for (var controller in state) {
      controller.dispose();
    }
    _listeners.clear();
  }
}
