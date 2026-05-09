import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/booking_action_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/buying_car_color_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/customer_quote_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/details_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/first_time_buyer_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/interested_in_competition_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/purchase_mode_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/select_car_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/test_drive_given_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingBuyingDetails extends SalesdocketConsumerStatefulWidget {
  const BookingBuyingDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingBuyingDetailsState();
}

class _BookingBuyingDetailsState
    extends SalesdocketConsumerState<BookingBuyingDetails>
    with LeadEvents, ProductEvents {
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
          label: "Edit Buying Details",
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
        const SelectCarWidget(),
        verticalSpacing(2.h),
        const BuyingCarColorWidget(),
        verticalSpacing(2.h),
        const CustomerQuoteWidget(),
        verticalSpacing(2.h),
        const TestDriveGivenWidget(),
        verticalSpacing(2.h),
        const InterestedInCompetitionWidget(),
        verticalSpacing(2.h),
        const FirstTimeBuyerWidget(),
        verticalSpacing(2.h),
        const PurchaseModeWidget(),
        verticalSpacing(3.h),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [
      selectedCarProvider,
      selectedCarsProvider,
      editCarDetailsProvider,
      selectedCarColorProvider,
      prevSelectedTestDriveGivenProvider,
      selectedTestDriveGivenProvider,
      selectedInterestedInCompProvider,
      editExistingVehicleProvider,
      selectedFirstTimeBuyerProvider,
      selectedBookingProvider,
      selectedCustomerQuoteProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [bookingFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    if (!mounted) return;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(bookingLeadRequestProvider.notifier)
          .update(
            (state) =>
                lead?.copyWith(
                  purchaseMode: (lead.purchaseMode?.isNotEmpty == true ? lead.purchaseMode : lead.booking?.purchaseMode) ?? PurchaseMode.cash.value,
                ),
          );
      ref
          .read(canEditBookingProvider.notifier)
          .update((state) => LeadUtils.canEditBooking(lead));
      ref
          .read(selectedCarsProvider.notifier)
          .update((toUpdate) => lead?.sortedVariants ?? []);
      ref
          .read(selectedCarProvider.notifier)
          .update(
            (toUpdate) => lead?.primaryVariant ?? const InterestedVariant(),
          );
      ref
          .read(selectedCarColorProvider.notifier)
          .update(
            (toUpdate) =>
                lead?.interestedColor?.lastOrNull ?? const InterestedColor(),
          );
      ref
          .read(selectedInterestedInCompProvider.notifier)
          .update((toUpdate) => lead?.interestedInCompDetails);
      // Initialize First Time Buyer from lead data
      var firstTimeBuyer = lead?.oldVehicleDetails;
      // If Exchange is selected, automatically set First Time Buyer to "No"
      if (lead?.isExchange == 1 && firstTimeBuyer?.isExistingVehicle != 1) {
        firstTimeBuyer = (firstTimeBuyer ?? const FirstTimeBuyer()).copyWith(
          isExistingVehicle: 1,
        );
      }
      ref
          .read(selectedFirstTimeBuyerProvider.notifier)
          .update((toUpdate) => firstTimeBuyer);
      ref
          .read(selectedBookingProvider.notifier)
          .update((toUpdate) => lead?.booking ?? const Booking());
      // Initialize Customer Quote from booking data
      ref
          .read(selectedCustomerQuoteProvider.notifier)
          .update(
            (state) =>
                lead?.customerQuoteDetails ?? lead?.booking?.customerQuoteDetails,
          );
    });
  }

  void _fetchData() {
    final lead = ref.read(prevBookingLeadRequestProvider);
    fetchLead(leadId: lead?.id);
    if (lead?.workflow?.isBPR ?? false) {
      getDiscountApprovals(leadId: lead?.id);
    }
  }

  void _setupView() {
    if (!mounted) return;
    final lead = ref.read(bookingLeadRequestProvider);
    final newSelectedCars = ref.read(selectedCarsProvider);
    final newCarColor = ref.read(selectedCarColorProvider);
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
    final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final newBookingDetails = ref.read(selectedBookingProvider);
    final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
    final errors =
        lead?.bookingBuyingDetailsValidationErrors(
          newCarDetails: newSelectedCars,
          newCarColor: newCarColor,
          newTestDrive: newTestDrive,
          newFirstTimeBuyer: newFirstTimeBuyer,
          newInterestedInComp: newInterestedInComp,
          newBookingDetails: newBookingDetails,
          newCustomerQuote: newCustomerQuote,
        ) ??
        [];
    ref
        .read(isBookingFormInEditMode.notifier)
        .update((state) => errors.isNotEmpty);
  }

  void _setupEditMode() {
    if (!mounted) return;
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
        .update((state) => canEdit);
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    if (!mounted) return;
    final testDriveHistory = history.firstWhereOrNull(
      (toFilter) => toFilter.responseType == 'test_drive',
    );
    final lead = ref.read(bookingLeadRequestProvider);
    final testDriveGiven = testDriveHistory?.testDriveGiveDerails
        ?.defaultTestDriveGivenValues(lead);
    ref
        .read(selectedTestDriveGivenProvider.notifier)
        .update((state) => testDriveGiven);
    ref
        .read(prevSelectedTestDriveGivenProvider.notifier)
        .update((state) => testDriveGiven);
    _setupView();
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (!mounted) return;
    ref
        .read(prevBookingLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    _initProviders(lead);
    _setupEditMode();
    getCompetitionProducts();
    final interestedInComp = ref.read(selectedInterestedInCompProvider);
    getCompetitionModels(brandId: interestedInComp?.brand);
    getBrands();
    final firstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    getBrandModels(
      req: GetProductsRequest(brand: firstTimeBuyer?.oldVehicleId),
    );
    fetchLeadHistory(leadId: lead?.id);
  }

  @override
  void onBrandsFetched(List<Product> list) {
    ref.read(brandsProvider.notifier).update((state) => state = list);
  }

  @override
  void onBrandModelsFetched(List<Product> list) {
    ref.read(brandModelsProvider.notifier).update((state) => state = list);
  }

  @override
  void onCompetitionProductsFetched(List<CompetitionProduct> list) {
    ref
        .read(competitionProductsProvider.notifier)
        .update((state) => state = list);
  }

  @override
  void onCompetitionModelsFetched(List<CompetitionProduct> list) {
    ref
        .read(competitionModelsProvider.notifier)
        .update((state) => state = list);
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
