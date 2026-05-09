import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/data/repositories/auth_repository_impl.dart';
import 'package:salesdocket_core/src/data_source/auth/remote/auth_data_source.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';

import '../../../helpers/mock_data.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late MockAuthDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(SignInRequest(username: '', password: ''));
    registerFallbackValue(ForgotPasswordRequest(email: ''));
  });

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(dataSource: mockDataSource);
  });

  group('AuthRepositoryImpl', () {
    group('signIn', () {
      const tUsername = 'test@example.com';
      const tPassword = 'password123';
      final tUser = MockData.createUser(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
      );

      test('should return UserEntity when sign in succeeds', () async {
        // Arrange
        when(() => mockDataSource.singIn(any())).thenAnswer((_) async => tUser);

        // Act
        final result = await repository.signIn(
          username: tUsername,
          password: tPassword,
        );

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
          () => mockDataSource.singIn(
            any(
              that: isA<SignInRequest>()
                  .having((r) => r.username, 'username', tUsername)
                  .having((r) => r.password, 'password', tPassword),
            ),
          ),
        ).called(1);
      });

      test('should return failure when data source returns null', () async {
        // Arrange
        when(() => mockDataSource.singIn(any())).thenAnswer((_) async => null);

        // Act
        final result = await repository.signIn(
          username: tUsername,
          password: tPassword,
        );

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Invalid credentials'));
          },
        );
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        when(
          () => mockDataSource.singIn(any()),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.signIn(
          username: tUsername,
          password: tPassword,
        );

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Network error'));
          },
        );
      });

      test('should pass correct parameters to data source', () async {
        // Arrange
        when(() => mockDataSource.singIn(any())).thenAnswer((_) async => tUser);

        // Act
        await repository.signIn(username: tUsername, password: tPassword);

        // Assert
        final captured =
            verify(() => mockDataSource.singIn(captureAny())).captured.single
                as SignInRequest;
        expect(captured.username, tUsername);
        expect(captured.password, tPassword);
      });
    });

    group('forgotPassword', () {
      const tEmail = 'test@example.com';

      test('should call data source with correct email', () async {
        // Arrange
        when(
          () => mockDataSource.forgotPassword(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.forgotPassword(email: tEmail);

        // Assert
        expect(result.isSuccess, true);
        final captured =
            verify(
                  () => mockDataSource.forgotPassword(captureAny()),
                ).captured.single
                as ForgotPasswordRequest;
        expect(captured.email, tEmail);
      });

      test('should return success when data source succeeds', () async {
        // Arrange
        when(
          () => mockDataSource.forgotPassword(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.forgotPassword(email: tEmail);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.forgotPassword(any())).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        when(
          () => mockDataSource.forgotPassword(any()),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.forgotPassword(email: tEmail);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Network error'));
          },
        );
      });
    });

    group('getCurrentUser', () {
      test('should call CacheManager to get cached user', () async {
        // Note: CacheManager is a static class and cannot be easily mocked
        // This test verifies the method executes without throwing

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isSuccess, true);
        // Result will be null in test environment due to empty cache
        result.when(
          success: (user) => expect(user, isNull),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('signOut', () {
      test('should call CacheManager to clear token and profile', () async {
        // Note: CacheManager is a static class and cannot be easily mocked
        // This test verifies the method executes without throwing

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result.isSuccess, true);
      });
    });

    group('isAuthenticated', () {
      test('should check CacheManager for token', () async {
        // Note: CacheManager is a static class and cannot be easily mocked
        // This test verifies the method executes without throwing

        // Act
        final result = await repository.isAuthenticated();

        // Assert
        // Will be false in test environment due to empty cache
        expect(result, false);
      });
    });
  });
}
