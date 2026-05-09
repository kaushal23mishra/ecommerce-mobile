import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/constants/api_end_points.dart';
import 'package:salesdocket_core/src/data_source/auth/remote/auth_data_source_impl.dart';

import '../../../helpers/mock_data.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthDataSourceImpl dataSource;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthDataSourceImpl(dio: mockDio);
  });

  group('AuthDataSourceImpl', () {
    group('signIn', () {
      const tUsername = 'test@example.com';
      const tPassword = 'password123';
      final tUser = MockData.createUser(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
      );
      final tRequest = SignInRequest(username: tUsername, password: tPassword);

      test(
        'should make GET request to correct endpoint with query parameters',
        () async {
          // Arrange
          when(
            () => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: tUser.toJson(),
            ),
          );

          // Act
          await dataSource.singIn(tRequest);

          // Assert
          verify(
            () => mockDio.get(
              APIEndPoints.signIn,
              queryParameters: tRequest.toJson(),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test('should include headers from CacheManager', () async {
        // Note: CacheManager is a static class and cannot be easily mocked
        // This test verifies that headers are included (will be empty in test environment)

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: tUser.toJson(),
          ),
        );

        // Act
        await dataSource.singIn(tRequest);

        // Assert
        final captured =
            verify(
                  () => mockDio.get(
                    any(),
                    queryParameters: any(named: 'queryParameters'),
                    options: captureAny(named: 'options'),
                  ),
                ).captured.single
                as Options;

        expect(captured.headers, isNotNull);
        expect(
          captured.headers,
          containsPair(headerTokenKey, anyOf(isA<String>(), isNull)),
        );
        expect(
          captured.headers,
          containsPair(headerDeviceId, anyOf(isA<String>(), isNull)),
        );
      });

      test('should return User when response data is valid', () async {
        // Arrange
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: tUser.toJson(),
          ),
        );

        // Act
        final result = await dataSource.singIn(tRequest);

        // Assert
        expect(result, isA<User>());
        expect(result?.id, tUser.id);
        expect(result?.firstName, tUser.firstName);
      });

      test('should return null when response data is null', () async {
        // Arrange
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async =>
              Response(requestOptions: RequestOptions(path: ''), data: null),
        );

        // Act
        final result = await dataSource.singIn(tRequest);

        // Assert
        expect(result, isNull);
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );

        // Act & Assert
        expect(() => dataSource.singIn(tRequest), throwsA(isA<DioException>()));
      });
    });

    group('forgotPassword', () {
      const tEmail = 'test@example.com';
      final tRequest = ForgotPasswordRequest(email: tEmail);

      test('should make POST request to correct endpoint', () async {
        // Arrange
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'message': 'Success'},
          ),
        );

        // Act
        await dataSource.forgotPassword(tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            APIEndPoints.forgotPassword,
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('should send request body as JSON encoded string', () async {
        // Arrange
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {'message': 'Success'},
          ),
        );

        // Act
        await dataSource.forgotPassword(tRequest);

        // Assert
        final captured =
            verify(
              () => mockDio.post<Map<String, dynamic>>(
                any(),
                data: captureAny(named: 'data'),
              ),
            ).captured.single;

        expect(captured, isA<String>());
        expect(captured, contains(tEmail));
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
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

        // Act & Assert
        expect(
          () => dataSource.forgotPassword(tRequest),
          throwsA(isA<DioException>()),
        );
      });

      test('should handle timeout error', () async {
        // Arrange
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.forgotPassword(tRequest),
          throwsA(
            isA<DioException>().having(
              (e) => e.type,
              'type',
              DioExceptionType.connectionTimeout,
            ),
          ),
        );
      });

      test('should handle server error response', () async {
        // Arrange
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
              data: {'message': 'Internal Server Error'},
            ),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.forgotPassword(tRequest),
          throwsA(
            isA<DioException>().having(
              (e) => e.response?.statusCode,
              'statusCode',
              500,
            ),
          ),
        );
      });
    });
  });
}
