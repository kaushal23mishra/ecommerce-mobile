import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/data_source/lead/remote/lead_data_source.dart';
import 'package:salesdocket_core/src/repository/lead/lead_repository_impl.dart';

import '../../../helpers/mock_data.dart';

class MockLeadDataSource extends Mock implements LeadDataSource {}

void main() {
  late MockLeadDataSource mockDataSource;
  late LeadRepositoryImpl repository;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(CreateLeadRequest());
    registerFallbackValue(GetLeadRequest());
    registerFallbackValue(Lead());
    registerFallbackValue(CreateLeadHistoryRequest());
    registerFallbackValue(CloseFollowupRequest());
    registerFallbackValue(ChangeLeadStatusRequest());
    registerFallbackValue(LeadFollowupRequest());
    registerFallbackValue(LeadSearchRequest());
  });

  setUp(() {
    mockDataSource = MockLeadDataSource();
    repository = LeadRepositoryImpl(dataSource: mockDataSource);
  });

  group('LeadRepositoryImpl', () {
    group('createLead', () {
      test('should return Lead when lead creation succeeds', () async {
        // Arrange
        final tRequest = CreateLeadRequest(firstName: 'John', lastName: 'Doe');
        final tLead = MockData.createLead(
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
        );

        when(
          () => mockDataSource.createLead(any()),
        ).thenAnswer((_) async => tLead);

        // Act
        final result = await repository.createLead(req: tRequest);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (lead) {
            expect(lead?.id, tLead.id);
            expect(lead?.firstName, tLead.firstName);
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(() => mockDataSource.createLead(tRequest)).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        final tRequest = CreateLeadRequest(firstName: 'John');
        when(
          () => mockDataSource.createLead(any()),
        ).thenThrow(Exception('Creation failed'));

        // Act
        final result = await repository.createLead(req: tRequest);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not succeed'),
          failure: (error) {
            expect(error.message, contains('Creation failed'));
          },
        );
      });
    });

    group('getLead', () {
      const tLeadId = 1;

      test('should return ApiResponse<Lead?> when get lead succeeds', () async {
        // Arrange
        final tLead = MockData.createLead(id: tLeadId, firstName: 'Test');
        final tResponse = MockData.createApiResponse(tLead);

        when(
          () => mockDataSource.getLead(any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getLead(leadId: tLeadId);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (response) {
            expect(response?.data?.id, tLeadId);
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(() => mockDataSource.getLead(tLeadId)).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        when(
          () => mockDataSource.getLead(any()),
        ).thenThrow(Exception('Get failed'));

        // Act
        final result = await repository.getLead(leadId: tLeadId);

        // Assert
        expect(result.isFailure, true);
      });
    });

    group('getLeads', () {
      test('should return paginated leads when request succeeds', () async {
        // Arrange
        final tLeads = [MockData.createLead(id: 1), MockData.createLead(id: 2)];
        final tInnerResponse = MockData.createApiResponse(tLeads);
        final tResponse = MockData.createApiResponse(tInnerResponse);

        when(
          () => mockDataSource.getLeads(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getLeads(page: 1);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (response) {
            expect(response?.data?.data?.length, 2);
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(() => mockDataSource.getLeads(1, null)).called(1);
      });

      test('should pass request parameters to data source', () async {
        // Arrange
        final tRequest = GetLeadRequest();
        final tResponse = MockData.createApiResponse(
          MockData.createApiResponse<List<Lead>?>([]),
        );

        when(
          () => mockDataSource.getLeads(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.getLeads(page: 2, req: tRequest);

        // Assert
        verify(() => mockDataSource.getLeads(2, tRequest)).called(1);
      });
    });

    group('updateLead', () {
      const tLeadId = 1;

      test('should return updated leads when update succeeds', () async {
        // Arrange
        final tLead = Lead(id: tLeadId, firstName: 'Updated');
        final tUpdatedLeads = [tLead];
        final tResponse = MockData.createApiResponse(tUpdatedLeads);

        when(
          () => mockDataSource.updateLead(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.updateLead(
          leadId: tLeadId,
          req: tLead,
          method: 'PUT',
        );

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (response) {
            expect(response?.data?.first.id, tLeadId);
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(
          () => mockDataSource.updateLead(tLeadId, tLead, method: 'PUT'),
        ).called(1);
      });

      test('should use default method when not provided', () async {
        // Arrange
        final tLead = Lead(id: tLeadId);
        final tResponse = MockData.createApiResponse<List<Lead>?>([]);

        when(
          () => mockDataSource.updateLead(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        await repository.updateLead(leadId: tLeadId, req: tLead);

        // Assert
        verify(
          () => mockDataSource.updateLead(tLeadId, tLead, method: ''),
        ).called(1);
      });
    });

    group('createLeadHistory', () {
      const tLeadId = 1;

      test('should return ApiResponse when create history succeeds', () async {
        // Arrange
        final tRequest = CreateLeadHistoryRequest();
        final tResponse = ApiResponse(
          data: {'message': 'Success'},
          status: 'success',
        );

        when(
          () => mockDataSource.createLeadHistory(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.createLeadHistory(
          leadId: tLeadId,
          req: tRequest,
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockDataSource.createLeadHistory(tLeadId, tRequest),
        ).called(1);
      });

      test('should return failure when data source throws exception', () async {
        // Arrange
        when(
          () => mockDataSource.createLeadHistory(any(), any()),
        ).thenThrow(Exception('History creation failed'));

        // Act
        final result = await repository.createLeadHistory(
          leadId: tLeadId,
          req: CreateLeadHistoryRequest(),
        );

        // Assert
        expect(result.isFailure, true);
      });
    });

    group('changeLeadStatus', () {
      const tLeadId = 1;

      test('should return status messages when change succeeds', () async {
        // Arrange
        final tRequest = ChangeLeadStatusRequest(approvalStatus: 'approved');
        final tMessages = ['Status changed successfully'];
        final tResponse = MockData.createApiResponse(tMessages);

        when(
          () => mockDataSource.changeLeadStatus(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.changeLeadStatus(
          leadId: tLeadId,
          req: tRequest,
        );

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (response) {
            expect(response?.data?.first, 'Status changed successfully');
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(
          () => mockDataSource.changeLeadStatus(tLeadId, tRequest),
        ).called(1);
      });
    });

    group('createLeadFollowUp', () {
      const tLeadId = 1;

      test(
        'should return ApiResponse when followup creation succeeds',
        () async {
          // Arrange
          final tRequest = LeadFollowupRequest();
          final tResponse = ApiResponse(data: {}, status: 'success');

          when(
            () => mockDataSource.createLeadFollowup(any(), any()),
          ).thenAnswer((_) async => tResponse);

          // Act
          final result = await repository.createLeadFollowUp(
            leadId: tLeadId,
            req: tRequest,
          );

          // Assert
          expect(result.isSuccess, true);
          verify(
            () => mockDataSource.createLeadFollowup(tLeadId, tRequest),
          ).called(1);
        },
      );
    });

    group('updateLeadFollowUp', () {
      const tWorkflowId = 1;

      test('should return ApiResponse when followup update succeeds', () async {
        // Arrange
        final tRequest = LeadFollowupRequest();
        final tResponse = ApiResponse(data: {}, status: 'success');

        when(
          () => mockDataSource.updateLeadFollowup(
            any(),
            any(),
            method: any(named: 'method'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.updateLeadFollowUp(
          workflowId: tWorkflowId,
          req: tRequest,
          method: 'PUT',
        );

        // Assert
        expect(result.isSuccess, true);
        verify(
          () => mockDataSource.updateLeadFollowup(
            tWorkflowId,
            tRequest,
            method: 'PUT',
          ),
        ).called(1);
      });
    });

    group('searchLeads', () {
      test('should return search results when search succeeds', () async {
        // Arrange
        final tRequest = LeadSearchRequest();
        final tResponse = LeadSearchResponse();

        when(
          () => mockDataSource.searchLeads(any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.searchLeads(req: tRequest);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.searchLeads(tRequest)).called(1);
      });
    });

    group('getBanks', () {
      test('should return list of banks when request succeeds', () async {
        // Arrange
        final tBanks = [
          Bank(id: 1, name: 'Bank 1'),
          Bank(id: 2, name: 'Bank 2'),
        ];

        when(() => mockDataSource.getBanks()).thenAnswer((_) async => tBanks);

        // Act
        final result = await repository.getBanks();

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (banks) {
            expect(banks?.length, 2);
          },
          failure: (_) => fail('Should not fail'),
        );

        verify(() => mockDataSource.getBanks()).called(1);
      });
    });

    group('getInsuranceCompanies', () {
      test('should return insurance companies when request succeeds', () async {
        // Arrange
        final tInsurance = [Insurance(id: 1, companyName: 'Insurance 1')];
        final tResponse = MockData.createApiResponse(tInsurance);

        when(
          () => mockDataSource.getInsuranceCompanies(),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getInsuranceCompanies();

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.getInsuranceCompanies()).called(1);
      });
    });

    group('getDiscountApprovals', () {
      const tLeadId = 1;

      test('should return discount approvals when request succeeds', () async {
        // Arrange
        final tApproval = DiscountApproval(id: 1);
        final tResponse = MockData.createApiResponse(tApproval);

        when(
          () => mockDataSource.getDiscountApprovals(any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getDiscountApprovals(tLeadId);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.getDiscountApprovals(tLeadId)).called(1);
      });
    });

    group('getLeadsCounts', () {
      test('should return lead counts when request succeeds', () async {
        // Arrange
        final tCounts = LeadCounts(active: 100);
        final tResponse = MockData.createApiResponse(tCounts);

        when(
          () => mockDataSource.getLeadsCounts(),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getLeadsCounts();

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.getLeadsCounts()).called(1);
      });
    });
  });
}
