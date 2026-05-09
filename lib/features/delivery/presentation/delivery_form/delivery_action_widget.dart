import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/approval_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/events/approval_events.dart';
import 'package:salesdocket_mobile/common/events/delivery_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/reject_discount_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/widget.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../routing/app_router.dart';
import '../../../../utility/validation_utils.dart';

class DeliveryActionWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveryActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeliveryActionState();
}

class _DeliveryActionState
    extends SalesdocketConsumerState<DeliveryActionWidget>
    with LeadEvents, DeliveryEvents, ApprovalEvents, NavigationEvents {
  @override
  Widget build(BuildContext context) {
    final approval = ref.watch(deliveryDiscountApprovalsProvider);
    final lead = ref.watch(deliveryLeadRequestProvider);
    final canEdit = ref.watch(canEditDeliveryProvider);

    if (lead?.showDeliveryDiscountApproval == true &&
        approval?.approvalStatus != 2) {

      return _buildRejectApproveWidget();
    }

    if (!canEdit) {
      return _buildExitWidget();
    }

    return _buildDeliverNowWidget();
  }

  Widget _buildRejectApproveWidget() {
    return SalesdocketActionWidget(
      negativeText: LocaleKeys.reject.tr(),
      onNegativeClicked: _showRejectAlert,
      positiveText: LocaleKeys.approve.tr(),
      onPositiveClicked: _showApproveAlert,
    );
  }

  Widget _buildExitWidget() {
    return SalesdocketActionWidget(
      onPositiveClicked:
          () => leadActionBackToPrevScreen(context, shouldBackToPrev: true),
      positiveText: LocaleKeys.exit.tr(),
    );
  }

  Widget _buildDeliverNowWidget() {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.deliverNow.tr(),
      onPositiveClicked: _validateFormAndSubmitRequest,
    );
  }

  Future<void> _validateFormAndSubmitRequest() async {
    if (!_isValidForm()) return;

    final lead = ref.read(deliveryLeadRequestProvider);
    final newDeliveryDetails = ref.read(selectedDeliveryProvider);
    final request = lead?.deliveryFormRequest(
      newDeliveryDetails: newDeliveryDetails,
    );

    await updateLead(leadId: lead?.id, lead: request);
  }

  bool _isValidForm() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final newDeliveryDetails = ref.read(selectedDeliveryProvider);
    final errors =
        lead?.deliveryFormValidationErrors(
          newDeliveryDetails: newDeliveryDetails,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(deliveryFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
  }

  Future<void> _updateOrCreateDelivery() async {
    final lead = ref.read(deliveryLeadRequestProvider);
    final newDeliveryDetails = ref.read(selectedDeliveryProvider);

    if (lead?.delivery?.id != null) {
      final request = lead?.deliveryFormUpdateDeliveryRequest(
        newDeliveryDetails: newDeliveryDetails,
      );
      await updateDelivery(deliveryId: lead?.delivery?.id, request: request);
    } else {
      final request = lead?.deliveryFormCreateDeliveryRequest(
        newDeliveryDetails: newDeliveryDetails,
      );
      await createDelivery(request: request);
    }
  }


  Future<void> _uploadDocuments(Delivery? delivery) async {
    final newDeliveryDetails = ref.read(selectedDeliveryProvider);
    final lead = ref.read(deliveryLeadRequestProvider);
    final request = lead?.deliveryFormUploadDeliveryDocumentRequest(
      newDeliveryDetails: newDeliveryDetails,
    );
    await uploadDeliveryDocuments(deliveryId: delivery?.id, request: request);
  }

  void _processDelivery() {
    final user = ref.read(profileProvider);
    if (user?.isAdmin == true || user?.isSalesManager == true) {
      _changeLeadStatus();
    } else {
      _showSMAlertDialog();
    }
  }

  Future<void> _changeLeadStatus() async {
    final lead = ref.read(deliveryLeadRequestProvider);
    final request = lead?.deliveryFormChangeLeadStatusRequest();
    await changeLeadStatus(leadId: lead?.id, request: request);
  }

  void _closeBookingFollowup() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final request = lead?.deliveryCloseFollowupRequest();
    createLeadHistory(leadId: lead?.id, req: request);
  }

  void _showSMAlertDialog() {
    showSalesdocketBottomSheet(
      context: context,
      builder:
          (context) => SalesdocketAlertBottomSheet(
            title: LocaleKeys.deliveryApprovalRequest.tr(),
            description: LocaleKeys.deliveryFormApproval.tr(),
            buttonText: LocaleKeys.ok.tr(),
            buttonColor: appColors.primary,
            onActionClicked: _moveToApprovalRequestScreen,
          ),
    );
  }

  void _moveToApprovalRequestScreen() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final discounts = ref.read(deliveryDiscountsProvider);
    final quotation = lead?.offerList.firstOrNull;
    final totalDiscount = quotation?.totalDiscount ?? 0;
    final discountCap = discounts.lastOrNull?.discountCap ?? 0;

    ref.read(deliveryApprovalRequestProvider.notifier).state =
        lead?.delivery ?? const Delivery();
    ref.read(discountApprovalRequestProvider.notifier).state = DiscountApproval(
      discountCap: discountCap.toDouble(),
      discountGiven: totalDiscount.toDouble(),
      leadID: lead?.id,
      variantId: lead?.primaryVariantId,
    );
    ref.read(discountApprovalLeadRequestProvider.notifier).state = lead;
    ref.read(approvalTypeProvider.notifier).state = ApprovalType.delivery;

    context.router.push(const ApprovalRoute());
  }

  void _showApproveAlert() {
    showSalesdocketBottomSheet(
      context: context,
      builder:
          (context) => SalesdocketAlertBottomSheet(
            title: LocaleKeys.approveDelivery.tr(),
            buttonText: LocaleKeys.approve.tr(),
            description: LocaleKeys.deliveryApprovalConfirmation.tr(),
            buttonColor: appColors.primary,
            icon: SalesDocketImageWidget(
              imagePath: Assets.svg.icCircleCheck.path,
              width: 8.w,
            ),
            onActionClicked: () {
              final request = ref
                  .read(sendDeliveryDiscountApprovalRequestProvider)
                  ?.copyWith(approvalStatus: "Approved", requestResponse: null);
              _sendApproval(request: request);
            },
          ),
    );
  }

  void _showRejectAlert() {
    ref.read(sendDeliveryDiscountApprovalRequestProvider.notifier).state = ref
        .read(sendDeliveryDiscountApprovalRequestProvider)
        ?.copyWith(requestResponse: null);
    ref
        .read(deliveryFormErrorsProvider.notifier)
        .remove(DiscountFormFields.rejectReason);

    showSalesdocketBottomSheet(
      context: context,
      builder:
          (context) => RejectDiscountWidget(
            onRejectClicked: () {
              final request = ref
                  .read(sendDeliveryDiscountApprovalRequestProvider)
                  ?.copyWith(approvalStatus: "Rejected");
              _sendApproval(request: request);
            },
          ),
    );
  }

  Future<void> _sendApproval({DiscountApprovalRequest? request}) async {
    final delivery = ref.read(selectedDeliveryProvider);
    await sendDeliveryApproval(deliveryId: delivery?.id, request: request);
  }

  @override
  void onDeliveryApprovalSend(DiscountApproval? discountApproval) {
    if (discountApproval?.approvalStatus == 1) {
      _changeLeadStatus();
    } else {
      showSnackBar("This lead has been rejected!", type: SnackBarType.warning);
      leadActionBackToPrevScreen(context);
    }
  }

  @override
  void onLeadStatusChanged(String? leadStatus) {
    final lead = ref.read(deliveryLeadRequestProvider);
    if (lead?.hasBookingFollowup == true) {
      _closeBookingFollowup();
    } else {
      showSnackBar(LocaleKeys.deliveryCreated.tr(), type: SnackBarType.success);
      leadActionBackToPrevScreen(context);
    }
  }

  @override
  void onLeadHistoryCreated() {
    showSnackBar(LocaleKeys.deliveryCreated.tr(), type: SnackBarType.success);
    leadActionBackToPrevScreen(context);
  }

  @override
  void onLeadHistoryCreateFailed() {
    leadActionBackToPrevScreen(context);
  }

  @override
  Future<void> onDeliveryCreated(Delivery? delivery) async {
    await _uploadDocuments(delivery);
    _processDelivery();
  }

  @override
  Future<void> onDeliveryUpdated(Delivery? delivery) async {
    await _uploadDocuments(delivery);
    _processDelivery();
  }

  @override
  Future<void> onLeadUpdated(Lead? lead) async {
    await _updateOrCreateDelivery();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    if (mounted) {
      context.showSnackBar(message, type: type);
    }
  }

  @override
  WidgetRef get eventRef => ref;
}
