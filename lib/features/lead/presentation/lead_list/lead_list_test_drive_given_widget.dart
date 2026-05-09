import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/test_drive_given_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadListTestDriveGivenWidget extends SalesdocketConsumerStatefulWidget {
  final Lead lead;

  const LeadListTestDriveGivenWidget({super.key, required this.lead});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeadListTestDriveGivenState();
}

class _LeadListTestDriveGivenState
    extends SalesdocketConsumerState<LeadListTestDriveGivenWidget>
    with LeadEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);

    return SalesdocketBottomSheet(
      title: LocaleKeys.testDriveGiven.tr(),
      padding: EdgeInsets.zero,
      widget: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: const TestDriveGivenWidget(),
              ),
              verticalSpacing(2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SalesdocketActionWidget(
                  positiveText: LocaleKeys.save.tr(),
                  negativeText: LocaleKeys.lblCancel.tr(),
                  onNegativeClicked: () {
                    context.router.maybePop();
                  },
                  onPositiveClicked: () {
                    _validateFormAndSubmitRequest();
                  },
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: SalesdocketLoadingOverlay(
              isLoading: isLoading,
              barrierColor: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  void _invalidateProviders() {
    final providers = [selectedTestDriveGivenProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [prospectFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _fetchData() {
    fetchLeadHistory(leadId: widget.lead.id);
  }

  void _validateFormAndSubmitRequest() {
    if (_isValidForm()) {
      final newTestDrive = ref.read(selectedTestDriveGivenProvider);
      createLeadHistory(
        leadId: widget.lead.id,
        req: RequestUtils.createLeadHistoryRequest(newTestDrive: newTestDrive),
      );
    }
  }

  bool _isValidForm() {
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final errors = newTestDrive?.testDriveGivenValidationErrors() ?? [];

    if (errors.isNotEmpty) {
      ref.read(prospectFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  @override
  void onLeadHistoryCreated() {
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final request = widget.lead.prospectBuyingDetailsRequest(
      newTestDrive: newTestDrive,
    );
    updateLead(leadId: widget.lead.id, lead: request);
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    final testDriveHistory = history.firstWhereOrNull(
      (toFilter) => toFilter.responseType == 'test_drive',
    );
    final testDriveGiven = testDriveHistory?.testDriveGiveDerails;

    ref
        .read(selectedTestDriveGivenProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate = testDriveGiven?.copyWith(
                given: widget.lead.isTestDriveGiven,
              ),
        );
  }

  @override
  void onLeadUpdated(Lead? lead) {
    // Fetch the updated lead with all details including test drive status
    fetchLead(leadId: lead?.id);
  }

  @override
  void onLeadFetched(Lead? lead) {
    // Invalidate the leads list so it refreshes with updated data
    ref.invalidate(leadsProvider);

    // Close the popup
    context.router.maybePop();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
