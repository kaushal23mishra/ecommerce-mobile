import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/data_source/delivery/remote/delivery_data_source.dart';
import 'package:salesdocket_core/src/repository/delivery/delivery_repository_impl.dart';

import '../../../helpers/mock_data.dart';

class MockDeliveryDataSource extends Mock implements DeliveryDataSource {}

void main() {
  late MockDeliveryDataSource mockDataSource;
  late DeliveryRepositoryImpl repository;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(Delivery());
  });

  setUp(() {
    mockDataSource = MockDeliveryDataSource();
    repository = DeliveryRepositoryImpl(dataSource: mockDataSource);
  });

  group('DeliveryRepositoryImpl', () {
    group('createDelivery', () {
      test(
        'should return ApiResponse<Delivery?> when delivery creation succeeds',
        () async {
          // Arrange
          final tDelivery = Delivery(id: 1);
          final tResponse = MockData.createApiResponse(tDelivery);

          when(
            () => mockDataSource.createDelivery(any()),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.createDelivery(req: tDelivery);

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data?.id, tDelivery.id);
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(() => mockDataSource.createDelivery(tDelivery)).called(1);
        },
      );

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tDelivery = Delivery();
        when(
          () => mockDataSource.createDelivery(any()),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.createDelivery(req: tDelivery);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Network error'));
          },
        );
      });

      test('should handle null delivery request', () async {
        // Arrange
        final tResponse = MockData.createApiResponse<Delivery?>(null);
        when(
          () => mockDataSource.createDelivery(any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.createDelivery(req: null);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.createDelivery(null)).called(1);
      });
    });

    group('updateDelivery', () {
      const tDeliveryId = 1;

      test(
        'should return ApiResponse<Delivery?> when delivery update succeeds',
        () async {
          // Arrange
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = MockData.createApiResponse(tDelivery);

          when(
            () => mockDataSource.updateDelivery(
              any(),
              any(),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.updateDelivery(
            deliveryId: tDeliveryId,
            req: tDelivery,
            method: 'PUT',
          );

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data?.id, tDeliveryId);
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(
            () => mockDataSource.updateDelivery(
              tDeliveryId,
              tDelivery,
              method: 'PUT',
            ),
          ).called(1);
        },
      );

      test('should pass correct parameters to data source', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        final tResponse = MockData.createApiResponse(tDelivery);

        when(
          () => mockDataSource.updateDelivery(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.updateDelivery(
          deliveryId: tDeliveryId,
          req: tDelivery,
          method: 'PATCH',
        );

        // Assert
        verify(
          () => mockDataSource.updateDelivery(
            tDeliveryId,
            tDelivery,
            method: 'PATCH',
          ),
        ).called(1);
      });

      test('should handle update without method parameter', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        final tResponse = MockData.createApiResponse(tDelivery);

        when(
          () => mockDataSource.updateDelivery(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.updateDelivery(
          deliveryId: tDeliveryId,
          req: tDelivery,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockDataSource.updateDelivery(
            tDeliveryId,
            tDelivery,
            method: null,
          ),
        ).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        when(
          () => mockDataSource.updateDelivery(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenThrow(Exception('Update failed'));

        // Act
        final result = await repository.updateDelivery(
          deliveryId: tDeliveryId,
          req: tDelivery,
        );

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Update failed'));
          },
        );
      });
    });

    group('uploadDeliveryDocuments', () {
      const tDeliveryId = 1;

      test(
        'should return ApiResponse<Delivery?> when document upload succeeds',
        () async {
          // Arrange
          final tDelivery = Delivery(id: tDeliveryId);
          final tResponse = MockData.createApiResponse(tDelivery);

          when(
            () => mockDataSource.uploadDeliveryDocuments(
              any(),
              any(),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.uploadDeliveryDocuments(
            deliveryId: tDeliveryId,
            req: tDelivery,
            method: 'POST',
          );

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data?.id, tDeliveryId);
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(
            () => mockDataSource.uploadDeliveryDocuments(
              tDeliveryId,
              tDelivery,
              method: 'POST',
            ),
          ).called(1);
        },
      );

      test('should pass correct parameters to data source', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        final tResponse = MockData.createApiResponse(tDelivery);

        when(
          () => mockDataSource.uploadDeliveryDocuments(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.uploadDeliveryDocuments(
          deliveryId: tDeliveryId,
          req: tDelivery,
          method: 'PUT',
        );

        // Assert
        verify(
          () => mockDataSource.uploadDeliveryDocuments(
            tDeliveryId,
            tDelivery,
            method: 'PUT',
          ),
        ).called(1);
      });

      test('should handle null delivery ID', () async {
        // Arrange
        final tDelivery = Delivery();
        final tResponse = MockData.createApiResponse(tDelivery);

        when(
          () => mockDataSource.uploadDeliveryDocuments(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.uploadDeliveryDocuments(
          deliveryId: null,
          req: tDelivery,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockDataSource.uploadDeliveryDocuments(
            null,
            tDelivery,
            method: null,
          ),
        ).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tDelivery = Delivery(id: tDeliveryId);
        when(
          () => mockDataSource.uploadDeliveryDocuments(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenThrow(Exception('Upload failed'));

        // Act
        final result = await repository.uploadDeliveryDocuments(
          deliveryId: tDeliveryId,
          req: tDelivery,
        );

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Upload failed'));
          },
        );
      });
    });
  });
}
