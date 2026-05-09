import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';

class FormFieldsErrorNotifier extends StateNotifier<List<FormFieldError>> {
  FormFieldsErrorNotifier() : super([]);

  void addAll(List<FormFieldError> errors) {
    state = [...state, ...errors];
  }

  void removeAll() {
    state = [];
  }

  void add(FormFieldError error) {
    state = [...state, error];
  }

  void remove(FormFields field) {
    final index = state.indexWhere((fieldError) => fieldError.field == field);
    if (index != -1) {
      state = [...state.sublist(0, index), ...state.sublist(index + 1)];
    }
  }

  void removeWhere(bool Function(FormFieldError element) test) {
    final index = state.indexWhere(test);
    if (index != -1) {
      state = [...state.sublist(0, index), ...state.sublist(index + 1)];
    }
  }

  FormFieldError? get(FormFields field) {
    return state.firstWhereOrNull((error) => error.field == field);
  }
}
