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
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/exchange_details/delivery_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/exchange_details/details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/exchange_details/edit_exchange_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/exchange_details/exchange_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryExchangeDetails extends SalesdocketConsumerStatefulWidget {
  const DeliveryExchangeDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryExchangeDetailsState();
}

class _DeliveryExchangeDetailsState
    extends SalesdocketConsumerState<DeliveryExchangeDetails>
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
        verticalSpacing(2.h),
        const ExchangeDetailsWidget(),
        verticalSpacing(1.h),
        SalesdocketEditFormSwitch(
          label: "Edit Exchange Details",
          isInEditMode: isInEditMode,
          onChanged: (value) {
            ref
                .read(isDeliveryFormInEditMode.notifier)
                .update((state) => state = value);
          },
          form: const EditExchangeDetailsWidget(),
        ),
      ],
      actionWidget: const DeliveryActionWidget(),
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
      selectedExchangeHouseProvider,
      exchangeImagesProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [deliveryFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    ref
        .read(deliveryLeadRequestProvider.notifier)
        .update((state) => state = lead?.copyWith());
    ref
        .read(canEditDeliveryProvider.notifier)
        .update((state) => state = LeadUtils.canEditDelivery(lead));

    final firstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final (:exchangeCar, :usedFallback) = LeadUtils.resolveExchangeCar(
      lead: lead,
      firstTimeBuyer: firstTimeBuyer,
    );

    ref
        .read(selectedExchangeCarProvider.notifier)
        .update((toUpdate) => toUpdate = exchangeCar);
    ref
        .read(selectedExchangeProductProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate =
                  lead?.exchangeProducts?.lastOrNull ??
                  ExchangeProduct(modelYear: lead?.oldVehicleMakeYear),
        );
    final tyreReplacement = lead?.exchangeProducts?.lastOrNull?.tyreReplacement;
    ref
        .read(editTyreReplacementProvider.notifier)
        .update((state) => state = !tyreReplacement.isNullOrEmpty);
    ref
        .read(selectedExchangeHouseProvider.notifier)
        .update(
          (state) =>
              state =
                  lead?.bookingExchangeHouse ?? const ExchangeHouseRequest(),
        );

    final exchangeImages =
        lead?.exchangeProductImages ?? const ExchangeProductImages();
    ref
        .read(exchangeImagesProvider.notifier)
        .update((state) => state = exchangeImages);
    ref
        .read(addExchangeVehicleImagesProvider.notifier)
        .update((state) => state = exchangeImages.hasImages);
    ref
        .read(addMoreExchangeVehicleImagesProvider.notifier)
        .update((state) => state = exchangeImages.hasExtraCarImages);
    final selectedCar = ref.read(selectedExchangeCarProvider);
    ref
        .read(editExistingVehicleProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate =
                  usedFallback ||
                  selectedCar?.oldVehicleId == null ||
                  selectedCar?.oldVehicleVariantId == null,
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
    final newFirstTimeBuyer = ref.read(selectedExchangeCarProvider);
    final newExchangeProduct = ref.read(selectedExchangeProductProvider);
    final newExchangeHouseDetails = ref.read(selectedExchangeHouseProvider);
    final errors =
        lead?.deliveryExchangeDetailsValidationErrors(
          newExchangeProduct: newExchangeProduct,
          newFirstTimeBuyer: newFirstTimeBuyer,
          newExchangeHouseDetails: newExchangeHouseDetails,
        ) ??
        [];

    ref
        .read(isDeliveryFormInEditMode.notifier)
        .update((state) => state = errors.isNotEmpty);
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
