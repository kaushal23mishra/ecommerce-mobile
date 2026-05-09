import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/buying_car_color_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/customer_quote_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/details_card_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/first_time_buyer_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/interested_in_competition_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/prospect_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/purchase_mode_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/select_car_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/select_lead_source_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/test_drive_given_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectSheetBuyingDetails extends SalesdocketConsumerStatefulWidget {
  const ProspectSheetBuyingDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProspectSheetBuyingDetailsState();
}

class _ProspectSheetBuyingDetailsState
    extends SalesdocketConsumerState<ProspectSheetBuyingDetails>
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
    final lead = ref.watch(prospectLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final isInEditMode = ref.watch(isProspectFormInEditMode);
    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DetailsCardWidget(),
        verticalSpacing(2.h),
        if (canEdit)
          SalesdocketEditFormSwitch(
            label: "Edit Buying Details",
            isInEditMode: isInEditMode,
            onChanged: (value) {
              ref
                  .read(isProspectFormInEditMode.notifier)
                  .update((state) => state = value);
            },
            form: _formWidget,
          ),
      ],
      actionWidget: const ProspectActionWidget(),
    );
  }

  Widget get _formWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SelectCarWidget(),
        verticalSpacing(2.h),
        const BuyingCarColorWidget(),
        verticalSpacing(2.h),
        const CustomerQuoteWidget(),
        verticalSpacing(2.h),
        const SelectLeadSourceWidget(),
        verticalSpacing(2.h),
        const TestDriveGivenWidget(),
        verticalSpacing(2.h),
        const PurchaseModeWidget(),
        verticalSpacing(2.h),
        const InterestedInCompetitionWidget(),
        verticalSpacing(2.h),
        const FirstTimeBuyerWidget(),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [
      selectedCarProvider,
      selectedCarsProvider,
      editCarDetailsProvider,
      selectedCarColorProvider,
      selectedLeadSourceProvider,
      selectedTestDriveGivenProvider,
      selectedInterestedInCompProvider,
      editExistingVehicleProvider,
      selectedFirstTimeBuyerProvider,
      selectedCustomerQuoteProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [prospectFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    if (!mounted) return;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(prospectLeadRequestProvider.notifier)
          .update(
            (state) =>
                lead?.copyWith(
                  purchaseMode: (lead.purchaseMode?.isNotEmpty == true ? lead.purchaseMode : lead.booking?.purchaseMode) ?? PurchaseMode.cash.value,
                ),
          );
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
          .read(selectedLeadSourceProvider.notifier)
          .update((toUpdate) => lead?.leadSourceDetails);
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
      // Initialize Customer Quote from lead data
      ref
          .read(selectedCustomerQuoteProvider.notifier)
          .update((state) => lead?.customerQuoteDetails);
    });
  }

  void _fetchData() {
    final lead = ref.read(prevProspectLeadRequestProvider);
    fetchLead(leadId: lead?.id);
  }

  void _setupView() {
    if (!mounted) return;
    final lead = ref.read(prospectLeadRequestProvider);
    final newSelectedCars = ref.read(selectedCarsProvider);
    final newCarColor = ref.read(selectedCarColorProvider);
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
    final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
    final errors =
        lead?.prospectBuyingDetailsValidationErrors(
          newCarDetails: newSelectedCars,
          newCarColor: newCarColor,
          newTestDrive: newTestDrive,
          newFirstTimeBuyer: newFirstTimeBuyer,
          newInterestedInComp: newInterestedInComp,
          newCustomerQuote: newCustomerQuote,
        ) ??
        [];
    ref
        .read(isProspectFormInEditMode.notifier)
        .update((state) => errors.isNotEmpty);
  }

  @override
  void onBrandsFetched(List<Product> list) {
    if (!mounted) return;
    ref.read(brandsProvider.notifier).update((state) => list);
  }

  @override
  void onBrandModelsFetched(List<Product> list) {
    if (!mounted) return;
    ref.read(brandModelsProvider.notifier).update((state) => list);
  }

  @override
  void onCompetitionProductsFetched(List<CompetitionProduct> list) {
    if (!mounted) return;
    ref
        .read(competitionProductsProvider.notifier)
        .update((state) => list);
  }

  @override
  void onCompetitionModelsFetched(List<CompetitionProduct> list) {
    if (!mounted) return;
    ref
        .read(competitionModelsProvider.notifier)
        .update((state) => list);
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    if (!mounted) return;
    final testDriveHistory = history.firstWhereOrNull(
      (toFilter) => toFilter.responseType == 'test_drive',
    );
    final lead = ref.read(prospectLeadRequestProvider);
    final testDriveGiven = testDriveHistory?.testDriveGiveDerails
        ?.defaultTestDriveGivenValues(lead);
    ref
        .read(selectedTestDriveGivenProvider.notifier)
        .update((state) => testDriveGiven);
    _setupView();
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (!mounted) return;
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    _initProviders(lead);
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
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
