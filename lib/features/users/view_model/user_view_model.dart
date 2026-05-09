import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'user_view_model.g.dart';

@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<List<User>?>?>> getUsers({
    GetUsersRequest? request,
  }) {
    return ref.read(userRepositoryProvider).getUsers(req: request);
  }
}
