import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/delivery_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryActionWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveryActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeliveryActionState();
}

class _DeliveryActionState
    extends SalesdocketConsumerState<DeliveryActionWidget>
    with LeadEvents, BookingEvents, DeliveryEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditDeliveryProvider);
    if (!canEdit) {
      return SalesdocketActionWidget(
        positiveText: LocaleKeys.lblNext.tr(),
        onPositiveClicked: () {
          _isNextClicked = true;
          _moveToNextStep();
        },
      );
    }

    return SalesdocketActionWidget(
      negativeText: LocaleKeys.btnSave.tr(),
      onNegativeClicked: () {
        if (canEdit) {
          _validateFormAndSubmitRequest();
        } else {
          leadActionBackToPrevScreen(context);
        }
      },
      positiveText: LocaleKeys.lblNext.tr(),
      onPositiveClicked: () {
        _isNextClicked = true;
        if (canEdit) {
          _validateFormAndSubmitRequest();
        } else {
          _moveToNextStep();
        }
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    final request = ref.read(deliveryLeadRequestProvider);
    if (_isValidForm(request)) {
      final newTestDrive = ref.read(selectedTestDriveGivenProvider);
      createLeadHistory(
        leadId: request?.id,
        req: RequestUtils.createLeadHistoryRequest(newTestDrive: newTestDrive),
      );
    }
  }

  bool _isValidForm(Lead? request) {
    final newSelectedCars = ref.read(selectedCarsProvider);

    // Check if more than one variant is selected
    if (newSelectedCars.length > 1) {
      showSnackBar(LocaleKeys.lblYouCanProceedWithOneEnquiryAtATime.tr());
      return false;
    }

    final newCarColor = ref.read(selectedCarColorProvider);
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
    final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final newBookingDetails = ref.read(selectedBookingProvider);
    final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
    final errors =
        request?.deliveryBuyingDetailsValidationErrors(
          newCarDetails: newSelectedCars,
          newCarColor: newCarColor,
          newTestDrive: newTestDrive,
          newFirstTimeBuyer: newFirstTimeBuyer,
          newInterestedInComp: newInterestedInComp,
          newBookingDetails: newBookingDetails,
          newCustomerQuote: newCustomerQuote,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(deliveryFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _moveToNextStep() {
    if (_isNextClicked) {
      final firstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
      final step = (firstTimeBuyer?.isExistingVehicle == FirstTimeBuyerState.yes.value) ? 3 : 2;
      ref.invalidate(deliveryLeadRequestProvider);
      ref
          .read(selectedDeliveryStepProvider.notifier)
          .update((state) => state = step);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _updateBooking() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final newBookingDetails = ref.read(selectedBookingProvider);
    if (newBookingDetails?.id != null) {
      final request = newBookingDetails?.buyingUpdateBookingRequest(lead: lead);
      updateBooking(bookingId: newBookingDetails?.id, request: request);
    } else {
      final request = newBookingDetails?.buyingCreateBookingRequest(lead: lead);
      createBooking(request: request);
    }
  }

  void _updateDelivery() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
    if (lead?.delivery?.id != null) {
      final request = lead?.deliveryBuyingUpdateDeliveryRequest(
        newCustomerQuote: newCustomerQuote,
      );
      updateDelivery(deliveryId: lead?.delivery?.id, request: request);
    } else {
      final request = lead?.deliveryBuyingCreateDeliveryRequest(
        newCustomerQuote: newCustomerQuote,
      );
      createDelivery(request: request);
    }
  }

  @override
  void onLeadHistoryCreated() {
    final lead = ref.read(deliveryLeadRequestProvider);
    if (lead == null) return;

    final newSelectedCars = ref.read(selectedCarsProvider);
    final newCarColor = ref.read(selectedCarColorProvider);
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
    final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final request = lead.deliveryBuyingDetailsRequest(
      newSelectedCars: newSelectedCars,
      newCarColor: newCarColor,
      newTestDrive: newTestDrive,
      newInterestedInComp: newInterestedInComp,
      newFirstTimeBuyer: newFirstTimeBuyer,
    );
    updateLead(leadId: lead.id, lead: request);
  }

  @override
  void onLeadUpdated(Lead? lead) {
    final prevLead = ref.read(deliveryLeadRequestProvider);
    ref
        .read(deliveryLeadRequestProvider.notifier)
        .update(
          (state) => state = lead?.copyWith(delivery: prevLead?.delivery),
        );
    _updateBooking();
  }

  @override
  void onBookingCreated(Booking? booking) async {
    await uploadBookingImages(booking: booking, selectedBooking: ref.read(selectedBookingProvider));
    _updateDelivery();
  }

  @override
  void onBookingUpdated(Booking? booking) async {
    await uploadBookingImages(booking: booking, selectedBooking: ref.read(selectedBookingProvider));
    _updateDelivery();
  }

  @override
  void onDeliveryCreated(Delivery? delivery) {
    _moveToNextStep();
  }

  @override
  void onDeliveryUpdated(Delivery? delivery) {
    _moveToNextStep();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
