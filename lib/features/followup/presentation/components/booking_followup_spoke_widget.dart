import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/followup_customer_comment_widget.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/followup_date_time_widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingFollowupSpokeWidget extends SalesdocketConsumerStatefulWidget {
  const BookingFollowupSpokeWidget({super.key});

  @override
  SalesdocketConsumerState<BookingFollowupSpokeWidget> createState() =>
      _BookingFollowupSpokeWidgetState();
}

class _BookingFollowupSpokeWidgetState
    extends SalesdocketConsumerState<BookingFollowupSpokeWidget>
    with LeadEvents, NavigationEvents {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(followupRequestProvider.notifier).update(
        (f) => f?.copyWith(nextFollowup: FollowUpPlanType.call.value),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FollowupCustomerCommentWidget(),
        verticalSpacing(2.h),
        Text(
          LocaleKeys.lblPlanFollowUp.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        SalesDocketChipWidget<String>(
          chips: [FollowUpPlanType.call.value],
          selectedChips: [FollowUpPlanType.call.value],
          onSelected: (_) {},
        ),
        const FollowupDateTimeWidget(hasThreeFailedCalls: true),
        verticalSpacing(1.h),
        SalesdocketActionWidget(
          positiveText: LocaleKeys.btnSave.tr(),
          onPositiveClicked: _validateAndSave,
          negativeText: LocaleKeys.lblCancel.tr(),
          onNegativeClicked: _cancel,
        ),
      ],
    );
  }

  void _validateAndSave() {
    final followupRequest = ref.read(followupRequestProvider);
    final errors = FollowupRequestUtils.validateBookingFollowup(followupRequest);

    if (errors.isNotEmpty) {
      showSnackBar(errors.first.message ?? LocaleKeys.errEnterCustomerRemarks.tr());
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return;
    }

    _createLeadHistory();
  }

  Future<void> _createLeadHistory() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);
    if (lead == null || followupRequest == null) return;

    final request = FollowupRequestUtils.createLeadHistoryRequest(
      followupData: followupRequest,
      lead: lead,
      status: '1',
      responseType: FollowUpPlanType.bookingCall.value,
      when: '',
    );
    await createLeadHistory(leadId: lead.id, req: request);
  }

  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);
    if (lead == null || followupRequest == null) return;

    final nextFollowup = followupRequest.nextFollowup ?? '';
    if (nextFollowup.isEmpty) {
      showSnackBar(LocaleKeys.errNextFollowup.tr());
      return;
    }

    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    await createFollowup(
      leadId: lead.id,
      request: FollowupRequestUtils.createBookingFollowupRequest(
        followupRequest: followupRequest,
        actorId: user?.id,
      ),
    );
  }

  @override
  void onLeadHistoryCreateFailed() {
    if (!mounted) return;
    leadActionBackToPrevScreen(context, shouldBackToPrev: true);
  }

  @override
  void onFollowupCreated() {
    if (!mounted) return;
    showSnackBar(
      LocaleKeys.lblFollowupCreatedSuccessfully.tr(),
      type: SnackBarType.success,
    );
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(followupRequestProvider.notifier).state = null;
    ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();
    leadActionBackToPrevScreen(context, shouldBackToPrev: true);
  }

  @override
  void onFollowupFailed() {
    if (!mounted) return;
    leadActionBackToPrevScreen(context, shouldBackToPrev: true);
  }

  void _cancel() {
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(followupRequestProvider.notifier).update(
      (f) => f?.copyWith(nextAction: '', remarks: '', nextFollowup: '', when: ''),
    );
    ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    if (mounted) context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
