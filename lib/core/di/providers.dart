import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/src/data/repositories/auth_repository_impl.dart';
import 'package:salesdocket_core/src/data_source/auth/remote/auth_data_source.dart';
import 'package:salesdocket_core/src/data_source/auth/remote/auth_data_source_impl.dart';
import 'package:salesdocket_core/src/domain/repositories/i_auth_repository.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/forgot_password_use_case.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/get_current_user_use_case.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:salesdocket_core/src/network/app_dio.dart';

part 'providers.g.dart';

// ═══════════════════════════════════════════════════
// NETWORK LAYER
// ═══════════════════════════════════════════════════

/// Provider for Dio instance
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = AppDio.getInstance();
  if (kDebugMode) {
    logDebug('Dio instance created');
  }
  return dio;
}

// ═══════════════════════════════════════════════════
// DATA SOURCES
// ═══════════════════════════════════════════════════

/// Provider for AuthDataSource
@Riverpod(keepAlive: true)
AuthDataSource authDataSource(Ref ref) {
  return AuthDataSourceImpl(dio: ref.read(dioProvider));
}

// ═══════════════════════════════════════════════════
// REPOSITORIES
// ═══════════════════════════════════════════════════

/// Provider for IAuthRepository
@Riverpod(keepAlive: true)
IAuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(dataSource: ref.read(authDataSourceProvider));
}

// ═══════════════════════════════════════════════════
// USE CASES - AUTH
// ═══════════════════════════════════════════════════

/// Provider for SignInUseCase
@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
}

/// Provider for ForgotPasswordUseCase
@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  return ForgotPasswordUseCase(ref.read(authRepositoryProvider));
}

/// Provider for GetCurrentUserUseCase
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
}

/// Provider for SignOutUseCase
@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
}
