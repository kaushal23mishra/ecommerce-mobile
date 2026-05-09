import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/network/app_error.dart';

/// Custom matchers for Result types
const Matcher isSuccess = TypeMatcher<Success>();
const Matcher isFailure = TypeMatcher<Failure>();

/// Matcher for checking AppError message
Matcher hasErrorMessage(String expectedMessage) {
  return predicate<AppError>(
    (error) => error.message?.contains(expectedMessage) ?? false,
    'has error message containing "$expectedMessage"',
  );
}

/// Matcher for checking AppError type
Matcher hasErrorType(AppErrorType expectedType) {
  return predicate<AppError>(
    (error) => error.type == expectedType,
    'has error type $expectedType',
  );
}

/// Matcher for Result success with specific data
Matcher hasSuccessData<T>(T expectedData) {
  return predicate<Result<T>>((result) {
    if (result is! Success<T>) return false;
    return result.data == expectedData;
  }, 'has success data equal to $expectedData');
}
