import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';

part 'schemes_view_model.g.dart';

@riverpod
class SchemesViewModel extends _$SchemesViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<List<Scheme>?>?>> getSchemes({
    required int productId,
    GetSchemesRequest? req,
  }) {
    return ref
        .read(productRepositoryProvider)
        .getSchemes(productId: productId, request: req);
  }
}

final getSchemesLeadProvider = StateProvider<Lead?>((ref) => null);
final getSchemesRequestProvider = StateProvider<GetSchemesRequest?>(
  (ref) => null,
);
final schemesProvider = StateProvider<List<Scheme>>((ref) => []);

final brokerLoadingProvider = StateNotifierProvider<LoadingStateNotifier, bool>(
  (ref) => LoadingStateNotifier(),
);
final selectedSchemesProvider = StateProvider<List<Scheme>>((ref) => []);
final schemesBrokerProvider = StateProvider<Brokerage?>((ref) => null);
final updatedBrokerProvider = StateProvider<Brokerage?>((ref) => null);
final brokerFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
