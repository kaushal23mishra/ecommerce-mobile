import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'accessories_view_model.g.dart';

@riverpod
class AccessoriesViewModel extends _$AccessoriesViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<List<Accessory>?>?>> getAccessories({
    required int productId,
  }) {
    return ref
        .read(productRepositoryProvider)
        .getAccessories(productId: productId);
  }
}

final getAccessoriesLeadProvider = StateProvider<Lead?>((ref) => null);
final accessoriesProvider = StateProvider<List<Accessory>>((ref) => []);

final selectedAccessoriesProvider = StateProvider<List<Accessory>>((ref) => []);
