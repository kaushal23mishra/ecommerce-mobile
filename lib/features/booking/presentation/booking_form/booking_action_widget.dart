import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/approval_type.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/approval_events.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/reject_discount_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingActionWidget extends SalesdocketConsumerStatefulWidget {
  const BookingActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingActionState();
}

class _BookingActionState extends SalesdocketConsumerState<BookingActionWidget>
    with LeadEvents, BookingEvents, ApprovalEvents, NavigationEvents {
  @override
  Widget build(BuildContext context) {
    final approval = ref.watch(bookingDiscountApprovalsProvider);
    final lead = ref.watch(bookingLeadRequestProvider);

    if (lead?.showBookingDiscountApproval == true &&
        approval?.approvalStatus != 3) {

      return _rejectApproveWidget;
    }

    final canEdit = ref.watch(canEditBookingProvider);
    if (!canEdit) {
      return _exitWidget;
    }

    return _bookNowWidget;
  }

  Widget get _rejectApproveWidget {
    final lead = ref.watch(bookingLeadRequestProvider);
    final workflow = lead?.workflow;

    return SalesdocketActionWidget(
      negativeText: LocaleKeys.reject.tr(),
      onNegativeClicked: () {
        if (workflow?.isCPA ?? false) {
          _showRejectCPAAlert();
        } else {
          _showRejectDiscountAlert();
        }
      },
      positiveText: LocaleKeys.approve.tr(),
      onPositiveClicked: () {
        if (workflow?.isCPA ?? false) {
          _showApproveCPAAlert();
        } else {
          _showApproveDiscountAlert();
        }
      },
    );
  }

  Widget get _exitWidget {
    return SalesdocketActionWidget(
      onPositiveClicked: () {
        leadActionBackToPrevScreen(context, shouldBackToPrev: true);
      },
      positiveText: LocaleKeys.exit.tr(),
    );
  }

  Widget get _bookNowWidget {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.bookNow.tr(),
      onPositiveClicked: () {
        _validateFormAndSubmitRequest();
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    dismissKeyboard();
    if (_isValidForm()) {
      final lead = ref.read(bookingLeadRequestProvider);
      final newBookingDetails = ref.read(selectedBookingProvider);
      final request = lead?.bookingFormRequest(
        newBookingDetails: newBookingDetails,
      );
      updateLead(leadId: lead?.id, lead: request);
    }
  }

  bool _isValidForm() {
    final isScheduled = ref.read(scheduleCallFollowupProvider);
    if (isScheduled) {
      final followupDateTime = ref.read(bookingFollowupDateTimeProvider);
      if (followupDateTime == null || followupDateTime.isEmpty) {
        showSnackBar("Please select a follow-up date & time");
        return false;
      }
    }

    final lead = ref.read(bookingLeadRequestProvider);
    final receipts = ref
        .watch(bookingReceiptsProvider)
        .filteredReceipts(type: ReceiptType.booking);
    final amountCollected = receipts.amount;
    ref
        .read(selectedBookingProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate = toUpdate?.copyWith(amountCollected: amountCollected),
        );
    final newBookingDetails = ref.read(selectedBookingProvider);
    final errors =
        lead?.bookingFormValidationErrors(
          newBookingDetails: newBookingDetails,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(bookingFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _updateOrCreateBooking() {
    final lead = ref.read(bookingLeadRequestProvider);
    final newBookingDetails = ref.read(selectedBookingProvider);
    final booking = lead?.booking;
    if (booking?.id != null) {
      final request = lead?.bookingFormUpdateBookingRequest(
        newBookingDetails: newBookingDetails,
      );
      updateBooking(bookingId: booking?.id, request: request);
    } else {
      final request = lead?.bookingFormCreateBookingRequest(
        newBookingDetails: newBookingDetails,
      );
      createBooking(request: request);
    }
  }

  void _changeLeadStatus() {
    final user = ref.read(profileProvider);
    final lead = ref.read(bookingLeadRequestProvider);
    final discounts = ref.read(bookingDiscountsProvider);
    final quotation = lead?.offerList.firstOrNull;
    final totalDiscount = quotation?.totalDiscount ?? 0;
    final discountCap = discounts.lastOrNull?.discountCap;

    if (!((user?.isAdmin ?? false) || (user?.isSalesManager ?? false)) &&
        (discountCap != null && totalDiscount > discountCap)) {
      _showSMAlertDialog();
      return;
    }

    final request = lead?.bookingFormChangeLeadStatusRequest();
    changeLeadStatus(leadId: lead?.id, request: request);
  }

  void _showSMAlertDialog() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketAlertBottomSheet(
          title: LocaleKeys.bookingApprovalRequest.tr(),
          description: LocaleKeys.bookingFormWillGoToSMForApproval.tr(),
          buttonText: LocaleKeys.ok.tr(),
          buttonColor: appColors.primary,
          onActionClicked: () {
            _moveToApprovalRequestScreen();
          },
        );
      },
    );
  }

  void _moveToApprovalRequestScreen() {
    final lead = ref.read(bookingLeadRequestProvider);
    final discounts = ref.read(bookingDiscountsProvider);
    final quotation = lead?.offerList.firstOrNull;
    final totalDiscount = quotation?.totalDiscount ?? 0;
    final discountCap = discounts.lastOrNull?.discountCap ?? 0;
    ref
        .read(discountApprovalRequestProvider.notifier)
        .update(
          (state) =>
              state = DiscountApproval(
                discountCap: discountCap.toDouble(),
                discountGiven: totalDiscount.toDouble(),
                leadID: lead?.id,
                variantId: lead?.primaryVariantId,
              ),
        );
    ref
        .read(discountApprovalLeadRequestProvider.notifier)
        .update((state) => state = lead);
    ref
        .read(approvalTypeProvider.notifier)
        .update((state) => state = ApprovalType.booking);

    final isScheduled = ref.read(scheduleCallFollowupProvider);
    if (isScheduled) {
      final hasActiveFollowup =
          lead?.workflow?.actions?.any((a) => (a.status ?? 0) == 1) == true;
      if (hasActiveFollowup) {
        // Close the existing open followup first; onLeadHistoryCreated() will
        // call _createCallFollowup() because isScheduled is still true.
        _closeFollowup();
      } else {
        _createCallFollowup();
      }
    }

    context.router.push(const ApprovalRoute());
  }

  void _showApproveCPAAlert() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketAlertBottomSheet(
          title: "Approve Cancellation",
          buttonText: LocaleKeys.approve.tr(),
          description: "Booking Cancellation will be approved.",
          icon: SalesDocketImageWidget(
            imagePath: Assets.svg.icCircleCheck.path,
            width: 8.w,
          ),
          buttonColor: appColors.primary,
          onActionClicked: () {
            final lead = ref.read(bookingLeadRequestProvider);
            sendCPAApproval(
              leadId: lead?.id,
              request: const ChangeLeadStatusRequest(approvalStatus: "1"),
            );
          },
        );
      },
    );
  }

  void _showApproveDiscountAlert() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketAlertBottomSheet(
          title: LocaleKeys.approveBooking.tr(),
          buttonText: LocaleKeys.approve.tr(),
          description: LocaleKeys.bookingWillBeApprovedWithGivenDiscounts.tr(),
          icon: SalesDocketImageWidget(
            imagePath: Assets.svg.icCircleCheck.path,
            width: 8.w,
          ),
          buttonColor: appColors.primary,
          onActionClicked: () {
            final request = ref
                .read(sendBookingDiscountApprovalRequestProvider)
                ?.copyWith(approvalStatus: "Approved", requestResponse: null);
            _sendApproval(request: request);
          },
        );
      },
    );
  }

  void _showRejectCPAAlert() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketAlertBottomSheet(
          title: "Reject Cancellation",
          buttonText: LocaleKeys.reject.tr(),
          description: "Booking Cancellation will be rejected.",
          buttonColor: appColors.error,
          onActionClicked: () {
            final lead = ref.read(bookingLeadRequestProvider);
            sendCPAApproval(
              leadId: lead?.id,
              request: const ChangeLeadStatusRequest(
                approvalStatus: "2",
                smBookingCancelled: "SM_BOOKING_CANCELLED",
              ),
            );
          },
        );
      },
    );
  }

  void _showRejectDiscountAlert() {
    ref
        .read(sendBookingDiscountApprovalRequestProvider.notifier)
        .update((state) => state = state?.copyWith(requestResponse: null));
    ref
        .read(bookingFormErrorsProvider.notifier)
        .remove(DiscountFormFields.rejectReason);
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return RejectDiscountWidget(
          onRejectClicked: () {
            final request = ref
                .read(sendBookingDiscountApprovalRequestProvider)
                ?.copyWith(approvalStatus: "Rejected");
            _sendApproval(request: request);
          },
        );
      },
    );
  }

  void _sendApproval({DiscountApprovalRequest? request}) {
    final lead = ref.read(bookingLeadRequestProvider);
    sendApproval(leadId: lead?.id, request: request);
  }

  void _closeFollowup() {
    final lead = ref.read(bookingLeadRequestProvider);
    final request = lead?.bookingCloseFollowupRequest();
    createLeadHistory(leadId: lead?.id, req: request);
  }

  void _createCallFollowup() {
    final lead = ref.read(bookingLeadRequestProvider);
    final followupDateTime = ref.read(bookingFollowupDateTimeProvider);
    createFollowup(
      leadId: lead?.id,
      request: LeadFollowupRequest(
        followUpPlan: FollowUpPlanType.bookingCall.value,
        followUpDateTime: followupDateTime,
      ),
    );
  }

  @override
  void onCPAApprovalSend(List<String>? data) {
    showSnackBar(
      data?.join(",") ?? "Approval Sent Successfully!",
      type: SnackBarType.success,
    );
    leadActionBackToPrevScreen(context);
  }

  @override
  void onApprovalSend(DiscountApproval? discountApproval) {
    if (discountApproval?.approvalStatus == 1) {
      final lead = ref.read(bookingLeadRequestProvider);
      final request = lead?.bookingFormChangeLeadStatusRequest();
      changeLeadStatus(leadId: lead?.id, request: request);
    } else {
      showSnackBar("This lead has been rejected!", type: SnackBarType.warning);
      leadActionBackToPrevScreen(context);
    }
  }

  @override
  void onLeadHistoryCreated() {
    final isScheduled = ref.read(scheduleCallFollowupProvider);
    if (isScheduled) {
      _createCallFollowup();
    } else {
      showSnackBar(LocaleKeys.bookingCreated.tr(), type: SnackBarType.success);
      leadActionBackToPrevScreen(context);
    }
  }

  @override
  void onFollowupCreated() {
    // BPR path: followup was created silently while approval screen is already open
    final hasApprovalRoute = context.router.stack.any(
      (page) => page.name == ApprovalRoute.name,
    );
    if (hasApprovalRoute) return;

    showSnackBar(LocaleKeys.bookingCreated.tr(), type: SnackBarType.success);
    leadActionBackToPrevScreen(context);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    _closeFollowup();
  }

  @override
  void onBookingCreated(Booking? booking) {
    _changeLeadStatus();
  }

  @override
  void onBookingUpdated(Booking? booking) {
    _changeLeadStatus();
  }

  @override
  void onLeadUpdated(Lead? lead) {
    _updateOrCreateBooking();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
