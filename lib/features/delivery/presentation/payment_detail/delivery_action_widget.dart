import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';

import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/old_car_payment.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/delivery_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryActionWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveryActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeliveryActionState();
}

class _DeliveryActionState
    extends SalesdocketConsumerState<DeliveryActionWidget>
    with BookingEvents, ReceiptEvents, DeliveryEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditDeliveryProvider);
    final lead = ref.watch(deliveryLeadRequestProvider);
    final workflow = lead?.workflow;
    
    // If not editable, show only Next button
    if (!canEdit) {
      return SalesdocketActionWidget(
        positiveText: LocaleKeys.lblNext.tr(),
        onPositiveClicked: () {
          _isNextClicked = true;
          // Always validate calculated values (like pending amount) even if strict edit is off
          if (_isValidForm()) {
            _moveToNextStep();
          }
        },
      );
    }

    return SalesdocketActionWidget(
      negativeText: LocaleKeys.btnSave.tr(),
      onNegativeClicked: () {
        _validateFormAndSubmitRequest();
      },
      positiveText: LocaleKeys.lblNext.tr(),
      onPositiveClicked: () {
        _isNextClicked = true;
        if (canEdit) {
          _validateFormAndSubmitRequest();
        } else {
          // Always validate calculated values (like pending amount) even if strict edit is off
          if (_isValidForm()) {
            _moveToNextStep();
          }
        }
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    if (_isValidForm()) {
      _updateOrCreateBooking();
    }
  }

  void _updateOrCreateBooking() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final booking = ref.read(selectedBookingProvider);
    if (booking?.id != null) {
      final request = booking?.paymentUpdateBookingRequest(lead: lead);
      updateBooking(bookingId: booking?.id, request: request);
    } else {
      final request = booking?.paymentCreateBookingRequest(lead: lead);
      createBooking(request: request);
    }
  }

  bool _isValidForm() {
    final request = ref.read(deliveryLeadRequestProvider);
    final booking = ref.read(selectedBookingProvider);
    final creditGiven = ref.read(creditGivenProvider);
    final exchangeProduct = ref.read(selectedExchangeProductProvider);
    final pendingAmount =
        ref
            .read(deliveryViewModelProvider.notifier)
            .calculatePendingAmountForCreditGiven();

    final errors =
        request?.deliveryPaymentDetailsValidationErrors(
          newBooking: booking,
          creditGiven: creditGiven,
          oldCarPayment: ref.read(oldCarPaymentProvider),
          pendingAmount: pendingAmount,
          exchangeProduct: exchangeProduct,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(deliveryFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _sendOrUpdateReason({String? reasonType}) {
    final lead = ref.read(deliveryLeadRequestProvider);
    final receiptReason = ref
        .read(deliveryReceiptReasonsProvider)
        .lastWhereOrNull((reason) => reason.reason == reasonType);
    final creditGiven = ref.read(creditGivenProvider);

    if (receiptReason?.id != null) {
      final request = creditGiven?.updateReceiptReasonRequest(lead: lead);
      updateReceiptReason(receiptReasonId: receiptReason?.id, request: request);
    } else {
      final request = creditGiven?.sendReceiptReasonRequest(lead: lead);
      sendReceiptReason(request: request);
    }
  }



  void _moveToNextStep() {
    if (_isNextClicked) {
      ref.invalidate(deliveryLeadRequestProvider);
      ref
          .read(selectedDeliveryStepProvider.notifier)
          .update((state) => state = state + 1);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _sendOrUpdateOldCarPayment() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final reasonType = ReceiptReasonType.oldCarPaymentPendingFromAgent.value;
    final receiptReason = ref
        .read(deliveryReceiptReasonsProvider)
        .lastWhereOrNull((reason) => reason.reason == reasonType);
    final oldCarPayment = ref.read(oldCarPaymentProvider);

    if (oldCarPayment?.isGiven ?? false) {
      if (receiptReason?.id != null) {
        final request = oldCarPayment?.updateOldCarPaymentRequest(lead: lead);
        updateReceiptReason(
          receiptReasonId: receiptReason?.id,
          request: request,
        );
      } else {
        final request = oldCarPayment?.sendOldCarPaymentRequest(lead: lead);
        sendReceiptReason(request: request);
      }
    }
  }

  @override
  void onBookingCreated(Booking? booking) {
    _sendOrUpdateReason(
      reasonType: ReceiptReasonType.creditGivenToCustomer.value,
    );
    _sendOrUpdateOldCarPayment();
  }

  @override
  void onBookingUpdated(Booking? booking) {
    _sendOrUpdateReason(
      reasonType: ReceiptReasonType.creditGivenToCustomer.value,
    );
    _sendOrUpdateOldCarPayment();
  }

  @override
  void onReceiptReasonSend() {

    _moveToNextStep();
  }

  @override
  void onReceiptReasonUpdated() {

    _moveToNextStep();
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }
}
