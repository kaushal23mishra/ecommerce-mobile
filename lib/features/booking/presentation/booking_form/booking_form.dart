import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/approval_discount_details_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/booking_action_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/booking_form_details_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/buying_details_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/dates_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/enquiry_detail_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/exchange_details_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/personal_details.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/summary_widget.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingForm extends SalesdocketConsumerStatefulWidget {
  const BookingForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingFormState();
}

class _BookingFormState extends SalesdocketConsumerState<BookingForm>
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
    final lead = ref.watch(bookingLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BookingFormDetailsWidget(),
                const EnquiryDetailWidget(),
                const BookingPersonalDetails(),
                const BuyingDetailsWidget(),
                const ExchangeDetailsWidget(),
                verticalSpacing(2.h),
                const SummaryWidget(),
                verticalSpacing(2.h),
                const DatesWidget(),
                if (lead.showBookingDiscountApproval)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: const ApprovalDiscountDetailsWidget(),
                  ),
                verticalSpacing(3.h),
              ],
            ),
            const BookingActionWidget(),
          ],
        ),
      ),
    );
  }

  void _invalidateProviders() {
    final providers = [
      bookingLeadRequestProvider,
      quotationProvider,
      selectedBookingProvider,
      bookingDiscountsProvider,
      bookingDiscountApprovalsProvider,
      bookingReceiptsProvider,
      sendBookingDiscountApprovalRequestProvider,
      scheduleCallFollowupProvider,
      bookingFollowupDateTimeProvider,
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
    ref
        .read(bookingLeadRequestProvider.notifier)
        .update((state) => state = lead?.copyWith(
          purchaseMode: (lead.purchaseMode?.isNotEmpty == true ? lead.purchaseMode : lead.booking?.purchaseMode) ?? PurchaseMode.cash.value,
        ));
    final quotation = lead?.offerList.firstOrNull;
    ref.read(quotationProvider.notifier).update((state) => state = quotation);
    ref
        .read(selectedBookingProvider.notifier)
        .update((state) => state = lead?.bookingFormDetails ?? const Booking());

    final previousLead = ref.read(prevBookingLeadRequestProvider);
    final bookingCallAction =
        _getActiveBookingCallAction(lead) ??
        _getActiveBookingCallAction(previousLead);
    if (bookingCallAction != null) {
      ref
          .read(bookingFollowupDateTimeProvider.notifier)
          .update((state) => bookingCallAction.dueDate);
      ref
          .read(scheduleCallFollowupProvider.notifier)
          .update((state) => true);
    } else {
      ref
          .read(scheduleCallFollowupProvider.notifier)
          .update((state) => false);
    }
  }

  LeadAction? _getActiveBookingCallAction(Lead? lead) {
    return lead?.workflow?.actions
        ?.where(
          (a) =>
              a.action?.toLowerCase() == FollowUpPlanType.bookingCall.value &&
              (a.status ?? 0) == 1,
        )
        .firstOrNull;
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
    ref.read(canEditBookingProvider.notifier).update((state) => state = canEdit);
  }

  void _fetchData() {
    final lead = ref.read(prevBookingLeadRequestProvider);
    fetchLead(leadId: lead?.id);
    getDiscountApprovals(leadId: lead?.id);
  }

  @override
  void onDiscountsFetched(List<Discount> list) {
    ref.read(bookingDiscountsProvider.notifier).update((state) => state = list);
  }

  @override
  void onDiscountApprovalFetched(DiscountApproval? approval) {
    ref
        .read(bookingDiscountApprovalsProvider.notifier)
        .update((state) => state = approval);
    ref
        .read(sendBookingDiscountApprovalRequestProvider.notifier)
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
  void onLeadFetched(Lead? lead) {
    ref
        .read(prevBookingLeadRequestProvider.notifier)
        .update((state) => state = lead ?? state);
    getDiscounts(variantId: lead?.primaryVariantId);
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
