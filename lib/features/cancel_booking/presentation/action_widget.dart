import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerStatefulWidget {
  const ActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionState();
}

class _ActionState extends SalesdocketConsumerState<ActionWidget>
    with LeadEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.ok.tr(),
      onPositiveClicked: () {
        _validateAndSubmitRequest();
      },
      negativeText: LocaleKeys.lblCancel.tr(),
      onNegativeClicked: () {
        _backToPrevScreen();
      },
    );
  }

  void _validateAndSubmitRequest() {
    if (_isValidForm()) {
      final lead = ref.read(cancelBookingLeadProvider);
      final request = ref.read(cancelBookingRequestProvider);
      changeLeadStatus(leadId: lead?.id, request: request);
    }
  }

  void _closeFollowup() {
    final lead = ref.read(cancelBookingLeadProvider);
    final request = lead?.cancelBookingCloseFollowupRequest();
    createLeadHistory(leadId: lead?.id, req: request);
  }

  bool _isValidForm() {
    final cancelBookingRequest = ref.read(cancelBookingRequestProvider);
    final errors = cancelBookingRequest?.cancelBookingValidationErrors() ?? [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(cancelBookingFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _backToPrevScreen({bool isInactive = false}) {
    context.router.pop(isInactive);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    final lead = ref.read(cancelBookingLeadProvider);
    if (lead?.hasBookingFollowup == true) {
      _closeFollowup();
    } else {
      showSnackBar(
        LocaleKeys.bookingCancellationSentForApproval.tr(),
        type: SnackBarType.success,
      );
      _backToPrevScreen(isInactive: true);
    }
  }

  @override
  void onLeadHistoryCreated() {
    showSnackBar(
      LocaleKeys.bookingCancellationSentForApproval.tr(),
      type: SnackBarType.success,
    );
    _backToPrevScreen(isInactive: true);
  }

  @override
  void onLeadHistoryCreateFailed() {
    _backToPrevScreen(isInactive: true);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
