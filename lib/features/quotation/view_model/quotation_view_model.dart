import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'quotation_view_model.g.dart';

@riverpod
class QuotationViewModel extends _$QuotationViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<Quotation?>?>> createQuotation({
    required CreateQuotationRequest req,
  }) {
    return ref.read(quotationRepositoryProvider).createQuotation(request: req);
  }
}
