import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/approval_events.dart';
import 'package:salesdocket_mobile/common/events/delivery_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryApprovalActionWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveryApprovalActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryApprovalActionState();
}

class _DeliveryApprovalActionState
    extends SalesdocketConsumerState<DeliveryApprovalActionWidget>
    with ApprovalEvents, DeliveryEvents, LeadEvents, NavigationEvents {
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
    if (_isValidForm()) {
      _updateDelivery();
    }
  }

  bool _isValidForm() {
    final moreDiscountApprovalReasons = ref.read(
      moreDiscountApprovalReasonsProvider,
    );
    final discountApprovalRequest = ref.read(discountApprovalRequestProvider);
    final deliveryApprovalRequest = ref.read(deliveryApprovalRequestProvider);

    final errors =
        discountApprovalRequest?.deliveryDiscountApprovalValidationErrors(
          approvalReasons: moreDiscountApprovalReasons,
          deliveryApproval: deliveryApprovalRequest,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(discountApprovalFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _updateDelivery() {
    final lead = ref.read(discountApprovalLeadRequestProvider);
    final newDeliveryDetails = ref.read(deliveryApprovalRequestProvider);
    final delivery = lead?.delivery;
    final request = lead?.deliveryApprovalRequest(
      newDeliveryDetails: newDeliveryDetails,
    );

    updateDelivery(deliveryId: delivery?.id, request: request);
  }

  void _sendForApproval(Delivery? delivery) {
    final moreDiscountApprovalReasons = ref.read(
      moreDiscountApprovalReasonsProvider,
    );
    final discountApprovalRequest = ref.read(discountApprovalRequestProvider);
    final request = discountApprovalRequest
        ?.deliveryDiscountApprovalRequest(
          approvalReasons: moreDiscountApprovalReasons,
        )
        .copyWith(deliveryId: delivery?.id);

    sendDeliveryRequestForApproval(deliveryId: delivery?.id, request: request);
  }

  void _changeLeadStatus() {
    final lead = ref.read(discountApprovalLeadRequestProvider);
    final request = lead?.deliveryDiscountApprovalChangeLeadStatusRequest();
    changeLeadStatus(leadId: lead?.id, request: request);
  }

  void _closeBookingFollowup() {
    final lead = ref.read(discountApprovalLeadRequestProvider);
    final request = lead?.deliveryCloseFollowupRequest();
    createLeadHistory(leadId: lead?.id, req: request);
  }

  void _backToLeadList() {
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
  void onLeadStatusChanged(String? leadStatus) async {
    final lead = ref.read(discountApprovalLeadRequestProvider);
    if (lead?.hasBookingFollowup == true) {
      _closeBookingFollowup();
    } else {
      _backToLeadList();
    }
  }

  @override
  void onLeadHistoryCreated() {
    _backToLeadList();
  }

  @override
  void onLeadHistoryCreateFailed() {
    final hasLeadListRoute = context.router.stack.any(
      (page) => page.name == LeadListRoute.name,
    );
    if (hasLeadListRoute) {
      context.router.popUntilRouteWithName(LeadListRoute.name);
    } else {
      context.router.replaceAll([const HomeRoute()]);
    }
  }

  @override
  void onDeliveryApprovalRequestSend() {
    _changeLeadStatus();
  }

  @override
  void onDeliveryUpdated(Delivery? delivery) {
    _sendForApproval(delivery);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
