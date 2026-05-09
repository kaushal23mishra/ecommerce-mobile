import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/share_document_type.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

part 'share_document_view_model.g.dart';

@riverpod
class ShareDocumentViewModel extends _$ShareDocumentViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }
}

final shareDocumentsProvider = StateProvider<List<Document>>((ref) => []);
final shareFilteredDocumentsProvider = StateProvider<List<Document>>(
  (ref) => [],
);

final selectedShareDocumentsProvider = StateProvider<List<int>>((ref) => []);
final sendDocumentTypeProvider = StateProvider<ShareDocumentType?>(
  (ref) => null,
);
final sendDocumentFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
