import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/constants/api_end_points.dart';
import 'package:salesdocket_core/src/data_source/booking/remote/booking_data_source_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late BookingDataSourceImpl dataSource;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());
    registerFallbackValue(FormData());
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = BookingDataSourceImpl(dio: mockDio);
  });

  group('BookingDataSourceImpl', () {
    group('createBooking', () {
      test('should make POST request to correct endpoint', () async {
        // Arrange
        const url = '${APIEndPoints.booking}/store';
        final tBooking = Booking(firstName: 'John', lastName: 'Doe');
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': tBooking.toJson(), 'status': 'success'},
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.createBooking(tBooking);

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
        'should return ApiResponse<Booking?> when request succeeds',
        () async {
          // Arrange
          final tBooking = Booking(id: 1, firstName: 'John', lastName: 'Doe');
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tBooking.toJson(), 'status': 'success'},
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.createBooking(tBooking);

          // Assert
          expect(result, isA<ApiResponse<Booking?>>());
          expect(result.data?.id, tBooking.id);
          expect(result.data?.firstName, tBooking.firstName);
        },
      );

      test('should use POST url-encoded options', () async {
        // Arrange
        final tBooking = Booking(firstName: 'Test');
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
        await dataSource.createBooking(tBooking);

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
        final tBooking = Booking(firstName: 'Test');
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
          () => dataSource.createBooking(tBooking),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('updateBooking', () {
      const tBookingId = 1;

      test(
        'should make POST request to correct endpoint with booking ID',
        () async {
          // Arrange
          final url = '${APIEndPoints.booking}/$tBookingId/update';
          final tBooking = Booking(id: tBookingId, firstName: 'Updated');
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tBooking.toJson(), 'status': 'success'},
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.updateBooking(tBookingId, tBooking);

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
          final tBooking = Booking(id: tBookingId);
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
          await dataSource.updateBooking(tBookingId, tBooking, method: 'PUT');

          // Assert
          verify(
            () => mockDio.post(
              any(),
              data: any(named: 'data', that: contains('_method')),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test('should call post method when method is null', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
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
        await dataSource.updateBooking(tBookingId, tBooking);

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
        'should return ApiResponse<Booking?> when update succeeds',
        () async {
          // Arrange
          final tBooking = Booking(
            id: tBookingId,
            firstName: 'Updated',
            lastName: 'Name',
          );
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tBooking.toJson(), 'status': 'success'},
          );

          when(
            () => mockDio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.updateBooking(tBookingId, tBooking);

          // Assert
          expect(result, isA<ApiResponse<Booking?>>());
          expect(result.data?.id, tBookingId);
          expect(result.data?.firstName, 'Updated');
        },
      );

      test('should handle timeout error', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
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
          () => dataSource.updateBooking(tBookingId, tBooking),
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

    group('uploadBookingDocuments', () {
      const tBookingId = 1;

      test('should make POST request to correct endpoint', () async {
        // Arrange
        final url = '${APIEndPoints.booking}/$tBookingId/update';
        final tBooking = Booking(id: tBookingId);
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': tBooking.toJson(), 'status': 'success'},
        );

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.uploadBookingDocuments(tBookingId, tBooking);

        // Assert
        verify(
          () => mockDio.post(
            url,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should use multipart options for file upload', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
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
        await dataSource.uploadBookingDocuments(tBookingId, tBooking);

        // Assert
        verify(
          () => mockDio.post(
            any(),
            data: any(named: 'data', that: isA<FormData>()),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should include _method parameter when method is provided', () async {
        // Arrange
        final tBooking = Booking(id: tBookingId);
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
        await dataSource.uploadBookingDocuments(
          tBookingId,
          tBooking,
          method: 'PUT',
        );

        // Assert - method is added to FormData, so we verify the call was made
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
        final tBooking = Booking(id: tBookingId);
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
          () => dataSource.uploadBookingDocuments(tBookingId, tBooking),
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

    group('sendCPAApproval', () {
      const tLeadId = 100;

      test(
        'should make POST request to correct endpoint with leadId',
        () async {
          // Arrange
          final url = APIEndPoints.bookingCpaApproval.replaceAll(
            '{leadId}',
            '$tLeadId',
          );
          final tRequest = ChangeLeadStatusRequest(
            approvalStatus: 'approved',
            lostRemarks: 'Test remarks',
          );
          final tResponse = Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': ['Success'],
              'status': 'success',
            },
          );

          when(
            () => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.sendCPAApproval(tLeadId, tRequest);

          // Assert
          verify(
            () => mockDio.post<Map<String, dynamic>>(
              url,
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test(
        'should return ApiResponse<List<String>?> when approval succeeds',
        () async {
          // Arrange
          final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
          final tResponse = Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': ['Approval sent successfully', 'Email notification sent'],
              'status': 'success',
            },
          );

          when(
            () => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.sendCPAApproval(tLeadId, tRequest);

          // Assert
          expect(result, isA<ApiResponse<List<String>?>>());
          expect(result?.data, isA<List<String>>());
          expect(result?.data?.length, 2);
          expect(result?.data?.first, 'Approval sent successfully');
        },
      );

      test('should use POST url-encoded options', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': ['Success'],
            'status': 'success',
          },
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.sendCPAApproval(tLeadId, tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options', that: isA<Options>()),
          ),
        ).called(1);
      });

      test('should handle null data in response', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.sendCPAApproval(tLeadId, tRequest);

        // Assert
        expect(result?.data, isNull);
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        when(
          () => mockDio.post<Map<String, dynamic>>(
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
              statusCode: 403,
              data: {'message': 'Forbidden'},
            ),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.sendCPAApproval(tLeadId, tRequest),
          throwsA(
            isA<DioException>().having(
              (e) => e.response?.statusCode,
              'statusCode',
              403,
            ),
          ),
        );
      });
    });
  });
}
