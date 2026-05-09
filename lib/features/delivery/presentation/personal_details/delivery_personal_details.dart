import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/delivery_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/address_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/contact_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/date_of_birth_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/delivery_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/details_widget.dart';

import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/name_widget.dart';

import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/pan_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/profession_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/type_of_customers_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryPersonalDetails extends SalesdocketConsumerStatefulWidget {
  const DeliveryPersonalDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryPersonalDetailsState();
}

class _DeliveryPersonalDetailsState
    extends SalesdocketConsumerState<DeliveryPersonalDetails>
    with LeadEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditDeliveryProvider);
    final lead = ref.watch(deliveryLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final isInEditMode = ref.watch(isDeliveryFormInEditMode);

    return SalesdocketForm(
      ignoring: !canEdit,
      formWidget: [
        verticalSpacing(2.h),
        const DetailsWidget(),
        verticalSpacing(1.25.h),
        SalesdocketEditFormSwitch(
          label: "Edit Personal Details",
          isInEditMode: isInEditMode,
          onChanged: (value) {
            ref
                .read(isDeliveryFormInEditMode.notifier)
                .update((state) => state = value);
            ref
                .read(detailsSameAsPreviousProvider.notifier)
                .update((state) => state = !value);
          },
          form: _formWidget,
        ),
      ],
      actionWidget: const DeliveryActionWidget(),
    );
  }

  Widget get _formWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(2.h),
        const NameWidget(),
        verticalSpacing(2.h),
        const ContactDetailsWidget(),
        verticalSpacing(2.h),
        const AddressWidget(),
        verticalSpacing(2.h),
        const TypeOfCustomersWidget(),
        verticalSpacing(2.h),
        const ProfessionWidget(),
        verticalSpacing(2.h),
        const DateOfBirthWidget(),
        verticalSpacing(2.h),

        verticalSpacing(2.h),
        verticalSpacing(1.25.h),
        const PanWidget(),
        verticalSpacing(2.h),

        verticalSpacing(3.h),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [
      selectedContactIndexProvider,
      selectedDeliveryProvider,
      contactDetailsProvider,
      detailsSameAsPreviousProvider,
      localityProvider,
      addressProvider,
      citiesProvider,
      locationsProvider,
      panImagesProvider,

      showMoreDeliveryDocumentsProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [
      contactDetailsTextFieldControllerProvider,
      deliveryFormErrorsProvider,
    ];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    ref
        .read(deliveryLeadRequestProvider.notifier)
        .update((state) => state = lead?.copyWith());
    final delivery = (lead?.delivery ?? const Delivery()).initDelivery(lead);
    ref
        .read(selectedDeliveryProvider.notifier)
        .update((state) => state = delivery);

    // Initialize contact details with email always visible
    var contactDetails = delivery.contactDetails(lead);

    // Separate phone numbers and emails
    final phoneNumbers =
        contactDetails
            .where((contact) => contact.type != ContactType.email.value)
            .toList();

    final emails =
        contactDetails
            .where((contact) => contact.type == ContactType.email.value)
            .toList();

    // Get existing email or create empty email field
    final emailId =
        delivery.emails?.firstOrNull?.emailId ??
        lead?.emails?.firstOrNull?.emailId;

    final emailField =
        emails.isNotEmpty
            ? emails.first
            : ContactDetails(type: ContactType.email.value, value: emailId);

    // Rebuild contact details with guaranteed structure:
    // [mobile, email, ...other phones/emails]
    contactDetails = [
      if (phoneNumbers.isNotEmpty) phoneNumbers.first, // Primary mobile
      emailField, // Email always at index 1
      ...phoneNumbers.skip(1), // Additional phone numbers
      ...emails.skip(1), // Additional emails (if any)
    ];

    ref
        .read(contactDetailsProvider.notifier)
        .update((state) => state = contactDetails);
    ref
        .read(localityProvider.notifier)
        .update(
          (state) =>
              state =
                  delivery.locality ?? lead?.locality ?? const LeadLocality(),
        );
    ref
        .read(addressProvider.notifier)
        .update(
          (state) =>
              state =
                  delivery.address ??
                  lead?.booking?.address ??
                  lead?.address ??
                  const LeadAddress(),
        );
    ref
        .read(panImagesProvider.notifier)
        .update((state) => state = delivery.panImagesDetails);

    ref
        .read(detailsSameAsPreviousProvider.notifier)
        .update(
          (state) => state = (delivery.addressId ?? lead?.addressId) != null,
        );


  }

  void _fetchData() {
    final lead = ref.read(prevDeliveryLeadRequestProvider);
    fetchLead(leadId: lead?.id);
    if (lead?.workflow?.isDPR ?? false) {
      getDeliveryApprovals(deliveryId: lead?.delivery?.id);
    }
  }

  void _setupView() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final newLocality = ref.read(localityProvider);
    final selectedDelivery = ref.read(selectedDeliveryProvider);
    final newAddress = ref.read(addressProvider);
    final errors =
        lead?.deliveryPersonalDetailsValidationErrors(
          newContactDetails: newContactDetails,
          newLocality: newLocality,
          newAddress: newAddress,
          selectedDelivery: selectedDelivery,
        ) ??
        [];
    final hasErrors = errors.isNotEmpty;
    ref
        .read(isDeliveryFormInEditMode.notifier)
        .update((state) => state = hasErrors);
    if (hasErrors) {
      ref
          .read(detailsSameAsPreviousProvider.notifier)
          .update((state) => state = false);
    }
  }

  void _setupEditMode() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final approval = ref.read(deliveryDiscountApprovalsProvider);
    final workflow = lead?.workflow;

    var canEdit = false;
    if (workflow?.isDPR ?? false) {
      canEdit = approval?.approvalStatus == 2;
    } else {
      canEdit = LeadUtils.canEditDelivery(lead);
    }
    ref
        .read(canEditDeliveryProvider.notifier)
        .update((state) => state = canEdit);
  }

  @override
  void onLeadFetched(Lead? lead) {
    ref
        .read(prevDeliveryLeadRequestProvider.notifier)
        .update((state) => state = lead ?? state);
    _initProviders(lead);
    _setupEditMode();
    _setupView();
  }

  @override
  void onDeliveryApprovalFetched(DiscountApproval? approval) {
    ref
        .read(deliveryDiscountApprovalsProvider.notifier)
        .update((state) => state = approval);
    _setupEditMode();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
