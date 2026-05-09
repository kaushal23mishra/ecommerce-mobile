import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/domain/repositories/i_auth_repository.dart';
import 'package:salesdocket_core/src/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:salesdocket_core/src/network/app_error.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late SignOutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOutUseCase(mockRepository);
  });

  group('SignOutUseCase', () {
    group('Successful sign out', () {
      test('should return success when sign out succeeds', () async {
        // Arrange
        when(
          () => mockRepository.signOut(),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (_) => {}, // Success expected
          failure: (_) => fail('Should not fail'),
        );

        verify(() => mockRepository.signOut()).called(1);
      });

      test('should call repository signOut method', () async {
        // Arrange
        when(
          () => mockRepository.signOut(),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('Repository errors', () {
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
            () => mockRepository.signOut(),
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
        },
      );

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
          () => mockRepository.signOut(),
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

      test('should handle timeout error', () async {
        // Arrange
        final tError = AppError(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );
        when(
          () => mockRepository.signOut(),
        ).thenAnswer((_) async => Result.failure(error: tError));

        // Act
        final result = await useCase();

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

    group('Multiple calls', () {
      test('should handle multiple sign out calls', () async {
        // Arrange
        when(
          () => mockRepository.signOut(),
        ).thenAnswer((_) async => Result.success(data: null));

        // Act
        final result1 = await useCase();
        final result2 = await useCase();

        // Assert
        expect(result1.isSuccess, true);
        expect(result2.isSuccess, true);

        verify(() => mockRepository.signOut()).called(2);
      });
    });
  });
}
