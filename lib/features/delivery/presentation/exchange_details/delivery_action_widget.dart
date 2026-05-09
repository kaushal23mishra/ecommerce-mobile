import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/booking_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryActionWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveryActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeliveryActionState();
}

class _DeliveryActionState
    extends SalesdocketConsumerState<DeliveryActionWidget>
    with LeadEvents, ProductEvents, BookingEvents, NavigationEvents {
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
    if (_isValidForm()) {
      final lead = ref.read(deliveryLeadRequestProvider);
      if (lead?.isExchange == InterestedInExchangeState.no.value) {
        _updateLead();
        return;
      }

      _updateOrCreateBooking();
    }
  }

  void _updateOrCreateBooking() {
    final lead = ref.read(deliveryLeadRequestProvider);
    if (lead == null) return;

    final newExchangeHouseDetails = ref.read(selectedExchangeHouseProvider);
    final booking = lead.booking;
    if (booking?.id != null) {
      final request = lead.exchangeUpdateBookingRequest(
        newExchangeHouseDetails: newExchangeHouseDetails,
      );
      updateBooking(bookingId: booking?.id, request: request);
    } else {
      final request = lead.exchangeCreateBookingRequest(
        newExchangeHouseDetails: newExchangeHouseDetails,
      );
      createBooking(request: request);
    }
  }

  bool _isValidForm() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final newFirstTimeBuyer = ref.read(selectedExchangeCarProvider);
    final newExchangeProduct = ref.read(selectedExchangeProductProvider);
    final newExchangeHouseDetails = ref.read(selectedExchangeHouseProvider);
    final user = ref.read(profileProvider);
    final errors =
        lead?.deliveryExchangeDetailsValidationErrors(
          newExchangeProduct: newExchangeProduct,
          newFirstTimeBuyer: newFirstTimeBuyer,
          newExchangeHouseDetails: newExchangeHouseDetails,
          user: user,
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
      ref.invalidate(deliveryLeadRequestProvider);
      ref
          .read(selectedDeliveryStepProvider.notifier)
          .update((state) => state = state + 1);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _sendExchangeData() {
    final lead = ref.read(deliveryLeadRequestProvider);
    if (lead?.isExchange == InterestedInExchangeState.no.value) {
      _moveToNextStep();
      return;
    }

    final newFirstTimeBuyer = ref.read(selectedExchangeCarProvider);
    final newExchangeProduct = ref.read(selectedExchangeProductProvider);
    final newExchangeHouseDetails = ref.read(selectedExchangeHouseProvider);
    if (newExchangeProduct?.id != null) {
      final request = newExchangeProduct?.deliveryUpdateExchangeDetailsRequest(
        lead: lead,
        newFirstTimeBuyer: newFirstTimeBuyer,
        newExchangeHouseDetails: newExchangeHouseDetails,
      );
      updateExchangeProduct(request: request);
    } else {
      final request = newExchangeProduct?.deliveryCreateExchangeDetailsRequest(
        lead: lead,
        newFirstTimeBuyer: newFirstTimeBuyer,
        newExchangeHouseDetails: newExchangeHouseDetails,
      );
      createExchangeProduct(request: request);
    }
  }

  void _updateLead() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final request = lead?.deliveryExchangeDetailsRequest();
    updateLead(leadId: lead?.id, lead: request);
  }

  void _uploadImages(ExchangeProduct? exchangeProduct) {
    final exchangeImages = ref.read(exchangeImagesProvider);
    final images = BookingUtils.getExchangeImages(exchangeImages);
    loggy.debug(images);
    if (images.isEmpty) return;

    uploadExchangeDocuments(
      exchangeId: exchangeProduct?.id,
      request: ExchangeProduct(
        leadId: exchangeProduct?.leadId,
        documents: images,
      ),
    );
  }

  @override
  void onBookingCreated(Booking? booking) {
    _sendExchangeData();
  }

  @override
  void onBookingUpdated(Booking? booking) {
    _sendExchangeData();
  }

  @override
  void onLeadUpdated(Lead? lead) {
    _moveToNextStep();
  }

  @override
  void onExchangeUpdated(ExchangeProduct? exchangeProduct) {
    _updateLead();
    _uploadImages(exchangeProduct);
  }

  @override
  void onExchangeCreated(ExchangeProduct? exchangeProduct) {
    _updateLead();
    _uploadImages(exchangeProduct);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
