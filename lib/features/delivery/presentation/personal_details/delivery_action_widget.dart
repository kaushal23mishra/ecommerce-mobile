import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/booking_events.dart';
import 'package:salesdocket_mobile/common/events/delivery_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/locality_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
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
    with LocalityEvents, LeadEvents, DeliveryEvents, BookingEvents, NavigationEvents {
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
    final request = ref.read(deliveryLeadRequestProvider);
    final newLocality = ref.read(localityProvider);
    final newAddress = ref.read(addressProvider);
    if (_isValidForm(request)) {
      setLeadAddress(localityId: newLocality?.id, address: newAddress);
    }
  }

  bool _isValidForm(Lead? request) {
    final detailsSameAsPrevious = ref.read(detailsSameAsPreviousProvider);
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final newLocality = ref.read(localityProvider);
    final selectedDelivery = ref.read(selectedDeliveryProvider);
    final newAddress = ref.read(addressProvider);
    final detailsErrors =
        detailsSameAsPrevious
            ? <FormFieldError>[]
            : request?.deliveryPersonalDetailsValidationErrors(
                  newContactDetails: newContactDetails,
                  newLocality: newLocality,
                  newAddress: newAddress,
                  selectedDelivery: selectedDelivery,
                ) ??
                [];

    final errors = detailsErrors;

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(deliveryFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _updateOrCreateDelivery({CreateAddressResponse? addressData}) {
    final lead = ref.read(deliveryLeadRequestProvider);
    final panImages = ref.read(panImagesProvider);
    final newLocality = ref.read(localityProvider);
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];

    final selectedDelivery = ref.read(selectedDeliveryProvider);
    if (lead?.delivery?.id != null) {
      final request = selectedDelivery?.personalDetailsUpdateDeliveryRequest(
        lead: lead,
        panImages: panImages,
        newLocality: newLocality,
        addressData: addressData,
        newContactDetails: newContactDetails,
      );
      updateDelivery(deliveryId: lead?.delivery?.id, request: request);
    } else {
      final request = selectedDelivery?.personalDetailsCreateDeliveryRequest(
        lead: lead,
        panImages: panImages,
        newLocality: newLocality,
        addressData: addressData,
        newContactDetails: newContactDetails,
      );
      createDelivery(request: request);
    }
  }

  void _updateLead() {
    final detailsSameAsPrevious = ref.read(detailsSameAsPreviousProvider);
    if (detailsSameAsPrevious) {
      _moveToNextStep();
      return;
    }

    final lead = ref.read(deliveryLeadRequestProvider);
    if (lead == null) return;

    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final request = lead.deliveryPersonalDetailsRequest(
      newContactDetails: newContactDetails,
    );
    updateLead(leadId: lead.id, lead: request);
  }

  void _uploadImages(Delivery? delivery) {
    final selectedDelivery = ref.read(selectedDeliveryProvider);
    final documents = (selectedDelivery?.documents ?? [])
        .where((doc) =>
            doc.fileName != null &&
            !doc.fileName!.startsWith("http") &&
            !doc.fileName!.startsWith("https"))
        .toList();

    if (documents.isEmpty) return;

    uploadDeliveryDocuments(
      deliveryId: delivery?.id,
      request: selectedDelivery?.copyWith(documents: documents),
    );
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

  @override
  void onAddressCreated(CreateAddressResponse? data) {
    _updateOrCreateDelivery(addressData: data);
  }

  @override
  void onDeliveryCreated(Delivery? delivery) {
    _uploadImages(delivery);
    _updateLead();
  }

  @override
  void onDeliveryUpdated(Delivery? delivery) {
    if (delivery?.id != null) {
      _uploadImages(delivery);
    }
    _updateLead();
  }

  @override
  void onBookingUpdated(Booking? booking) {
    _updateLead();
  }

  @override
  void onDeliveryDocumentsUploaded(Delivery? delivery) {
    loggy.debug("Delivery Documents uploaded successfully!");
  }

  @override
  void onLeadUpdated(Lead? lead) {
    _moveToNextStep();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
