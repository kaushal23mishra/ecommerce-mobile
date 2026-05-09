import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';

extension DynamicNullableExtensions on Object? {
  bool get isNull {
    return this == null;
  }

  bool get isNotNull {
    return this != null;
  }
}

extension DynamicExtensions on Object {
  bool equals<T>(T value) {
    return this == value;
  }
}

extension IterableExtensions<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.first;
  }

  T? lastWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.last;
  }

  Iterable<T>? whereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list;
  }
}

extension JsonExtensions on Map<String, dynamic> {
  Map<String, dynamic> get filteredJsonRequest {
    final data = this;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

extension MenuItemExtension on List<MenuItem> {
  List<MenuItem> get filteredNonEmptyItems {
    return where(
      (item) => item.subtitle != null && (item.subtitle)!.trim().isNotEmpty,
    ).toList();
  }
}

extension FormErrorFieldsExtensions on List<FormFieldError> {
  String get firstErrorMessage {
    return isEmpty ? "" : first.message ?? "";
  }
}
