import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/locality_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/services/snackbar_service.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/booking_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingActionWidget extends SalesdocketConsumerStatefulWidget {
  const BookingActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingActionState();
}

class _BookingActionState extends SalesdocketConsumerState<BookingActionWidget>
    with LocalityEvents, LeadEvents, BookingEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditBookingProvider);
    final lead = ref.watch(bookingLeadRequestProvider);
    final workflow = lead?.workflow;
    
    // If not editable, show only Next button
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
    final newLocality = ref.read(localityProvider);
    final newAddress = ref.read(addressProvider);
    if (_isValidForm(request)) {
      setLeadAddress(localityId: newLocality?.id, address: newAddress);
    }
  }

  bool _isValidForm(Lead? request) {
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final newLocality = ref.read(localityProvider);
    final selectedBooking = ref.read(selectedBookingProvider);
    final newAddress = ref.read(addressProvider);
    final errors =
        request?.bookingPersonalDetailsValidationErrors(
          newContactDetails: newContactDetails,
          newLocality: newLocality,
          selectedBooking: selectedBooking,
          newAddress: newAddress,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(bookingFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _updateOrCreateBooking({CreateAddressResponse? addressData}) {
    final lead = ref.read(bookingLeadRequestProvider);
    final panImages = ref.read(panImagesProvider);
    final newLocality = ref.read(localityProvider);
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];

    final selectedBooking = ref.read(selectedBookingProvider);
    if (lead?.booking?.id != null) {
      final request = selectedBooking?.personalDetailsUpdateBookingRequest(
        lead: lead,
        panImages: panImages,
        newLocality: newLocality,
        addressData: addressData,
        newContactDetails: newContactDetails,
      );
      updateBooking(bookingId: lead?.booking?.id, request: request);
    } else {
      final request = selectedBooking?.personalDetailsCreateBookingRequest(
        lead: lead,
        panImages: panImages,
        newLocality: newLocality,
        addressData: addressData,
        newContactDetails: newContactDetails,
      );
      createBooking(request: request);
    }
  }

  void _updateLead() {
    final lead = ref.read(bookingLeadRequestProvider);
    if (lead == null) return;

    final newContactDetails = ref.read(contactDetailsProvider) ?? [];

    final request = lead.bookingPersonalDetailsRequest(
      newContactDetails: newContactDetails,
    );
    
    updateLead(leadId: lead.id, lead: request);
  }

  void _uploadImages(Booking? booking) {
    final selectedBooking = ref.read(selectedBookingProvider);
    final documents = (selectedBooking?.documents ?? [])
        .where((doc) =>
            doc.fileName != null &&
            !doc.fileName!.startsWith("http") &&
            !doc.fileName!.startsWith("https"))
        .toList();

    if (documents.isEmpty) return;

    uploadBookingDocuments(
      bookingId: booking?.id,
      request: selectedBooking?.copyWith(documents: documents),
    );
  }

  void _moveToNextStep() {
    if (_isNextClicked) {
      ref.invalidate(bookingLeadRequestProvider);
      ref
          .read(selectedBookingStepProvider.notifier)
          .update((state) => state = state + 1);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  @override
  void onAddressCreated(CreateAddressResponse? data) {
    _updateOrCreateBooking(addressData: data);
  }

  @override
  void onBookingCreated(Booking? booking) {
    _uploadImages(booking);
    _updateLead();
  }

  @override
  void onBookingUpdated(Booking? booking) {
    if (booking?.id != null) {
      _uploadImages(booking);
    }
    _updateLead();
  }

  @override
  void onLeadUpdated(Lead? lead) {
    _moveToNextStep();
  }

  @override
  void onBookingDocumentsUploaded(Booking? booking) {
    loggy.debug("Booking Documents uploaded successfully!");
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    showGlobalSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
