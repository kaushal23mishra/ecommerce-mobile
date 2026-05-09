import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/offer_details/add_remarks_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/offer_details/delivery_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/offer_details/details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/offer_details/prev_remarks_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/offer_details/summary_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryOfferDetails extends SalesdocketConsumerStatefulWidget {
  const DeliveryOfferDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryOfferDetailsState();
}

class _DeliveryOfferDetailsState
    extends SalesdocketConsumerState<DeliveryOfferDetails>
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

    return SalesdocketForm(
      ignoring: !canEdit,
      formWidget: [
        verticalSpacing(2.h),
        const DetailsWidget(),
        verticalSpacing(2.h),
        const SummaryWidget(),
        verticalSpacing(2.h),
        const PrevRemarksWidget(),
        const AddRemarksWidget(),
        verticalSpacing(3.h),
      ],
      actionWidget: const DeliveryActionWidget(),
    );
  }

  void _invalidateProviders() {
    final providers = [
      deliveryLeadRequestProvider,
      editOfferSummaryProvider,
      addRemarksProvider,
      quotationProvider,
      updatedBrokerProvider,
      selectedSchemesProvider,
      selectedAccessoriesProvider,
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
    final quotation = lead?.offerList.firstOrNull ?? const Quotation();
    ref
        .read(addRemarksProvider.notifier)
        .update((state) => state = (quotation.remark ?? "").isNotEmpty);
    ref.read(quotationProvider.notifier).update((state) => state = quotation);
    ref
        .read(selectedSchemesProvider.notifier)
        .update((state) => state = quotation.schemeList);
    ref
        .read(selectedAccessoriesProvider.notifier)
        .update((state) => state = quotation.accessoriesList);
    ref
        .read(updatedBrokerProvider.notifier)
        .update((state) => state = lead?.brokerages?.firstOrNull);
  }

  void _fetchData() {
    final lead = ref.read(prevDeliveryLeadRequestProvider);
    fetchLead(leadId: lead?.id);
    if (lead?.workflow?.isDPR ?? false) {
      getDeliveryApprovals(deliveryId: lead?.delivery?.id);
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

    final quotation = ref.read(quotationProvider);
    ref
        .read(editOfferSummaryProvider.notifier)
        .update(
          (state) =>
              state = canEdit && (quotation?.quotationFields ?? []).isEmpty,
        );
  }

  @override
  void onLeadFetched(Lead? lead) {
    ref
        .read(prevDeliveryLeadRequestProvider.notifier)
        .update((state) => state = lead ?? state);
    _initProviders(lead);
    _setupEditMode();
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
