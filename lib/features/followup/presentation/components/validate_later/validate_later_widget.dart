import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import '../../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../../common/entity/followup_data_given.dart';
import '../../../../../utility/request_utils.dart';
import '../followup_date_time_widget.dart';

class ValidateLaterWidget extends SalesdocketConsumerStatefulWidget {
  const ValidateLaterWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NextActionWidgetState();
}

class _NextActionWidgetState
    extends SalesdocketConsumerState<ValidateLaterWidget>
    with LeadEvents, NavigationEvents {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scheduled for', style: Theme.of(context).textTheme.titleMedium),
          verticalSpacing(1.h),
          Column(
            children: [
              const FollowupDateTimeWidget(),
              SalesdocketActionWidget(
                positiveText: LocaleKeys.btnSave.tr(),
                onPositiveClicked: () {
                  _validateAndSubmitRequest();
                },
                negativeText: LocaleKeys.lblCancel.tr(),
                onNegativeClicked: () {
                  _backToPrevScreen();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _validateAndSubmitRequest() {
    final followupRequest = ref.read(followupRequestProvider);

    if (_isValidForm(followupRequest)) {
      _createLeadHistory();
    }
  }

  bool _isValidForm(FollowupDataGiven? request) {
    if (request == null) return false;

    final errors = request.followupCallLetterValidationErrors();

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
  }

  /// Create lead history and update state upon success
  Future<void> _createLeadHistory() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);

    if (lead == null || followupRequest == null) {
      showSnackBar("Error: Missing lead or follow-up request.");
      return;
    }

    try {
      await createLeadHistory(
        leadId: lead.id,
        req: FollowupRequestUtils.createLeadHistoryRequest(
          followupData: followupRequest,
          lead: lead,
          status: '1',
        ),
      );

      // Ensure the widget is still mounted before accessing ref
      if (!context.mounted) return;

      // Reset followup state after successful lead history creation
      _resetFollowupState();

      // Navigate back
      leadActionBackToPrevScreen(context);
    } catch (error, stackTrace) {
      if (context.mounted) {
        showSnackBar("Failed to create lead history. Please try again.");
      }
      debugPrint("Error creating lead history: $error\n$stackTrace");
    }
  }

  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest =
        ref.read(followupRequestProvider)?.createLeadFollowupRequest();

    if (lead == null || followupRequest == null) {
      showSnackBar("Error: Missing lead or follow-up request.");
      return;
    }

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);
    } catch (error) {
      showSnackBar("Failed to create lead history. Please try again.");
      print("Error creating lead history: $error");
    }
  }
  void _resetFollowupState() {
    // Reset all followup state
    ref.read(followupCallStatusProvider.notifier).state = false;
    ref.read(followupAlreadySpokenStatusProvider.notifier).state = false;
    ref.read(followupDoneStatusProvider.notifier).state = false;
    ref.read(followupNotDoneStatusProvider.notifier).state = false;
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(callInProgressProvider.notifier).state = false;
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    ref.read(followupRequestProvider.notifier).state = null;
  }
  void _backToPrevScreen({bool isUpdate = false}) {
    _resetFollowupState();
    context.router.maybePop(isUpdate);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) {
    showSnackBar('Lead updated successfully', type: SnackBarType.success);
    _backToPrevScreen(isUpdate: true);
  }

  @override
  WidgetRef get eventRef => ref;
}
