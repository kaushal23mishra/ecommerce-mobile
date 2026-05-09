import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';
import 'package:salesdocket_core/src/domain/repositories/i_auth_repository.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:salesdocket_core/src/network/app_error.dart';

import '../../../../helpers/mock_data.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  group('SignInUseCase', () {
    const tUsername = 'test@example.com';
    const tPassword = 'password123';
    final tUser = MockData.createUserEntity();

    group('Successful sign in', () {
      test('should return UserEntity when credentials are valid', () async {
        // Arrange
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result = await useCase(username: tUsername, password: tPassword);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (user) {
            expect(user, isA<UserEntity>());
            expect(user?.id, tUser.id);
            expect(user?.firstName, tUser.firstName);
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(
          () => mockRepository.signIn(username: tUsername, password: tPassword),
        ).called(1);
      });

      test('should pass correct parameters to repository', () async {
        // Arrange
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        await useCase(username: tUsername, password: tPassword);

        // Assert
        verify(
          () => mockRepository.signIn(username: tUsername, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('Input validation', () {
      test('should return failure when username is empty', () async {
        // Act
        final result = await useCase(username: '', password: tPassword);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Username cannot be empty'));
          },
        );

        verifyNever(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      });

      test('should return failure when password is empty', () async {
        // Act
        final result = await useCase(username: tUsername, password: '');

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Password cannot be empty'));
          },
        );

        verifyNever(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      });

      test('should return failure when password is too short', () async {
        // Act
        final result = await useCase(
          username: tUsername,
          password: '12345', // Less than 6 characters
        );

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('at least 6 characters'));
          },
        );

        verifyNever(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        );
      });

      test('should accept password with exactly 6 characters', () async {
        // Arrange
        const validPassword = '123456';
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result = await useCase(
          username: tUsername,
          password: validPassword,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockRepository.signIn(
            username: tUsername,
            password: validPassword,
          ),
        ).called(1);
      });

      test('should pass username as-is without trimming', () async {
        // Arrange
        const usernameWithSpaces = '  test@example.com  ';
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        await useCase(username: usernameWithSpaces, password: tPassword);

        // Assert
        verify(
          () => mockRepository.signIn(
            username: usernameWithSpaces, // Passed as-is
            password: tPassword,
          ),
        ).called(1);
      });
    });

    group('Repository error handling', () {
      test('should return failure when repository fails', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(username: tUsername, password: tPassword);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.type, AppErrorType.network);
          },
        );
      });

      test('should propagate unauthorized error', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 401,
            ),
          ),
        );
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(username: tUsername, password: tPassword);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.type, AppErrorType.unauthorized);
          },
        );
      });

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
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(username: tUsername, password: tPassword);

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
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase(username: tUsername, password: tPassword);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.type, AppErrorType.timeout);
          },
        );
      });
    });

    group('Edge cases', () {
      test('should handle special characters in username', () async {
        // Arrange
        const specialUsername = 'test+user@example.com';
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result = await useCase(
          username: specialUsername,
          password: tPassword,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockRepository.signIn(
            username: specialUsername,
            password: tPassword,
          ),
        ).called(1);
      });

      test('should handle special characters in password', () async {
        // Arrange
        const specialPassword = 'P@ssw0rd!#\$%';
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result = await useCase(
          username: tUsername,
          password: specialPassword,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockRepository.signIn(
            username: tUsername,
            password: specialPassword,
          ),
        ).called(1);
      });

      test('should handle very long password', () async {
        // Arrange
        final longPassword = 'a' * 100;
        when(
          () => mockRepository.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result = await useCase(
          username: tUsername,
          password: longPassword,
        );

        // Assert
        expect(result.isSuccess, true);
      });
    });
  });
}
