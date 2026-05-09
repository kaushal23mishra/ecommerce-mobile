import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/domain/repositories/i_auth_repository.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/forgot_password_use_case.dart';
import 'package:salesdocket_core/src/network/app_error.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late ForgotPasswordUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(mockRepository);
  });

  group('ForgotPasswordUseCase', () {
    const tEmail = 'test@example.com';

    group('Successful forgot password', () {
      test(
        'should return success when email is valid and request succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.forgotPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => Result.success(data: null));

          // Act
          final result = await useCase(email: tEmail);

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (_) => {}, // Success expected
            failure: (_) => fail('Should not fail'),
          );

          verify(() => mockRepository.forgotPassword(email: tEmail)).called(1);
        },
      );

      test('should call repository with correct email', () async {
        // Arrange
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        await useCase(email: tEmail);

        // Assert
        verify(() => mockRepository.forgotPassword(email: tEmail)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('Email validation', () {
      test('should return failure when email is empty', () async {
        // Act
        final result = await useCase(email: '');

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Email cannot be empty'));
          },
        );

        verifyNever(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        );
      });

      test('should return failure when email format is invalid', () async {
        // Act
        final result = await useCase(email: 'invalid-email');

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('valid email address'));
          },
        );

        verifyNever(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        );
      });

      test('should return failure when email has no @ symbol', () async {
        // Act
        final result = await useCase(email: 'testexample.com');

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('valid email address'));
          },
        );

        verifyNever(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        );
      });

      test('should return failure when email has no domain', () async {
        // Act
        final result = await useCase(email: 'test@');

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('valid email address'));
          },
        );

        verifyNever(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        );
      });

      test(
        'should return failure when email has invalid domain format',
        () async {
          // Act
          final result = await useCase(email: 'test@example');

          // Assert
          expect(result.isFailure, true);
          result.when(
            success: (_) => fail('Should not succeed'),
            failure: (error) {
              expect(error.message, contains('valid email address'));
            },
          );

          verifyNever(
            () => mockRepository.forgotPassword(email: any(named: 'email')),
          );
        },
      );

      test(
        'should reject email with plus sign (not supported by regex)',
        () async {
          // Arrange
          const emailWithPlus = 'test+user@example.com';

          // Act
          final result = await useCase(email: emailWithPlus);

          // Assert
          expect(result.isFailure, true);
          result.when(
            success: (_) => fail('Should not succeed'),
            failure: (error) {
              expect(error.message, contains('valid email address'));
            },
          );

          verifyNever(
            () => mockRepository.forgotPassword(email: any(named: 'email')),
          );
        },
      );

      test('should accept valid email with subdomain', () async {
        // Arrange
        const validEmail = 'test@mail.example.com';
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result = await useCase(email: validEmail);

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockRepository.forgotPassword(email: validEmail),
        ).called(1);
      });

      test('should accept valid email with numbers and dots', () async {
        // Arrange
        const validEmail = 'user.123@example123.co';
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result = await useCase(email: validEmail);

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockRepository.forgotPassword(email: validEmail),
        ).called(1);
      });
    });

    group('Repository error handling', () {
      test(
        'should return failure when repository fails with network error',
        () async {
          // Arrange
          final tError = AppError(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionError,
            ),
          );
          when(
            () => mockRepository.forgotPassword(email: any(named: 'email')),
          ).thenAnswer((_) async => Result.failure(error: tError));

          // Act
          final result = await useCase(email: tEmail);

          // Assert
          expect(result.isFailure, true);
          result.when(
            success: (_) => fail('Should not succeed'),
            failure: (error) {
              expect(error.type, AppErrorType.network);
            },
          );
        },
      );

      test('should propagate server error', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 504, // Gateway Timeout triggers AppErrorType.server
              data: {
                'message': 'Gateway Timeout',
              }, // Data required for statusCode to be set
            ),
          ),
        );
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(email: tEmail);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.type, AppErrorType.server);
            expect(error.statusCode, 504);
          },
        );
      });

      test('should handle timeout error', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(email: tEmail);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.type, AppErrorType.timeout);
          },
        );
      });

      test('should handle email not found error (404)', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
              data: {'message': 'Email not found'},
            ),
          ),
        );
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(email: tEmail);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.statusCode, 404);
          },
        );
      });
    });

    group('Edge cases', () {
      test('should fail email validation when email has whitespace', () async {
        // Arrange
        const emailWithSpaces = '  test@example.com  ';

        // Act
        final result = await useCase(email: emailWithSpaces);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('valid email address'));
          },
        );

        verifyNever(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        );
      });

      test('should handle very long email', () async {
        // Arrange
        final longEmail = '${'a' * 50}@${'example' * 10}.com';
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result = await useCase(email: longEmail);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockRepository.forgotPassword(email: longEmail)).called(1);
      });

      test('should handle multiple consecutive calls', () async {
        // Arrange
        when(
          () => mockRepository.forgotPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result1 = await useCase(email: tEmail);
        final result2 = await useCase(email: 'other@example.com');
        final result3 = await useCase(email: tEmail);

        // Assert
        expect(result1.isSuccess, true);
        expect(result2.isSuccess, true);
        expect(result3.isSuccess, true);

        verify(() => mockRepository.forgotPassword(email: tEmail)).called(2);
        verify(
          () => mockRepository.forgotPassword(email: 'other@example.com'),
        ).called(1);
      });
    });
  });
}
