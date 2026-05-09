import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_field_focus_node.dart';

class FocusNodeNotifier extends StateNotifier<List<FormFieldFocusNode>> {
  FocusNodeNotifier() : super([]);

  void addAll({required List<FormFields> fields}) {
    final nodes =
        fields
            .map(
              (field) =>
                  FormFieldFocusNode(field: field, focusNode: FocusNode()),
            )
            .toList();
    state = nodes;
  }

  void addFocusNode({required FormFields field}) {
    final node = FormFieldFocusNode(field: field, focusNode: FocusNode());
    state = [...state, node];
  }

  void removeFocusNode(int index) {
    state[index].focusNode.dispose();
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void removeAll() {
    disposeAll();
    state = [];
  }

  void disposeAll() {
    for (var node in state) {
      node.focusNode.dispose();
    }
  }

  void focusNext(BuildContext context, {required FormFields field}) {
    final index = state.indexWhere((element) => element.field == field);
    if (index != -1) {
      FocusScope.of(context).requestFocus(state[index].focusNode);
    }
  }

  void unFocus({required FormFields field}) {
    final index = state.indexWhere((element) => element.field == field);
    if (index != -1) {
      state[index].focusNode.unfocus();
    }
  }
}
