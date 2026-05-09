import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

mixin CreateLeadEvents on UiComponentWidget {
  void searchLeads(String contactNumber) {
    final request = LeadSearchRequest(
      count: "10000",
      search: contactNumber,
      searchBy: 'phone',
    );

    showLoader();
    eventRef
        .read(leadViewModelProvider.notifier)
        .searchLeads(request: request)
        .then((result) {
          result.when(
            success: (data) {
              hideLoader();
              if (data != null) {
                onLeadSearched(data, contactNumber);
              } else {
                showSnackBar(
                  LocaleKeys.defaultErrorMessage,
                  type: SnackBarType.error,
                );
              }
            },
            failure: (error) {
              hideLoader();
              showSnackBar(
                error.message ?? LocaleKeys.defaultErrorMessage,
                type: SnackBarType.error,
              );
            },
          );
        });
  }

  void onLeadSearched(LeadSearchResponse searchData, String contactToCheck) {
    final sameOutletLeads = searchData.sameOutletLeads?.data ?? [];
    final linkedOutletLeads = searchData.linkedOutletLeads ?? [];
    final otherOutletLeads = searchData.otherOutletLeads ?? [];

    Lead? sameOutletLead = eventRef
        .read(leadViewModelProvider.notifier)
        .filterExistingSameOutletLead(sameOutletLeads, contactToCheck);
    if (sameOutletLead != null) {
      showSameOutletDuplicateLeadBottomSheet(sameOutletLead, contactToCheck);
      return;
    }

    Lead? linkedOutletLead = eventRef
        .read(leadViewModelProvider.notifier)
        .filterExistingLinkedOutletLead(linkedOutletLeads, contactToCheck);
    if (linkedOutletLead != null) {
      showLinkedOutletDuplicateLeadBottomSheet(linkedOutletLead);
      return;
    }

    Lead? otherOutletLead = eventRef
        .read(leadViewModelProvider.notifier)
        .filterExistingOtherOutletLead(otherOutletLeads, contactToCheck);
    if (otherOutletLead != null) {
      showOtherOutletDuplicateLeadBottomSheet(otherOutletLead);
      return;
    }

    eventRef
        .read(duplicateLeadInOtherOutletProvider.notifier)
        .update((lead) => lead = null);
  }

  void showLinkedOutletDuplicateLeadBottomSheet(Lead lead) {
    final workflowState = lead.workflow?.state;
    if (workflowState == null || workflowState.isEmpty) return;

    switch (WorkflowState(workflowState)) {
      case WorkflowState.registered:
      case WorkflowState.lost:
      case WorkflowState.closed:
      case WorkflowState.lpa:
        //show registration summary box
        break;
      case WorkflowState.booking:
      case WorkflowState.inactive:
      case WorkflowState.bpr:
      case WorkflowState.booked:
      case WorkflowState.cpa:
      case WorkflowState.cancelled:
        //show booking summary box
        break;
      case WorkflowState.delivered:
      case WorkflowState.dpr:
        //show delivery summary box
        break;
    }
  }

  void showSameOutletDuplicateLeadBottomSheet(
    Lead lead,
    String contactToCheck,
  ) {
    final leadState = lead.workflow?.state;
    final existedStates = <String>[
      WorkflowState.closed.value,
      WorkflowState.lost.value,
      WorkflowState.inactive.value,
    ];

    if (existedStates.any((value) => value.equals(leadState))) {
      final selectedIndex = eventRef.read(selectedContactIndexProvider) ?? 0;
      final controllers = eventRef.read(
        contactDetailsTextFieldControllerProvider,
      );
      controllers[selectedIndex].clear();
      showBottomSheet(
        isDismissible: false,
        builder:
            (_) => SalesdocketAlertBottomSheet(
              title: "Record Found!",
              description: "Lead already exist with ${leadState ?? ""} status.",
              buttonText: "Reactive",
              buttonColor: appColors.primary,
              onActionClicked: () => handleReactiveDuplicateLead(lead),
              onCloseClicked: () {
                clearContactDetails(lead);
              },
            ),
      );
    } else {
      showBottomSheet(
        isDismissible: false,
        builder:
            (_) => SalesdocketAlertBottomSheet(
              title: "Record Found!",
              description: "Case already being handled by ${lead.assigned?.fullName ?? ""}.",
              buttonText: "Ok",
              buttonColor: appColors.primary,
              onActionClicked: () => clearContactDetails(lead),
              onCloseClicked: () => clearContactDetails(lead),
            ),
      );
    }
  }

  void showOtherOutletDuplicateLeadBottomSheet(Lead lead) {
    final scName = lead.assigned?.fullName ?? '';
    final dealerName = lead.organization?.name ?? '';
    final description =
        dealerName.isNotEmpty
            ? LocaleKeys.caseAlreadyHandledAt.tr(namedArgs: {'scName': scName, 'dealerName': dealerName})
            : LocaleKeys.caseAlreadyHandled.tr(namedArgs: {'scName': scName});

    showBottomSheet(
      isDismissible: false,
      builder:
          (_) => SalesdocketAlertBottomSheet(
            title: LocaleKeys.lblRecordFound.tr(),
            description: description,
            buttonText: LocaleKeys.lblOk.tr(),
            buttonColor: appColors.primary,
            onActionClicked: () => clearContactDetails(lead),
            onCloseClicked: () => clearContactDetails(lead),
          ),
    );
  }

  void handleDuplicateLead(Lead lead) {}

  void handleReactiveDuplicateLead(Lead lead) {}

  void clearContactDetails(Lead lead) {}

  Future createGroupedLead({required CreateLeadRequest request}) async {
    showLoader();
    final result = await eventRef
        .read(leadViewModelProvider.notifier)
        .createGroupedLead(request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onLeadCreated(data?.data?.firstOrNull);
      },
      failure: (err) {
        hideLoader();
        showSnackBar(err.message ?? LocaleKeys.defaultErrorMessage);
      },
    );
  }

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void onLeadCreated(Lead? lead) {}

  void showBottomSheet({
    bool isDismissible = false,
    required WidgetBuilder builder,
  }) {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
