import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';
import 'package:salesdocket_core/src/domain/repositories/i_auth_repository.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/get_current_user_use_case.dart';
import 'package:salesdocket_core/src/network/app_error.dart';

import '../../../../helpers/mock_data.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late GetCurrentUserUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  group('GetCurrentUserUseCase', () {
    group('Successful retrieval', () {
      test('should return UserEntity when user is authenticated', () async {
        // Arrange
        final tUser = MockData.createUserEntity(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result = await useCase();

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

        verify(() => mockRepository.getCurrentUser()).called(1);
      });

      test('should return null when no user is authenticated', () async {
        // Arrange
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (user) => expect(user, isNull),
          failure: (_) => fail('Should not fail'),
        );

        verify(() => mockRepository.getCurrentUser()).called(1);
      });
    });

    group('Repository errors', () {
      test('should return failure when repository fails', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase();

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
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.type, AppErrorType.unauthorized);
          },
        );
      });
    });

    group('Multiple calls', () {
      test('should handle multiple successive calls', () async {
        // Arrange
        final tUser = MockData.createUserEntity(id: 1);
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.success(data: tUser));

        // Act
        final result1 = await useCase();
        final result2 = await useCase();
        final result3 = await useCase();

        // Assert
        expect(result1.isSuccess, true);
        expect(result2.isSuccess, true);
        expect(result3.isSuccess, true);

        verify(() => mockRepository.getCurrentUser()).called(3);
      });
    });
  });
}
