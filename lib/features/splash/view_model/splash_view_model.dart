import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/network/models/app/check_updates_request.dart';
import 'package:salesdocket_core/src/network/models/app/check_updates_response.dart';
import 'package:salesdocket_core/src/network/models/common/result.dart';
import 'package:salesdocket_core/src/providers/app/app_repository_provider.dart';

part 'splash_view_model.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  FutureOr<void> build() {}

  Future<Result<ApiResponse<List<CheckUpdatesResponse>>?>> checkUpdates(
      CheckUpdatesRequest req) {
    return ref.read(appRepositoryProvider).checkUpdates(req);
  }
}
