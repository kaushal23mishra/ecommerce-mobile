import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'ho_drawer_view_model.g.dart';

@Riverpod(keepAlive: true)
class HoDrawerViewModel extends _$HoDrawerViewModel {
  @override
  FutureOr<OrganizationNodeEntity?> build() async {
    // Auto-fetch on first load (cached permanently with keepAlive: true)
    return _fetchData();
  }

  /// Internal method to fetch data
  Future<OrganizationNodeEntity?> _fetchData() async {
    final result = await ref.read(ownerRepositoryProvider).getMyTree();

    return result.when(
      success: (data) => data,
      failure: (error) {
        // Set error state and return null
        state = AsyncValue.error(error, StackTrace.current);
        return null;
      },
    );
  }

  /// Public method to manually refresh data (e.g., pull to refresh)
  Future<void> fetchOrganizationTree() async {
    state = const AsyncValue.loading();

    final result = await ref.read(ownerRepositoryProvider).getMyTree();

    result.when(
      success: (data) {
        state = AsyncValue.data(data);
      },
      failure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  void clearData() {
    state = const AsyncValue.data(null);
  }
}
