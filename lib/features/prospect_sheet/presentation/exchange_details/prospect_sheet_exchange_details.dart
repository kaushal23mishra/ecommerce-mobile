import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/product_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/exchange_details/details_card_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/exchange_details/edit_exchange_details_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/exchange_details/exchange_details_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/exchange_details/interested_in_exchange_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/exchange_details/prospect_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectSheetExchangeDetails extends SalesdocketConsumerStatefulWidget {
  const ProspectSheetExchangeDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProspectSheetExchangeDetailsState();
}

class _ProspectSheetExchangeDetailsState
    extends SalesdocketConsumerState<ProspectSheetExchangeDetails>
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
    final lead = ref.watch(prospectLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final isInEditMode = ref.watch(isProspectFormInEditMode);
    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DetailsCardWidget(),
        if (canEdit) ...[
          verticalSpacing(2.h),
          const ExchangeDetailsWidget(),
          verticalSpacing(1.h),
          if (isInEditMode) const InterestedInExchangeWidget(),
          verticalSpacing(2.h),
          SalesdocketEditFormSwitch(
            label: "Edit Exchange Details",
            isInEditMode: isInEditMode,
            onChanged: (value) {
              ref
                  .read(isProspectFormInEditMode.notifier)
                  .update((state) => state = value);
            },
            form: const EditExchangeDetailsWidget(),
          ),
        ],
      ],
      actionWidget: const ProspectActionWidget(),
    );
  }

  void _invalidateProviders() {
    final providers = [
      editExchangeVehicleDetailsProvider,
      selectedExchangeCarProvider,
      selectedExchangeProductProvider,
      editTyreReplacementProvider,
      addExchangeVehicleImagesProvider,
      addMoreExchangeVehicleImagesProvider,
      exchangeImagesProvider,
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
          .update((state) => lead?.copyWith());
      ref
          .read(selectedExchangeCarProvider.notifier)
          .update((toUpdate) => lead?.exchangeCarDetails);
      ref
          .read(selectedExchangeProductProvider.notifier)
          .update(
            (toUpdate) =>
                lead?.exchangeProducts?.firstOrNull ??
                ExchangeProduct(modelYear: lead?.oldVehicleMakeYear),
          );
      final tyreReplacement =
          lead?.exchangeProducts?.firstOrNull?.tyreReplacement;
      ref
          .read(editTyreReplacementProvider.notifier)
          .update((state) => !tyreReplacement.isNullOrEmpty);

      final exchangeImages =
          lead?.exchangeProductImages ?? const ExchangeProductImages();
      ref
          .read(exchangeImagesProvider.notifier)
          .update((state) => exchangeImages);
      ref
          .read(addExchangeVehicleImagesProvider.notifier)
          .update((state) => exchangeImages.hasImages);
      ref
          .read(addMoreExchangeVehicleImagesProvider.notifier)
          .update((state) => exchangeImages.hasExtraCarImages);
      final selectedCar = ref.read(selectedExchangeCarProvider);
      ref
          .read(editExistingVehicleProvider.notifier)
          .update(
            (toUpdate) =>
                selectedCar?.oldVehicleId == null ||
                selectedCar?.oldVehicleVariantId == null,
          );
    });
  }

  void _fetchData() {
    final lead = ref.read(prevProspectLeadRequestProvider);
    fetchLead(leadId: lead?.id);
  }

  void _setupView() {
    if (!mounted) return;
    final lead = ref.read(prospectLeadRequestProvider);
    final newFirstTimeBuyer = ref.read(selectedExchangeCarProvider);
    final newExchangeProduct = ref.read(selectedExchangeProductProvider);
    final user = ref.read(profileProvider);
    final errors =
        lead?.prospectExchangeDetailsValidationErrors(
          newExchangeProduct: newExchangeProduct,
          newFirstTimeBuyer: newFirstTimeBuyer,
          user: user,
        ) ??
        [];

    ref
        .read(isProspectFormInEditMode.notifier)
        .update((state) => errors.isNotEmpty);
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (!mounted) return;
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    _initProviders(lead);
    _setupView();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
