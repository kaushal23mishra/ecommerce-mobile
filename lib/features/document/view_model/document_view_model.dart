import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'document_view_model.g.dart';

@riverpod
class DocumentViewModel extends _$DocumentViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<ApiResponse<List<Document>?>?>?>> getDocuments({
    GetDocumentsRequest? request,
  }) {
    return ref.read(documentRepositoryProvider).getDocuments(request);
  }

  Future<Result<ApiResponse?>> sendDocuments({SendDocumentsRequest? request}) {
    return ref.read(documentRepositoryProvider).sendDocuments(request);
  }
}
