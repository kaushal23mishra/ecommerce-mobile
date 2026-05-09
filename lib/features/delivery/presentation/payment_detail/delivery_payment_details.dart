import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/credit_given_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/deal_closure_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/delivery_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/old_car_payment_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/payment_received_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryPaymentDetails extends SalesdocketConsumerStatefulWidget {
  const DeliveryPaymentDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryPaymentDetailsState();
}

class _DeliveryPaymentDetailsState
    extends SalesdocketConsumerState<DeliveryPaymentDetails>
    with LeadEvents, ReceiptEvents {
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
    final lead = ref.watch(deliveryLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DetailsWidget(),
        verticalSpacing(2.h),
        const DealClosureWidget(),
        verticalSpacing(3.h),
        const PaymentReceivedWidget(),
        verticalSpacing(2.h),
        Text(
          LocaleKeys.lblReason.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: appColors.textDisabled,
          ),
        ),
        verticalSpacing(2.h),
        const OldCarPaymentWidget(),
        verticalSpacing(2.h),
        const CreditGivenWidget(),
        verticalSpacing(3.h),
      ],
      actionWidget: const DeliveryActionWidget(),
    );
  }

  void _invalidateProviders() {
    final providers = [
      quotationProvider,
      deliveryReceiptsProvider,
      selectedExchangeHouseProvider,
      creditGivenProvider,
      isFinanceEditModeProvider,
      deliveryReceiptReasonsProvider,
      selectedBookingProvider,

      selectedDeliveryProvider,
      oldCarPaymentProvider,
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
    ref
        .read(selectedBookingProvider.notifier)
        .update((toUpdate) => toUpdate = lead?.booking ?? const Booking());
    ref
        .read(selectedDeliveryProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate = lead?.delivery ?? const Delivery(),
        );
    final quotation = lead?.offerList.firstOrNull ?? const Quotation();
    ref.read(quotationProvider.notifier).update((state) => state = quotation);
    ref
        .read(selectedExchangeHouseProvider.notifier)
        .update(
          (state) =>
              state =
                  lead?.bookingExchangeHouse ?? const ExchangeHouseRequest(),
        );
  }

  void _fetchData() {
    final lead = ref.read(prevDeliveryLeadRequestProvider);
    fetchLead(leadId: lead?.id);
    fetchReceiptReasons(leadId: lead?.id);
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
  void onReceiptReasonsFetched(List<ReceiptReason> receiptReasons) {
    ref
        .read(deliveryReceiptReasonsProvider.notifier)
        .update((state) => state = receiptReasons);
    ref
        .read(creditGivenProvider.notifier)
        .update((state) => state = receiptReasons.creditGivenDetails);
    ref
        .read(oldCarPaymentProvider.notifier)
        .update((state) => state = receiptReasons.oldCarPaymentDetails);
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
