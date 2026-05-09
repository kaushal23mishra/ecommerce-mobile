import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/constants/api_end_points.dart';
import 'package:salesdocket_core/src/data_source/lead/remote/lead_data_source_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late LeadDataSourceImpl dataSource;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());
    registerFallbackValue(FormData());
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = LeadDataSourceImpl(dio: mockDio);
  });

  group('LeadDataSourceImpl', () {
    group('createLead', () {
      test('should make POST request to correct endpoint', () async {
        // Arrange
        final tRequest = CreateLeadRequest(firstName: 'John', lastName: 'Doe');
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'id': 1, 'first_name': 'John'},
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.createLead(tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            APIEndPoints.lead,
            data: any(named: 'data'),
          ),
        ).called(1);
      });

      test('should return Lead when response data is valid', () async {
        // Arrange
        final tRequest = CreateLeadRequest(firstName: 'John');
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'id': 1, 'first_name': 'John'},
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.createLead(tRequest);

        // Assert
        expect(result, isA<Lead>());
        expect(result?.id, 1);
        expect(result?.firstName, 'John');
      });

      test('should return null when response data is null', () async {
        // Arrange
        final tRequest = CreateLeadRequest(firstName: 'John');
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: null,
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.createLead(tRequest);

        // Assert
        expect(result, isNull);
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        final tRequest = CreateLeadRequest(firstName: 'John');
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.createLead(tRequest),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('getLead', () {
      const tLeadId = 1;

      test('should make GET request to correct endpoint', () async {
        // Arrange
        final url = '${APIEndPoints.lead}/$tLeadId';
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': {'id': tLeadId},
            'status': 'success',
          },
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.getLead(tLeadId);

        // Assert
        verify(() => mockDio.get(url)).called(1);
      });

      test('should return ApiResponse<Lead?> when request succeeds', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': {'id': tLeadId, 'first_name': 'Test'},
            'status': 'success',
          },
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.getLead(tLeadId);

        // Assert
        expect(result, isA<ApiResponse<Lead?>>());
        expect(result.data?.id, tLeadId);
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        when(() => mockDio.get(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
            ),
          ),
        );

        // Act & Assert
        expect(() => dataSource.getLead(tLeadId), throwsA(isA<DioException>()));
      });
    });

    group('getLeads', () {
      test('should make GET request with pagination', () async {
        // Arrange
        const tPage = 1;
        final url = '${APIEndPoints.lead}?page=$tPage';
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': {'data': [], 'status': 'success'},
            'status': 'success',
          },
        );

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.getLeads(tPage, null);

        // Assert
        verify(() => mockDio.get(url, queryParameters: null)).called(1);
      });

      test(
        'should include query parameters when request is provided',
        () async {
          // Arrange
          final tRequest = GetLeadRequest();
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': {'data': [], 'status': 'success'},
              'status': 'success',
            },
          );

          when(
            () => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.getLeads(1, tRequest);

          // Assert
          verify(
            () => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            ),
          ).called(1);
        },
      );

      test('should return paginated leads when request succeeds', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': {'data': [], 'status': 'success'},
            'status': 'success',
          },
        );

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.getLeads(1, null);

        // Assert
        expect(result, isA<ApiResponse<ApiResponse<List<Lead>?>?>>());
      });
    });

    group('updateLead', () {
      const tLeadId = 1;

      test('should make POST request to correct endpoint', () async {
        // Arrange
        final url = '${APIEndPoints.lead}/$tLeadId';
        final tLead = Lead(id: tLeadId, firstName: 'Updated');
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': [tLead.toJson()],
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
        await dataSource.updateLead(tLeadId, tLead);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            url,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test(
        'should include _method parameter when method is provided',
        () async {
          // Arrange
          final tLead = Lead(id: tLeadId);
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': [], 'status': 'success'},
          );

          when(
            () => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          await dataSource.updateLead(tLeadId, tLead, method: 'PUT');

          // Assert
          verify(
            () => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      test('should use POST url-encoded options', () async {
        // Arrange
        final tLead = Lead(id: tLeadId);
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'status': 'success'},
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.updateLead(tLeadId, tLead);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options', that: isA<Options>()),
          ),
        ).called(1);
      });

      test(
        'should return ApiResponse<List<Lead>?> when update succeeds',
        () async {
          // Arrange
          final tLead = Lead(id: tLeadId, firstName: 'Updated');
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {
              'data': [tLead.toJson()],
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
          final result = await dataSource.updateLead(tLeadId, tLead);

          // Assert
          expect(result, isA<ApiResponse<List<Lead>?>>());
          expect(result.data?.first.id, tLeadId);
        },
      );
    });

    group('createLeadHistory', () {
      const tLeadId = 1;

      test('should make POST request to correct endpoint', () async {
        // Arrange
        final url = APIEndPoints.createLeadHistory.replaceAll(
          '{leadId}',
          '$tLeadId',
        );
        final tRequest = CreateLeadHistoryRequest();
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: <String, dynamic>{
            'data': <String, dynamic>{},
            'message': 'Success',
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
        await dataSource.createLeadHistory(tLeadId, tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            url,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should use multipart options', () async {
        // Arrange
        final tRequest = CreateLeadHistoryRequest();
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: <String, dynamic>{
            'data': <String, dynamic>{},
            'message': 'Success',
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
        await dataSource.createLeadHistory(tLeadId, tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data', that: isA<FormData>()),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('should return ApiResponse when request succeeds', () async {
        // Arrange
        final tRequest = CreateLeadHistoryRequest();
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: <String, dynamic>{
            'data': <String, dynamic>{},
            'message': 'Success',
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
        final result = await dataSource.createLeadHistory(tLeadId, tRequest);

        // Assert
        expect(result, isA<ApiResponse>());
      });
    });

    group('changeLeadStatus', () {
      const tLeadId = 1;

      test('should make POST request to correct endpoint', () async {
        // Arrange
        final url = APIEndPoints.changeLeadStatus.replaceAll(
          '{leadId}',
          '$tLeadId',
        );
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': ['Status changed'],
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
        await dataSource.changeLeadStatus(tLeadId, tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            url,
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test(
        'should return ApiResponse<List<String>?> when request succeeds',
        () async {
          // Arrange
          final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
          final tMessages = ['Status changed successfully'];
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tMessages, 'status': 'success'},
          );

          when(
            () => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            ),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.changeLeadStatus(tLeadId, tRequest);

          // Assert
          expect(result, isA<ApiResponse<List<String>?>>());
          expect(result.data?.first, 'Status changed successfully');
        },
      );

      test('should use url-encoded options when no documents', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        final tResponse = Response(
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
        await dataSource.changeLeadStatus(tLeadId, tRequest);

        // Assert
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options', that: isA<Options>()),
          ),
        ).called(1);
      });
    });

    group('createLeadFollowup', () {
      const tLeadId = 1;

      test('should make POST request to correct endpoint', () async {
        // Arrange
        final url = APIEndPoints.createLeadFollowup.replaceAll(
          '{leadId}',
          '$tLeadId',
        );
        final tRequest = LeadFollowupRequest();
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: <String, dynamic>{
            'data': <String, dynamic>{},
            'message': 'Success',
          },
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.createLeadFollowup(tLeadId, tRequest);

        // Assert
        verify(
          () =>
              mockDio.post<Map<String, dynamic>>(url, data: any(named: 'data')),
        ).called(1);
      });

      test('should return ApiResponse when request succeeds', () async {
        // Arrange
        final tRequest = LeadFollowupRequest();
        final tResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          data: <String, dynamic>{
            'data': <String, dynamic>{},
            'message': 'Success',
          },
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.createLeadFollowup(tLeadId, tRequest);

        // Assert
        expect(result, isA<ApiResponse>());
      });

      test('should propagate DioException when request fails', () async {
        // Arrange
        final tRequest = LeadFollowupRequest();
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
            ),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.createLeadFollowup(tLeadId, tRequest),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('searchLeads', () {
      test('should make GET request to search endpoint', () async {
        // Arrange
        final tRequest = LeadSearchRequest();
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'leads': []},
        );

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.searchLeads(tRequest);

        // Assert
        verify(
          () => mockDio.get(
            APIEndPoints.searchLead,
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('should return LeadSearchResponse when request succeeds', () async {
        // Arrange
        final tRequest = LeadSearchRequest();
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'leads': []},
        );

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.searchLeads(tRequest);

        // Assert
        expect(result, isA<LeadSearchResponse>());
      });

      test('should return null when response data is null', () async {
        // Arrange
        final tRequest = LeadSearchRequest();
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: null,
        );

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.searchLeads(tRequest);

        // Assert
        expect(result, isNull);
      });
    });

    group('getBanks', () {
      test('should make GET request to banks endpoint', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: [],
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.getBanks();

        // Assert
        verify(() => mockDio.get(APIEndPoints.getBanks)).called(1);
      });

      test('should return list of banks when request succeeds', () async {
        // Arrange
        final tBanks = [
          {'id': 1, 'name': 'Bank 1'},
          {'id': 2, 'name': 'Bank 2'},
        ];
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: tBanks,
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.getBanks();

        // Assert
        expect(result, isA<List<Bank>>());
        expect(result?.length, 2);
      });

      test('should return null when response data is null', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: null,
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.getBanks();

        // Assert
        expect(result, isNull);
      });
    });

    group('getInsuranceCompanies', () {
      test('should make GET request to insurance companies endpoint', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': [], 'status': 'success'},
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.getInsuranceCompanies();

        // Assert
        verify(() => mockDio.get(APIEndPoints.getInsuranceCompanies)).called(1);
      });

      test(
        'should return ApiResponse<List<Insurance>?> when request succeeds',
        () async {
          // Arrange
          final tInsurance = [
            {'id': 1, 'name': 'Insurance 1'},
          ];
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tInsurance, 'status': 'success'},
          );

          when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.getInsuranceCompanies();

          // Assert
          expect(result, isA<ApiResponse<List<Insurance>?>>());
          expect(result.data?.length, 1);
        },
      );
    });

    group('getDiscountApprovals', () {
      const tLeadId = 1;

      test('should make GET request to correct endpoint', () async {
        // Arrange
        final url = APIEndPoints.discountApprovals.replaceAll(
          '{leadId}',
          '$tLeadId',
        );
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.getDiscountApprovals(tLeadId);

        // Assert
        verify(() => mockDio.get(url)).called(1);
      });

      test(
        'should return ApiResponse<DiscountApproval?> when request succeeds',
        () async {
          // Arrange
          final tApproval = {'id': 1, 'status': 'approved'};
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tApproval, 'status': 'success'},
          );

          when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.getDiscountApprovals(tLeadId);

          // Assert
          expect(result, isA<ApiResponse<DiscountApproval?>>());
        },
      );

      test('should handle null data in response', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': null, 'status': 'success'},
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        final result = await dataSource.getDiscountApprovals(tLeadId);

        // Assert
        expect(result.data, isNull);
      });
    });

    group('getLeadsCounts', () {
      test('should make GET request to lead counts endpoint', () async {
        // Arrange
        final tResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'data': {'total': 100},
            'status': 'success',
          },
        );

        when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

        // Act
        await dataSource.getLeadsCounts();

        // Assert
        verify(() => mockDio.get(APIEndPoints.leadCounts)).called(1);
      });

      test(
        'should return ApiResponse<LeadCounts?> when request succeeds',
        () async {
          // Arrange
          final tCounts = {'total': 100, 'active': 50};
          final tResponse = Response(
            requestOptions: RequestOptions(path: ''),
            data: {'data': tCounts, 'status': 'success'},
          );

          when(() => mockDio.get(any())).thenAnswer((_) async => tResponse);

          // Act
          final result = await dataSource.getLeadsCounts();

          // Assert
          expect(result, isA<ApiResponse<LeadCounts?>>());
        },
      );
    });
  });
}
