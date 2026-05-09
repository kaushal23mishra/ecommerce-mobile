import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingActionWidget extends SalesdocketConsumerStatefulWidget {
  const BookingActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingActionState();
}

class _BookingActionState extends SalesdocketConsumerState<BookingActionWidget>
    with LeadEvents, BookingEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditBookingProvider);
    if (!canEdit) {
      return SalesdocketActionWidget(
        onPositiveClicked: () {
          _isNextClicked = true;
          _moveToNextStep();
        },
        positiveText: LocaleKeys.lblNext.tr(),
      );
    }

    return SalesdocketActionWidget(
      onNegativeClicked: () {
        _validateFormAndSubmitRequest();
      },
      onPositiveClicked: () {
        _isNextClicked = true;
        _validateFormAndSubmitRequest();
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    final request = ref.read(bookingLeadRequestProvider);
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
        request?.bookingBuyingDetailsValidationErrors(
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
      ref.read(bookingFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _moveToNextStep() {
    if (_isNextClicked) {
      final firstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
      final step =
          (firstTimeBuyer?.isExistingVehicle == FirstTimeBuyerState.yes.value)
              ? 3
              : 2;
      ref.invalidate(bookingLeadRequestProvider);
      ref
          .read(selectedBookingStepProvider.notifier)
          .update((state) => state = step);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  @override
  void onLeadHistoryCreated() {
    final lead = ref.read(bookingLeadRequestProvider);
    if (lead == null) return;

    final newSelectedCars = ref.read(selectedCarsProvider);
    final newCarColor = ref.read(selectedCarColorProvider);
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
    final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final request = lead.bookingBuyingDetailsRequest(
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
    final newBookingDetails = ref.read(selectedBookingProvider);
    final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
    ref
        .read(bookingLeadRequestProvider.notifier)
        .update((state) => state = lead);
    if (newBookingDetails?.id != null) {
      final request = newBookingDetails?.buyingUpdateBookingRequest(
        lead: lead,
        newCustomerQuote: newCustomerQuote,
      );
      updateBooking(bookingId: newBookingDetails?.id, request: request);
    } else {
      final request = newBookingDetails?.buyingCreateBookingRequest(
        lead: lead,
        newCustomerQuote: newCustomerQuote,
      );
      createBooking(request: request);
    }
  }

  @override
  void onBookingCreated(Booking? booking) async {
    await uploadBookingImages(booking: booking, selectedBooking: ref.read(selectedBookingProvider));
    _moveToNextStep();
  }

  @override
  void onBookingUpdated(Booking? booking) async {
    await uploadBookingImages(booking: booking, selectedBooking: ref.read(selectedBookingProvider));
    _moveToNextStep();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    if (!mounted) return;
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
