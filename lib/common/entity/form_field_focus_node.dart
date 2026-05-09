import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';

class FormFieldFocusNode {
  final FormFields field;
  final FocusNode focusNode;

  FormFieldFocusNode({required this.field, required this.focusNode});
}

extension FromFieldErrorsExtension on List<FormFieldFocusNode> {
  FormFieldFocusNode? get(FormFields field) {
    return firstWhereOrNull((node) => node.field == field);
  }

  List<FormFieldFocusNode>? getAll(FormFields field) {
    return whereOrNull((node) => node.field == field)?.toList();
  }
}
