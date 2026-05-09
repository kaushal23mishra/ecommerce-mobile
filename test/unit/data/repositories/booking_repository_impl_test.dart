import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/data_source/booking/remote/booking_data_source.dart';
import 'package:salesdocket_core/src/repository/booking/booking_repository_impl.dart';

import '../../../helpers/mock_data.dart';

class MockBookingDataSource extends Mock implements BookingDataSource {}

void main() {
  late MockBookingDataSource mockDataSource;
  late BookingRepositoryImpl repository;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(Booking());
    registerFallbackValue(ChangeLeadStatusRequest());
  });

  setUp(() {
    mockDataSource = MockBookingDataSource();
    repository = BookingRepositoryImpl(dataSource: mockDataSource);
  });

  group('BookingRepositoryImpl', () {
    group('createBooking', () {
      test(
        'should return ApiResponse<Booking?> when booking creation succeeds',
        () async {
          // Arrange
          final tBooking = Booking(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            leadId: 100,
          );
          final tResponse = MockData.createApiResponse(tBooking);

          when(
            () => mockDataSource.createBooking(any()),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.createBooking(req: tBooking);

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data?.id, tBooking.id);
              expect(response?.data?.firstName, tBooking.firstName);
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(() => mockDataSource.createBooking(tBooking)).called(1);
        },
      );

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tBooking = Booking(firstName: 'John', lastName: 'Doe');
        when(
          () => mockDataSource.createBooking(any()),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.createBooking(req: tBooking);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Network error'));
          },
        );
      });

      test('should handle null booking request', () async {
        // Arrange
        final tResponse = MockData.createApiResponse<Booking?>(null);
        when(
          () => mockDataSource.createBooking(any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.createBooking(req: null);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.createBooking(null)).called(1);
      });
    });

    group('updateBooking', () {
      const tBookingId = 1;

      test(
        'should return ApiResponse<Booking?> when booking update succeeds',
        () async {
          // Arrange
          final tBooking = Booking(
            id: tBookingId,
            firstName: 'John',
            lastName: 'Updated',
          );
          final tResponse = MockData.createApiResponse(tBooking);

          when(
            () => mockDataSource.updateBooking(
              any(),
              any(),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.updateBooking(
            bookingId: tBookingId,
            req: tBooking,
            method: 'PUT',
          );

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data?.id, tBookingId);
              expect(response?.data?.lastName, 'Updated');
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(
            () => mockDataSource.updateBooking(
              tBookingId,
              tBooking,
              method: 'PUT',
            ),
          ).called(1);
        },
      );

      test('should pass correct parameters to data source', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId, firstName: 'Test');
        final tResponse = MockData.createApiResponse(tBooking);

        when(
          () => mockDataSource.updateBooking(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.updateBooking(
          bookingId: tBookingId,
          req: tBooking,
          method: 'PATCH',
        );

        // Assert
        verify(
          () => mockDataSource.updateBooking(
            tBookingId,
            tBooking,
            method: 'PATCH',
          ),
        ).called(1);
      });

      test('should handle update without method parameter', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
        final tResponse = MockData.createApiResponse(tBooking);

        when(
          () => mockDataSource.updateBooking(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.updateBooking(
          bookingId: tBookingId,
          req: tBooking,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () =>
              mockDataSource.updateBooking(tBookingId, tBooking, method: null),
        ).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
        when(
          () => mockDataSource.updateBooking(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenThrow(Exception('Update failed'));

        // Act
        final result = await repository.updateBooking(
          bookingId: tBookingId,
          req: tBooking,
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

    group('uploadBookingDocuments', () {
      const tBookingId = 1;

      test(
        'should return ApiResponse<Booking?> when document upload succeeds',
        () async {
          // Arrange
          final tBooking = Booking(
            id: tBookingId,
            documents: [
              Document(id: 1, fileName: 'doc.pdf', fileUrl: '/path/to/doc.pdf'),
            ],
          );
          final tResponse = MockData.createApiResponse(tBooking);

          when(
            () => mockDataSource.uploadBookingDocuments(
              any(),
              any(),
              method: any(named: 'method'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.uploadBookingDocuments(
            bookingId: tBookingId,
            req: tBooking,
            method: 'POST',
          );

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data?.id, tBookingId);
              expect(response?.data?.documents?.length, 1);
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(
            () => mockDataSource.uploadBookingDocuments(
              tBookingId,
              tBooking,
              method: 'POST',
            ),
          ).called(1);
        },
      );

      test('should pass correct parameters to data source', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
        final tResponse = MockData.createApiResponse(tBooking);

        when(
          () => mockDataSource.uploadBookingDocuments(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.uploadBookingDocuments(
          bookingId: tBookingId,
          req: tBooking,
          method: 'PUT',
        );

        // Assert
        verify(
          () => mockDataSource.uploadBookingDocuments(
            tBookingId,
            tBooking,
            method: 'PUT',
          ),
        ).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
        when(
          () => mockDataSource.uploadBookingDocuments(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenThrow(Exception('Upload failed'));

        // Act
        final result = await repository.uploadBookingDocuments(
          bookingId: tBookingId,
          req: tBooking,
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

    group('sendCPAApproval', () {
      const tLeadId = 100;

      test(
        'should return ApiResponse<List<String>?> when approval succeeds',
        () async {
          // Arrange
          final tRequest = ChangeLeadStatusRequest(
            approvalStatus: 'approved',
            lostRemarks: 'Test remarks',
          );
          final tResponse = MockData.createApiResponse<List<String>?>([
            'Approval sent successfully',
          ]);

          when(
            () => mockDataSource.sendCPAApproval(any(), any()),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.sendCPAApproval(tLeadId, tRequest);

          // Assert
          expect(result.isSuccess, true);
          result.when(
            success: (response) {
              expect(response?.data, isA<List<String>>());
              expect(response?.data?.first, 'Approval sent successfully');
            },
            failure: (_) => fail('Should not fail'),
          );

          verify(
            () => mockDataSource.sendCPAApproval(tLeadId, tRequest),
          ).called(1);
        },
      );

      test('should pass correct parameters to data source', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        final tResponse = MockData.createApiResponse<List<String>?>([
          'Success',
        ]);

        when(
          () => mockDataSource.sendCPAApproval(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.sendCPAApproval(tLeadId, tRequest);

        // Assert
        verify(
          () => mockDataSource.sendCPAApproval(tLeadId, tRequest),
        ).called(1);
      });

      test('should handle null request', () async {
        // Arrange
        final tResponse = MockData.createApiResponse<List<String>?>([
          'Success',
        ]);

        when(
          () => mockDataSource.sendCPAApproval(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.sendCPAApproval(tLeadId, null);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.sendCPAApproval(tLeadId, null)).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        when(
          () => mockDataSource.sendCPAApproval(any(), any()),
        ).thenThrow(Exception('Approval failed'));

        // Act
        final result = await repository.sendCPAApproval(tLeadId, tRequest);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Approval failed'));
          },
        );
      });
    });
  });
}
