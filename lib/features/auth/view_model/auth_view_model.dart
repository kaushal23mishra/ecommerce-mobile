import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/providers/visible_state_provider.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<User?>> signIn(SignInRequest req) {
    return ref.read(authRepositoryProvider).signIn(req);
  }

  Future<Result> forgotPassword({required String email}) {
    return ref
        .read(authRepositoryProvider)
        .forgotPassword(ForgotPasswordRequest(email: email));
  }

  Future<Result> updateAppId(UpdateAppIdRequest req) {
    return ref.read(authRepositoryProvider).updateAppId(req);
  }

  Future<Result> removeAppId() {
    return ref.read(authRepositoryProvider).removeAppId();
  }
}

final passwordVisibleProvider =
    StateNotifierProvider<VisibleStateNotifier, bool>(
      (ref) => VisibleStateNotifier(false),
    );

final loginLoadingProvider = StateNotifierProvider<LoadingStateNotifier, bool>(
  (ref) => LoadingStateNotifier(),
);

final forgotPasswordLoadingProvider =
    StateNotifierProvider<LoadingStateNotifier, bool>(
      (ref) => LoadingStateNotifier(),
    );
