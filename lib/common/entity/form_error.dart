import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';

class FormFieldError {
  final FormFields field;
  final String? message;
  final int? index;

  FormFieldError({required this.field, this.message, this.index});
}

extension FromFieldErrorsExtension on List<FormFieldError> {
  FormFieldError? get(FormFields field) {
    return firstWhereOrNull((error) => error.field == field);
  }

  List<FormFieldError>? getAll(FormFields field) {
    return whereOrNull((error) => error.field == field)?.toList();
  }
}

extension LeadFromFieldErrorsExtension on Map<LeadFormFields, FormFieldError?> {
  bool get hasError {
    return values.any((value) => value != null);
  }
}
