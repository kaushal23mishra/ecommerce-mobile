import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/approval_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingApprovalActionWidget extends SalesdocketConsumerStatefulWidget {
  const BookingApprovalActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingApprovalActionState();
}

class _BookingApprovalActionState
    extends SalesdocketConsumerState<BookingApprovalActionWidget>
    with ApprovalEvents, LeadEvents, NavigationEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.sendForApproval.tr(),
      onPositiveClicked: () {
        _validateFormAndSubmitRequest();
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    dismissKeyboard();
    if (_isValidForm()) {
      final moreDiscountApprovalReasons = ref.read(
        moreDiscountApprovalReasonsProvider,
      );
      final discountApprovalRequest = ref.read(discountApprovalRequestProvider);
      final request = discountApprovalRequest?.bookingDiscountApprovalRequest(
        approvalReasons: moreDiscountApprovalReasons,
      );
      sendRequestForApproval(leadId: request?.leadID, request: request);
    }
  }

  bool _isValidForm() {
    final moreDiscountApprovalReasons = ref.read(
      moreDiscountApprovalReasonsProvider,
    );
    final discountApprovalRequest = ref.read(discountApprovalRequestProvider);
    final errors =
        discountApprovalRequest?.bookingDiscountApprovalValidationErrors(
          approvalReasons: moreDiscountApprovalReasons,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(discountApprovalFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _changeLeadStatus() {
    final lead = ref.read(discountApprovalLeadRequestProvider);
    final request = lead?.bookingDiscountApprovalChangeLeadStatusRequest();
    changeLeadStatus(leadId: lead?.id, request: request);
  }

  void _createLeadHistory() {
    final lead = ref.read(discountApprovalLeadRequestProvider);
    final request = lead?.bookingDiscountApprovalLeadHistoryRequest();
    createLeadHistory(leadId: lead?.id, req: request);
  }

  void _backToLeadList() {
    ref.invalidate(leadsProvider);
    ref.read(leadsProvider(page: 1));
    showSnackBar(
      LocaleKeys.formSentForApproval.tr(),
      type: SnackBarType.success,
    );

    // Check if LeadListRoute exists in the navigation stack
    final hasLeadListRoute = context.router.stack.any((page) => page.name == LeadListRoute.name);

    if (hasLeadListRoute) {
      // Navigate back to lead listing screen
      context.router.popUntilRouteWithName(LeadListRoute.name);
    } else {
      // Navigate to home screen (new lead flow)
      context.router.replaceAll([const HomeRoute()]);
    }
  }

  @override
  void onApprovalRequestSend() {
    _changeLeadStatus();
  }

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    if (leadStatus == "BPR") {
      _createLeadHistory();
    } else {
      _backToLeadList();
    }
  }

  @override
  void onLeadHistoryCreated() {
    _backToLeadList();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
