import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/form_field_focus_node.dart';
import 'package:salesdocket_mobile/common/providers/focus_node_notifier.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';
import 'package:salesdocket_mobile/common/providers/text_editing_controller_notifier.dart';

part 'lead_view_model.g.dart';

@riverpod
class LeadViewModel extends _$LeadViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<LeadSearchResponse?>> searchLeads({
    LeadSearchRequest? request,
  }) {
    return ref.read(leadRepositoryProvider).searchLeads(req: request);
  }

  Lead? filterExistingSameOutletLead(List<Lead> leads, String contactToCheck) {
    for (var lead in leads) {
      final phoneNumbers = lead.phoneNumbers ?? [];
      final workflowState = lead.workflow?.state;
      if (phoneNumbers.any((phone) => phone.phoneNumber == contactToCheck) &&
          workflowState != WorkflowState.delivered.value) {
        return lead;
      }
    }

    return null;
  }

  Lead? filterExistingLinkedOutletLead(
    List<Lead> leads,
    String contactToCheck,
  ) {
    for (var lead in leads) {
      final phoneNumbers = lead.phoneNumbers ?? [];
      if (phoneNumbers.any((phone) => phone.phoneNumber == contactToCheck)) {
        return lead;
      }
    }

    return null;
  }

  Lead? filterExistingOtherOutletLead(List<Lead> leads, String contactToCheck) {
    for (var lead in leads) {
      final phoneNumbers = lead.phoneNumbers ?? [];
      if (phoneNumbers.any((phone) => phone.phoneNumber == contactToCheck)) {
        return lead;
      }
    }

    return null;
  }

  Future<Result<Lead?>> createLead(CreateLeadRequest request) {
    return ref.read(leadRepositoryProvider).createLead(req: request);
  }

  Future<Result<ApiResponse<List<Lead>?>?>> createGroupedLead(
    CreateLeadRequest request,
  ) {
    return ref.read(leadRepositoryProvider).createGroupedLead(req: request);
  }

  Future<Result<ApiResponse<List<Lead>?>>> updateLead(
    int leadId, {
    Lead? request,
    String method = "",
  }) {
    return ref
        .read(leadRepositoryProvider)
        .updateLead(leadId: leadId, req: request, method: method);
  }

  Future<Result<ApiResponse>> createLeadFollowup(
    int leadId, {
    LeadFollowupRequest? request,
  }) {
    return ref
        .read(leadRepositoryProvider)
        .createLeadFollowUp(leadId: leadId, req: request);
  }

  Future<Result<ApiResponse>> updateLeadFollowup(
    int leadId, {
    LeadFollowupRequest? request,
    String method = "",
  }) {
    return ref
        .read(leadRepositoryProvider)
        .updateLeadFollowUp(workflowId: leadId, req: request, method: method);
  }

  Future<Result<ApiResponse>> createLeadHistory(
    int leadId, {
    CreateLeadHistoryRequest? request,
  }) {
    return ref
        .read(leadRepositoryProvider)
        .createLeadHistory(leadId: leadId, req: request);
  }

  Future<Result<ApiResponse>> closeLeadHistory(
    int followupId, {
    CloseFollowupRequest? request,
  }) {
    return ref
        .read(leadRepositoryProvider)
        .closeLeadHistory(followupId: followupId, req: request);
  }

  Future<Result<ApiResponse>> changeLeadStatus(
    int leadId, {
    ChangeLeadStatusRequest? request,
  }) {
    return ref
        .read(leadRepositoryProvider)
        .changeLeadStatus(leadId: leadId, req: request);
  }

  Future<Result<ApiResponse<Lead?>>> getLead(int leadId) {
    return ref.read(leadRepositoryProvider).getLead(leadId: leadId);
  }

  Future<Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>> getLeadHistory(
    int leadId,
  ) {
    return ref.read(leadRepositoryProvider).getLeadHistory(leadId: leadId);
  }

  Future<Result<List<Bank>?>> getBanks() {
    return ref.read(leadRepositoryProvider).getBanks();
  }

  Future<Result<ApiResponse<List<Insurance>?>>> getInsuranceCompanies() {
    return ref.read(leadRepositoryProvider).getInsuranceCompanies();
  }

  Future<Result<ApiResponse<DiscountApproval?>>> getDiscountApprovals(
    int leadId,
  ) {
    return ref.read(leadRepositoryProvider).getDiscountApprovals(leadId);
  }

  Future<Result<ApiResponse<DiscountApproval?>>> getDeliveryApprovals(
    int deliveryId,
  ) {
    return ref.read(leadRepositoryProvider).getDeliveryApprovals(deliveryId);
  }

  Future<Result<ApiResponse?>> downloadLeads({
    int page = 1,
    GetLeadRequest? req,
  }) {
    return ref.read(leadRepositoryProvider).downloadLeads(page: page, req: req);
  }

  Future<Result<ApiResponse<LeadCounts?>>> getLeadCounts() {
    return ref.read(leadRepositoryProvider).getLeadsCounts();
  }
}

//Get Lead List
final getLeadRequestProvider = StateProvider<GetLeadRequest?>((ref) => null);
final leadListScreenTypeProvider = StateProvider<LeadListScreenType>(
  (ref) => LeadListScreenType.allLeads,
);
final leadListCountProvider = StateProvider<String>((ref) => "");
final selectedLeadsProvider = StateProvider<List<Lead>>((ref) => []);
final leadsErrorMessageProvider = StateProvider<String?>((ref) => null);
final canPopLeadListProvider = StateProvider<bool>((ref) => true);

@riverpod
Future<Result<ApiResponse<ApiResponse<List<Lead>?>?>>> leads(
  Ref ref, {
  int page = 1,
}) async {
  final req = ref.read(getLeadRequestProvider);
  final cancelToken = CancelToken();
  // When a page is no-longer used, keep it in the cache.
  final link = ref.keepAlive();
  // Declare a timer to be used by the callbacks below
  Timer? timer;
  // When the provider is destroyed, cancel the http request and the timer
  ref.onDispose(() {
    cancelToken.cancel();
    timer?.cancel();
  });
  // When the last listener is removed, start the timer
  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), () {
      // Dispose the cached data on timeout
      link.close();
    });
  });
  // If the provider is listened again after it was paused, cancel the timer
  ref.onResume(() {
    timer?.cancel();
  });

  final response =
      req!.leadType == "cc_leads"
          ? await ref
              .watch(leadRepositoryProvider)
              .getCampaign(page: page, req: req)
          : await ref
              .watch(leadRepositoryProvider)
              .getLeads(page: page, req: req);

  response.when(
    success: (data) {
      final currentPage = data?.data?.currentPage ?? 0;
      final lastPage = data?.data?.lastPage ?? 0;
      final total = data?.data?.total ?? 0;
      final currentCount = data?.data?.to ?? 0;

      if (lastPage < currentPage && total != 0) return;
      ref
          .read(leadListCountProvider.notifier)
          .update((state) => state = "$currentCount/$total");
    },
    failure: (error) {
      ref
          .read(leadsErrorMessageProvider.notifier)
          .update((state) => state = error.message);
    },
  );

  return response;
}

//lead filters
final leadSelectedFilterMenuItemIndex = StateProvider<int>((ref) => 0);
final leadFilterRequestProvider = StateProvider<GetLeadRequest?>((ref) => null);
final leadModelsProviders = StateProvider<List<Product>>((ref) => []);
final leadScUsersProviders = StateProvider<List<User>>((ref) => []);
final leadCountsProviders = StateProvider<LeadCounts?>((ref) => null);

//create lead
final leadRequestProvider = StateProvider<CreateLeadRequest?>((ref) => null);
final isCreatingFromCCLeadProvider = StateProvider<bool>((ref) => false);
final createLeadFormFocusNodesProvider =
    StateNotifierProvider<FocusNodeNotifier, List<FormFieldFocusNode>>(
      (ref) => FocusNodeNotifier(),
    );
final createLeadFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
final selectedContactIndexProvider = StateProvider<int?>((ref) => null);
final duplicateLeadInOtherOutletProvider = StateProvider<Lead?>((ref) => null);
final isAddedFullAddressProvider = StateProvider<bool>((ref) => false);
final contactDetailsTextFieldControllerProvider = StateNotifierProvider<
  TextFieldControllerNotifier,
  List<TextEditingController>
>((ref) => TextFieldControllerNotifier());
final createdLeadProvider = StateProvider<Lead?>((ref) => null);
final updateLeadProvider = StateProvider<Lead?>((ref) => null);

//bank
final banksProvider = StateProvider<List<Bank>>((ref) => []);
