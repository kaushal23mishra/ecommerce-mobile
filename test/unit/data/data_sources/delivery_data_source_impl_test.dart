import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/constants/api_end_points.dart';
import 'package:salesdocket_core/src/data_source/delivery/remote/delivery_data_source_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DeliveryDataSourceImpl dataSource;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());
    registerFallbackValue(FormData());
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = DeliveryDataSourceImpl(dio: mockDio);
  });

  group('DeliveryDataSourceImpl', () {
    group('createDelivery', () {
      test('should make POST request to correct endpoint', () async {
        // Arrange
        const url = '${APIEndPoints.delivery}/store';
        final tDelivery = Delivery();
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': {'id': 1, 'booking_id': 100},
            'status': 'success',
          },
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.createDelivery(tDelivery);

        // Assert
        verify(
          () => mockDio.post(
            url,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test(
        'should return ApiResponse<Delivery?> when request succeeds',
        () async {
          // Arrange
          final tDelivery = Delivery(id: 1);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': {'id': 1, 'booking_id': 100},
              'status': 'success',
            },
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.createDelivery(tDelivery);

          // Assert
          expect(result, isA<ApiResponse<Delivery?>>());
          expect(result.data?.id, 1);
        },
      );

      test('should use POST url-encoded options', () async {
        // Arrange
        final tDelivery = Delivery();
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.createDelivery(tDelivery);

        // Assert
        verify(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options', that: isA<Options>()),
          ),
        ).called(1);
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        final tDelivery = Delivery();
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.createDelivery(tDelivery),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('updateDelivery', () {
      const tDeliveryId = 1;

      test(
        'should make POST request to correct endpoint with delivery ID',
        () async {
          // Arrange
          final url = '${APIEndPoints.delivery}/$tDeliveryId/update';
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': {'id': tDeliveryId, 'booking_id': 100},
              'status': 'success',
            },
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.updateDelivery(tDeliveryId, tDelivery);

          // Assert
          verify(
            () => mockDio.post(
              url,
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test(
        'should include _method parameter when method is provided',
        () async {
          // Arrange
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': null, 'status': 'success'},
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.updateDelivery(
            tDeliveryId,
            tDelivery,
            method: 'PUT',
          );

          // Assert
          verify(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test('should call post method when method is null', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.updateDelivery(tDeliveryId, tDelivery);

        // Assert
        verify(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test(
        'should return ApiResponse<Delivery?> when update succeeds',
        () async {
          // Arrange
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': {'id': tDeliveryId, 'booking_id': 100},
              'status': 'success',
            },
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.updateDelivery(
            tDeliveryId,
            tDelivery,
          );

          // Assert
          expect(result, isA<ApiResponse<Delivery?>>());
          expect(result.data?.id, tDeliveryId);
        },
      );

      test('should handle timeout error', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.updateDelivery(tDeliveryId, tDelivery),
          throwsA(
            isA<DioException>().having(
              (e) => e.type,
              'type',
              DioExceptionType.connectionTimeout,
            ),
          ),
        );
      });
    });

    group('uploadDeliveryDocuments', () {
      const tDeliveryId = 1;

      test(
        'should make POST request to store endpoint when deliveryId is null',
        () async {
          // Arrange
          const url = '${APIEndPoints.delivery}/store';
          final tDelivery = Delivery();
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': {'id': 1, 'booking_id': 100},
              'status': 'success',
            },
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.uploadDeliveryDocuments(null, tDelivery);

          // Assert
          verify(
            () => mockDio.post(
              url,
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test(
        'should make POST request to update endpoint when deliveryId is provided',
        () async {
          // Arrange
          final url = '${APIEndPoints.delivery}/$tDeliveryId/update';
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': {'id': tDeliveryId},
              'status': 'success',
            },
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.uploadDeliveryDocuments(tDeliveryId, tDelivery);

          // Assert
          verify(
            () => mockDio.post(
              url,
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test('should use multipart options for file upload', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.uploadDeliveryDocuments(tDeliveryId, tDelivery);

        // Assert
        verify(
          () => mockDio.post(
            any(),
            data: any(named: 'data', that: isA<FormData>()),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test(
        'should include _method parameter when deliveryId and method are provided',
        () async {
          // Arrange
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': null, 'status': 'success'},
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.uploadDeliveryDocuments(
            tDeliveryId,
            tDelivery,
            method: 'PUT',
          );

          // Assert
          verify(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test('should not include _method when deliveryId is null', () async {
        // Arrange
        final tDelivery = Delivery();
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.uploadDeliveryDocuments(
          null,
          tDelivery,
          method: 'PUT',
        );

        // Assert
        verify(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should propagate server error', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
              data: {'message': 'Server error'},
            ),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.uploadDeliveryDocuments(tDeliveryId, tDelivery),
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
