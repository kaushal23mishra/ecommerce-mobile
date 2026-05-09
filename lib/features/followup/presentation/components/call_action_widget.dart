import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/contact_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../features/lead/view_model/lead_view_model.dart';
import 'booking_followup_spoke_widget.dart';
import 'call_status_widget.dart';
import 'dial_now_widget.dart';
import 'new_lead_status_widget.dart';
import 'not_done_component/visit_date_widget.dart';
import 'call_action_sub_widgets.dart';

class CallActionWidget extends SalesdocketConsumerStatefulWidget {
  const CallActionWidget({super.key});

  @override
  SalesdocketConsumerState<CallActionWidget> createState() =>
      _CallActionWidgetState();
}

class _CallActionWidgetState extends SalesdocketConsumerState<CallActionWidget>
    with ContactEvents, LeadEvents {
  static const _visitActions = ['dealer visit', 'home visit', 'showroom visit'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateShowroomVisitStatus();
  }

  void _updateShowroomVisitStatus() {
    final lead = ref.read(followupLeadRequestProvider);
    final action =
        lead?.workflow?.actions?.lastOrNull?.action?.toLowerCase() ?? '';
    final isShowroom = _visitActions.contains(action);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isShowroomVisitProvider.notifier).state = isShowroom ? 1 : 0;
    });
  }

  Future<void> _handleNotDoneAction(bool isShowroomVisit) async {
    // Always show chip selection first, then confirm popup
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.notDone;
  }

  @override
  Widget build(BuildContext context) {
    final lead = ref.watch(followupLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final action =
        lead.workflow?.actions?.lastOrNull?.action?.toLowerCase() ?? '';
    final phoneNumber = lead.primaryContactNumber.ifEmpty(
      lead.leadMobileNumber.toString(),
    );
    final isVisitAction = _visitActions.contains(action);
    final currentStatus = ref.watch(followupStatusProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInitialWidgets(context, phoneNumber, isVisitAction),
        if (currentStatus == FollowupStatus.done) const DoneWidgets(),
        if (currentStatus == FollowupStatus.notDone) const NotDoneWidgets(),
        if (currentStatus == FollowupStatus.called)
          _buildCalledWidgets(phoneNumber),
        if (currentStatus == FollowupStatus.alreadySpoken)
          const AlreadySpokenWidgets(),
      ],
    );
  }

  Widget _buildInitialWidgets(
    BuildContext context,
    String? phoneNumber,
    bool isVisitAction,
  ) {
    final isShowroomVisit = ref.watch(isShowroomVisitProvider);

    return Column(
      children: [
        if (!isVisitAction) ...[
          Row(
            children: [
              DialNowWidget(
                phoneNumber: phoneNumber,
                makePhoneCall: (number) => makePhoneCall(number, ref),
                onCallInitiated:
                    () =>
                        ref.read(followupStatusProvider.notifier).state =
                            FollowupStatus.called,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: SalesDocketButtonWidget(
                  onPressed: () {
                    if (phoneNumber != null && phoneNumber.isNotEmpty) {
                      ref.read(followupStatusProvider.notifier).state =
                          FollowupStatus.alreadySpoken;
                    } else {
                      context.showSnackBar(
                        LocaleKeys.lblInvalidPhoneNumber.tr(),
                      );
                    }
                  },
                  text: LocaleKeys.lblAlreadySpoken.tr(),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: SalesDocketButtonWidget(
                  text: LocaleKeys.lblDone.tr(),
                  onPressed:
                      () =>
                          ref.read(followupStatusProvider.notifier).state =
                              FollowupStatus.done,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: SalesDocketButtonWidget(
                  text: LocaleKeys.lblNotDone.tr(),
                  isOutlined: true,
                  onPressed: () => _handleNotDoneAction(isShowroomVisit == 1),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ],
    );
  }

  Widget _buildCalledWidgets(String? phoneNumber) {
    return Column(
      children: [
        CallStatusWidget(
          phoneNumber: phoneNumber ?? '',
          makePhoneCall: (number) => makePhoneCall(number, ref),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest =
        ref.read(followupRequestProvider)?.createLeadFollowupRequest();

    if (lead == null || followupRequest == null) {
      showSnackBar(LocaleKeys.lblError_lead_or_followup_missing.tr());
      return;
    }

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);
      if (!context.mounted) return;

      ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
      context.router.push(const FollowupRoute());
    } catch (error, stackTrace) {
      debugPrint("Error creating lead history: $error\n$stackTrace");
      showSnackBar(LocaleKeys.lblError_create_lead_history_failed.tr());
    }
  }

  @override
  WidgetRef get eventRef => ref;
}

