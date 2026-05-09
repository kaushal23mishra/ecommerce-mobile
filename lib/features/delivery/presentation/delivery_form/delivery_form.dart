import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/approval_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/booking_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/buying_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/chasis_number_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/dates_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/delivery_action_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/delivery_form_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/enquiry_detail_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/exchange_details_widget.dart';

import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/payment_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/pending_commitment_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/personal_details.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/reason_for_selecting_branding_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/reference_token_widget.dart';

import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/summary_widget.dart';

import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart' hide quotationProvider;
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryForm extends SalesdocketConsumerStatefulWidget {
  const DeliveryForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends SalesdocketConsumerState<DeliveryForm>
    with LeadEvents, ProductEvents, ReceiptEvents {
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

    final canEdit = ref.watch(canEditDeliveryProvider);

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DeliveryFormDetailsWidget(),
        verticalSpacing(2.h),
        const EnquiryDetailWidget(),
        verticalSpacing(2.h),
        const BookingDetailsWidget(),
        verticalSpacing(2.h),
        const DeliveryPersonalDetails(),
        verticalSpacing(2.h),
        const BuyingDetailsWidget(),
        verticalSpacing(2.h),
        const ExchangeDetailsWidget(),
        verticalSpacing(2.h),
        const SummaryWidget(),
        verticalSpacing(2.h),
        const PaymentDetailsWidget(),
        verticalSpacing(2.h),
        IgnorePointer(ignoring: !canEdit, child: _formWidget),
      ],
      actionWidget: const DeliveryActionWidget(),
    );
  }

  Widget get _formWidget {
    final lead = ref.watch(deliveryLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReferenceTokenWidget(
          leadId: "${lead.id ?? ""}",
          deactivated: lead.delivery?.referenceTaken == 1,
        ),
        verticalSpacing(2.h),

        const ReasonForSelectingBrandingWidget(),
        verticalSpacing(2.h),
        const DatesWidget(),
        verticalSpacing(2.h),
        const ChasisNumberWidget(),
        verticalSpacing(2.h),
        const PendingCommitmentWidget(),
        if (lead.showDeliveryDiscountApproval)
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: const ApprovalDetailsWidget(),
          ),
        verticalSpacing(3.h),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [
      deliveryLeadRequestProvider,
      quotationProvider,
      selectedDeliveryProvider,
      deliveryDiscountsProvider,
      deliveryDiscountApprovalsProvider,
      sendDeliveryDiscountApprovalRequestProvider,
      deliveryReceiptsProvider,
      deliveryReceiptReasonsProvider,
      creditGivenProvider,
      selectedExchangeHouseProvider,
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
        .update((state) => state = lead?.copyWith(
          purchaseMode: (lead.purchaseMode?.isNotEmpty == true ? lead.purchaseMode : lead.booking?.purchaseMode) ?? PurchaseMode.cash.value,
        ));
    final quotation = lead?.offerList.firstOrNull;
    ref.read(quotationProvider.notifier).update((state) => state = quotation);
    ref
        .read(selectedDeliveryProvider.notifier)
        .update(
          (state) => state = lead?.deliveryFormDetails ?? const Delivery(),
        );
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
    getDeliveryApprovals(deliveryId: lead?.delivery?.id);
    getDiscounts(variantId: lead?.primaryVariantId);
    fetchReceipts(leadId: lead?.id);
    fetchReceiptReasons(leadId: lead?.id);
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
  void onDiscountsFetched(List<Discount> list) {
    ref
        .read(deliveryDiscountsProvider.notifier)
        .update((state) => state = list);
  }

  @override
  void onDeliveryApprovalFetched(DiscountApproval? approval) {
    ref
        .read(deliveryDiscountApprovalsProvider.notifier)
        .update((state) => state = approval);
    ref
        .read(sendDeliveryDiscountApprovalRequestProvider.notifier)
        .update(
          (state) =>
              state = DiscountApprovalRequest(
                requestId: approval?.id,
                appRequest: true,
              ),
        );
    _setupEditMode();
  }

  @override
  void onReceiptReasonsFetched(List<ReceiptReason> receiptReasons) {
    ref
        .read(deliveryReceiptReasonsProvider.notifier)
        .update((state) => state = receiptReasons);
        ref.read(creditGivenProvider.notifier)
        .update((state) => state = receiptReasons.creditGivenDetails);
    ref
        .read(oldCarPaymentProvider.notifier)
        .update((state) => state = receiptReasons.oldCarPaymentDetails);
  }

  @override
  void onReceiptsFetched(List<Receipt> list) {
    ref.read(deliveryReceiptsProvider.notifier).update((state) => state = list);
  }

  @override
  void onLeadFetched(Lead? lead) {
    ref
        .read(prevDeliveryLeadRequestProvider.notifier)
        .update((state) => state = lead ?? state);
    ref
        .read(prospectLeadRequestProvider.notifier)
        .update((state) => state = lead ?? state);
    _initProviders(lead);
    _setupEditMode();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
