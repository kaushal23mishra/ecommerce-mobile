import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';
import 'package:salesdocket_mobile/core/di/providers.dart';
import 'package:salesdocket_mobile/core/error/error_handler.dart';

part 'auth_state_provider.freezed.dart';
part 'auth_state_provider.g.dart';

/// Authentication state
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserEntity? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => user != null;
}

/// Auth state provider using AsyncNotifierProvider
@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    // Check if user is already authenticated on startup
    final useCase = ref.read(getCurrentUserUseCaseProvider);
    final result = await useCase();

    return result.when(
      success: (user) => AuthState(user: user),
      failure: (_) => const AuthState(),
    );
  }

  /// Sign in with username and password
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(signInUseCaseProvider);
      final result = await useCase(username: username, password: password);

      return result.when(
        success: (user) {
          if (user == null) {
            throw Exception('Sign in failed');
          }
          return AuthState(user: user);
        },
        failure: (error) {
          ref.read(errorHandlerProvider).handle(error);
          throw error.message ?? 'Sign in failed';
        },
      );
    });
  }

  /// Sign out current user
  Future<void> signOut() async {
    final useCase = ref.read(signOutUseCaseProvider);
    final result = await useCase();

    result.when(
      success: (_) {
        state = const AsyncData(AuthState());
      },
      failure: (error) {
        ref.read(errorHandlerProvider).handle(error);
      },
    );
  }

  /// Refresh current user data
  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getCurrentUserUseCaseProvider);
      final result = await useCase();

      return result.when(
        success: (user) => AuthState(user: user),
        failure: (error) {
          ref.read(errorHandlerProvider).handle(error);
          return const AuthState();
        },
      );
    });
  }
}

/// Convenience provider to check if user is authenticated
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (state) => state.isAuthenticated,
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Convenience provider to get current user
@riverpod
UserEntity? currentUser(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (state) => state.user,
    loading: () => null,
    error: (_, __) => null,
  );
}
