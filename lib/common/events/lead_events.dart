import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin LeadEvents on UiComponentWidget {
  Future fetchLeadHistory({int? leadId}) async {
    if (leadId == null) {
      showSnackBar(LocaleKeys.defaultErrorMessage.tr());
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .getLeadHistory(leadId);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onLeadHistoryFetched(data?.data?.data ?? []);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future fetchLead({int? leadId}) async {
    if (leadId == null) {
      showSnackBar(LocaleKeys.defaultErrorMessage.tr());
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .getLead(leadId);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onLeadFetched(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateLead({int? leadId, Lead? lead}) async {
    if (leadId == null) {
      showSnackBar("Update Lead: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .updateLead(leadId, request: lead, method: 'PATCH');

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        if (data?.status == "error") {
          showSnackBar(data?.error ?? LocaleKeys.defaultErrorMessage.tr());
        } else {
          onLeadUpdated(data?.data?.firstOrNull);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future<void> createLeadHistory({
    int? leadId,
    CreateLeadHistoryRequest? req,
    bool hasCallBack = true,
    BuildContext? context,
  }) async {
    if (leadId == null) {
      if (context?.mounted ?? false) {
        showSnackBar("Create Lead History: lead id can't be null!");
      }
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .createLeadHistory(leadId, request: req);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        if (hasCallBack) {
          onLeadHistoryCreated();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
        onLeadHistoryCreateFailed();
      },
    );
  }

  Future closeLeadHistory({int? followupId, CloseFollowupRequest? req}) async {
    if (followupId == null) {
      showSnackBar("Create Lead History: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .closeLeadHistory(followupId, request: req);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onCloseLeadHistory();
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future createFollowup({int? leadId, LeadFollowupRequest? request}) async {
    if (leadId == null) {
      showSnackBar("Create Lead Followup: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .createLeadFollowup(leadId, request: request);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onFollowupCreated();
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
        onFollowupFailed();
      },
    );
  }

  Future updateFollowup({
    int? workflowId,
    LeadFollowupRequest? request,
    String method = "PATCH",
  }) async {
    if (workflowId == null) {
      showSnackBar("Update Lead Followup: workflow id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .updateLeadFollowup(workflowId, request: request, method: method);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onFollowupUpdated();
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future changeLeadStatus({
    int? leadId,
    ChangeLeadStatusRequest? request,
  }) async {
    if (leadId == null) {
      showSnackBar("Change Lead Status: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .changeLeadStatus(leadId, request: request);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onLeadStatusChanged(request?.leadStatus);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getBanks() async {
    final result =
        await eventRef.read(leadViewModelProvider.notifier).getBanks();

    if (!isMounted) return;
    result.when(
      success: (data) {
        final banks = data ?? [];
        onBanksFetched(banks);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getInsuranceCompanies() async {
    final result =
        await eventRef
            .read(leadViewModelProvider.notifier)
            .getInsuranceCompanies();

    if (!isMounted) return;
    result.when(
      success: (data) {
        final companies = data?.data ?? [];
        onCompaniesFetched(companies);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getDiscountApprovals({int? leadId}) async {
    if (leadId == null) {
      showSnackBar("Get Discount Approvals: lead id can't be null!");
      return;
    }

    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .getDiscountApprovals(leadId);

    if (!isMounted) return;
    result.when(
      success: (data) {
        onDiscountApprovalFetched(data?.data);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getDeliveryApprovals({int? deliveryId}) async {
    if (deliveryId == null) {
      showSnackBar("Get Discount Approvals: delivery id can't be null!");
      return;
    }

    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .getDeliveryApprovals(deliveryId);

    if (!isMounted) return;
    result.when(
      success: (data) {
        onDeliveryApprovalFetched(data?.data);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future downloadLeads({int page = 1, GetLeadRequest? request}) async {
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .downloadLeads(page: 1, req: request);

    if (!isMounted) return;
    result.when(
      success: (data) {
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onLeadsDownloaded();
        }
      },
      failure: (error) {
        Loggy("").debug(error);
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future getLeadCounts() async {
    final result =
        await eventRef.read(leadViewModelProvider.notifier).getLeadCounts();

    if (!isMounted) return;
    result.when(
      success: (data) {
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onLeadCountsFetched(data?.data);
        }
      },
      failure: (error) {
        Loggy("").debug(error);
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void onBanksFetched(List<Bank> banks) {}

  void onCompaniesFetched(List<Insurance> companies) {}

  void onLeadUpdated(Lead? lead) {}

  void onLeadHistoryFetched(List<LeadHistory> history) {}

  void onLeadHistoryCreated() {}

  void onLeadHistoryCreateFailed() {}

  void onCloseLeadHistory() {}

  void onFollowupCreated() {}

  void onFollowupFailed() {}

  void onFollowupUpdated() {}

  void onLeadStatusChanged(String? status) {}

  void onLeadFetched(Lead? lead) {}

  void onLeadsDownloaded() {}

  void onDiscountApprovalFetched(DiscountApproval? approval) {}

  void onDeliveryApprovalFetched(DiscountApproval? approval) {}

  void onLeadCountsFetched(LeadCounts? data) {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
