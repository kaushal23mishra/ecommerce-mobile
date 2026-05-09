import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form_provider.freezed.dart';
part 'login_form_provider.g.dart';

/// Login form state
@freezed
class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String username,
    @Default('') String password,
    @Default({}) Map<String, String> errors,
    @Default(false) bool obscurePassword,
  }) = _LoginFormState;

  const LoginFormState._();

  bool get isValid =>
      errors.isEmpty && username.isNotEmpty && password.isNotEmpty;

  bool get hasErrors => errors.isNotEmpty;
}

/// Login form provider
@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  /// Update username
  void updateUsername(String username) {
    state = state.copyWith(username: username);
    _validateUsername(username);
  }

  /// Update password
  void updatePassword(String password) {
    state = state.copyWith(password: password);
    _validatePassword(password);
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Validate username
  void _validateUsername(String username) {
    final errors = Map<String, String>.from(state.errors);

    if (username.isEmpty) {
      errors['username'] = 'Username is required';
    } else {
      errors.remove('username');
    }

    state = state.copyWith(errors: errors);
  }

  /// Validate password
  void _validatePassword(String password) {
    final errors = Map<String, String>.from(state.errors);

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    } else {
      errors.remove('password');
    }

    state = state.copyWith(errors: errors);
  }

  /// Validate all fields
  bool validateAll() {
    _validateUsername(state.username);
    _validatePassword(state.password);
    return state.isValid;
  }

  /// Reset form
  void reset() {
    state = const LoginFormState();
  }
}
