import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_mobile/features/booking/presentation/personal_details/personal_details.dart';

class BookingPersonalDetails extends SalesdocketConsumerStatefulWidget {
  const BookingPersonalDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingPersonalDetailsState();
}

class _BookingPersonalDetailsState
    extends SalesdocketConsumerState<BookingPersonalDetails>
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
    final canEdit = ref.watch(canEditBookingProvider);
    final lead = ref.watch(bookingLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final isInEditMode = ref.watch(isBookingFormInEditMode);

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
                .read(isBookingFormInEditMode.notifier)
                .update((state) => state = value);
          },
          form: _formWidget,
        ),
      ],
      actionWidget: const BookingActionWidget(),
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

        const PanWidget(),
        verticalSpacing(2.h),

        verticalSpacing(3.h),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [
      selectedContactIndexProvider,
      selectedBookingProvider,
      contactDetailsProvider,
      localityProvider,
      addressProvider,
      citiesProvider,
      locationsProvider,
      panImagesProvider,

    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [
      contactDetailsTextFieldControllerProvider,
      bookingFormErrorsProvider,
    ];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    ref
        .read(bookingLeadRequestProvider.notifier)
        .update((state) => state = lead?.copyWith());
    ref
        .read(canEditBookingProvider.notifier)
        .update((state) => state = LeadUtils.canEditBooking(lead));

    final booking = lead?.booking ?? const Booking();
    ref
        .read(selectedBookingProvider.notifier)
        .update((state) => state = booking.initBooking(lead));
    ref
        .read(contactDetailsProvider.notifier)
        .update((state) => state = booking.contactDetails(lead));
    ref
        .read(localityProvider.notifier)
        .update(
          (state) =>
              state =
                  booking.locality ?? lead?.locality ?? const LeadLocality(),
        );
    ref
        .read(addressProvider.notifier)
        .update(
          (state) =>
              state = booking.address ?? lead?.address ?? const LeadAddress(),
        );
    ref
        .read(panImagesProvider.notifier)
        .update((state) => state = booking.panImagesDetails);

  }

  void _fetchData() {
    final lead = ref.read(prevBookingLeadRequestProvider);
    fetchLead(leadId: lead?.id);
    if (lead?.workflow?.isBPR ?? false) {
      getDiscountApprovals(leadId: lead?.id);
    }
  }

  void _setupView() {
    final lead = ref.read(bookingLeadRequestProvider);
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final newLocality = ref.read(localityProvider);
    final selectedBooking = ref.read(selectedBookingProvider);
    final newAddress = ref.read(addressProvider);
    final errors =
        lead?.bookingPersonalDetailsValidationErrors(
          newContactDetails: newContactDetails,
          newLocality: newLocality,
          selectedBooking: selectedBooking,
          newAddress: newAddress,
        ) ??
        [];
    ref
        .read(isBookingFormInEditMode.notifier)
        .update((state) => state = errors.isNotEmpty);
  }

  void _setupEditMode() {
    final lead = ref.read(bookingLeadRequestProvider);
    final approval = ref.read(bookingDiscountApprovalsProvider);
    final workflow = lead?.workflow;

    var canEdit = false;
    if (workflow?.isBPR ?? false) {
      canEdit = approval?.approvalStatus == 2;
    } else {
      canEdit = LeadUtils.canEditBooking(lead);
    }
    ref
        .read(canEditBookingProvider.notifier)
        .update((state) => state = canEdit);
  }

  @override
  void onLeadFetched(Lead? lead) {
    ref
        .read(prevBookingLeadRequestProvider.notifier)
        .update((state) => state = lead ?? state);
    _initProviders(lead);
    _setupEditMode();
    _setupView();
  }

  @override
  void onDiscountApprovalFetched(DiscountApproval? approval) {
    ref
        .read(bookingDiscountApprovalsProvider.notifier)
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
