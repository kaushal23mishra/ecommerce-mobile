import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' show CupertinoDatePickerMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/services/snackbar_service.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingFollowupPopup extends SalesdocketConsumerStatefulWidget {
  final Lead lead;

  const BookingFollowupPopup({super.key, required this.lead});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingFollowupPopupState();
}

class _BookingFollowupPopupState
    extends SalesdocketConsumerState<BookingFollowupPopup>
    with LeadEvents {
  DateTime? _selectedDateTime;
  String? _dateTimeError;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);

    return SalesdocketBottomSheet(
      title: LocaleKeys.lblBookingFollowup.tr(),
      widget: Stack(
        children: [
          Column(
            children: [
              SalesdocketTimePickerSpinnerPopUp(
                label: LocaleKeys.msgFollowupDateTime.tr(),
                mode: CupertinoDatePickerMode.dateAndTime,
                minTime: DateTime.now(),
                initTime: _selectedDateTime,
                errorText: _dateTimeError,
                onChange: (dateTime) {
                  setState(() {
                    _selectedDateTime = dateTime;
                    _dateTimeError = null;
                  });
                },
              ),
              verticalSpacing(2.h),
              SalesDocketButtonWidget(
                text: LocaleKeys.lblCreateFollowup.tr(),
                onPressed: _onCreateFollowup,
                backgroundColor: appColors.primary,
              ),
            ],
          ),
          Positioned.fill(
            child: SalesdocketLoadingOverlay(isLoading: isLoading),
          ),
        ],
      ),
    );
  }

  void _onCreateFollowup() {
    if (_selectedDateTime == null) {
      setState(() => _dateTimeError = LocaleKeys.lblSelectFollowupDate.tr());
      return;
    }

    final openFollowupId = widget.lead.openBookingFollowupId;

    if (openFollowupId != null) {
      final request = FollowupRequestUtils.createLeadHistoryRequest(
        followupData: FollowupDataGiven(remarks: 'Booking Followup Done'),
        lead: widget.lead,
        workflowId: openFollowupId,
        responseType: FollowUpPlanType.bookingCall.value,
        status: '1',
      );

      createLeadHistory(leadId: widget.lead.id, req: request);
    } else {
      final user = ref.read(profileProvider);
      final request = FollowupRequestUtils.createBookingFollowupRequest(
        followupRequest: FollowupDataGiven(when: _selectedDateTime!.formatDateTime()),
        actorId: user?.id,
      );

      createFollowup(leadId: widget.lead.id, request: request);
    }
  }

  @override
  void onLeadHistoryCreated() {
    final user = ref.read(profileProvider);
    final request = FollowupRequestUtils.createBookingFollowupRequest(
      followupRequest: FollowupDataGiven(when: _selectedDateTime!.formatDateTime()),
      actorId: user?.id,
    );

    createFollowup(leadId: widget.lead.id, request: request);
  }

  @override
  void onLeadHistoryCreateFailed() {
    context.router.maybePop(false);
  }

  @override
  void onFollowupCreated() {
    showSnackBar(
      LocaleKeys.lblFollowupCreatedSuccessfully.tr(),
      type: SnackBarType.success,
    );
    context.router.maybePop(true);
  }

  @override
  void onFollowupFailed() {
    context.router.maybePop(false);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    showGlobalSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
