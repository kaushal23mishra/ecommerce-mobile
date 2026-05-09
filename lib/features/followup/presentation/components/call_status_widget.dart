import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'booking_followup_spoke_widget.dart';
import 'call_status_mode.dart';
import 'cc_lead_next_action_widget.dart';
import 'incorrect_number_next_action_widget.dart';
import 'new_action_widget.dart';
import 'new_lead_status_widget.dart';

class CallStatusWidget extends ConsumerWidget {
  final String phoneNumber;
  final Function(String) makePhoneCall;

  const CallStatusWidget({
    super.key,
    required this.phoneNumber,
    required this.makePhoneCall,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callDuration = ref.watch(callDurationProvider);
    final callStatus = ref.watch(callStatusProvider);
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.callStatus);
    final lead = ref.watch(followupLeadRequestProvider);
    final isCCLead = lead?.isItCCLead ?? false;
    final isBookingFollowup =
        ref.watch(leadListScreenTypeProvider).isBookingFollowup;

    // Determine which chips to enable based on call duration
    final disabledChips = _getDisabledChips(callDuration, callStatus);
    final chips = isBookingFollowup
        ? callStateList
            .where((c) => c != CallState.incorrectNumber.value)
            .toList()
        : callStateList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(0.25.h),
        Text(
          LocaleKeys.lblCallStatus.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SalesDocketChipWidget(
          disabledChips: disabledChips,
          chips: chips,
          selectedChips: callStatus != null ? [callStatus] : [],
          errorText: error?.message,
          onSelected:
              (selected) => _handleChipSelection(
                selected?.cast<String>() ?? [],
                disabledChips,
                context,
                ref,
              ),
        ),
        verticalSpacing(0.5.h),
        if (_shouldShowNextAction(callStatus))
          isCCLead
              ? CCLeadNextActionWidget(
                  phoneNumber: phoneNumber,
                  makePhoneCall: makePhoneCall,
                )
              : NextActionWidget(
                  phoneNumber: phoneNumber,
                  makePhoneCall: makePhoneCall,
                ),
        if (callStatus == CallState.spokeToCustomer.value) ...[
          if (isBookingFollowup)
            const BookingFollowupSpokeWidget()
          else
            const NewLeadStatusWidget(),
        ],
        if (!isBookingFollowup &&
            callStatus == CallState.incorrectNumber.value)
          const IncorrectNumberNextActionWidget(),
      ],
    );
  }

  List<String> _getDisabledChips(int? duration, String? status) {
    return [];
  }
  bool _shouldShowNextAction(String? status) {
    return status != null &&
        [
          LocaleKeys.lblBusy.tr(),
          LocaleKeys.lblSwitchedOff.tr(),
          LocaleKeys.lblOutOfNetwork.tr(),
        ].contains(status);
  }

  void _handleChipSelection(
    List<String> selected,
    List<String> disabled,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (selected.isEmpty) {
      ref.read(callStatusProvider.notifier).state = null;
      return;
    }

    final selectedValue = selected.first;

    if (disabled.contains(selectedValue)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This call status is not available for the current call',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ref.read(callStatusProvider.notifier).state = selectedValue;
    ref
        .read(createFollowUpFormErrorsProvider.notifier)
        .remove(CreateFollowUpFormFields.callStatus);
  }
}
