import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ApprovalDiscountDetailsWidget extends SalesdocketConsumerWidget {
  const ApprovalDiscountDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(bookingLeadRequestProvider);
    final workflow = lead?.workflow;
    return Container(
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.circular(1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Column(
        children: [
          workflow!.isCPA
              ? Column(
                children: [
                  verticalSpacing(1.h),
                  _cancellationReasonWidget(context, ref),
                  verticalSpacing(1.h),
                  _cancellationChargesWidget(context, ref),
                ],
              )
              : Column(
                children: [
                  _headersWidget(context),
                  verticalSpacing(1.h),
                  _valuesWidget(context, ref),
                  verticalSpacing(1.h),
                  _reasonWidget(context, ref),

                ],
              ),
          verticalSpacing(1.h),

        ],
      ),
    );
  }

  Widget _headersWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.thresholdDiscount.tr(),
            textColor: appColors.secondary,
          ),
        ),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.discountGiven.tr(),
            textColor: appColors.secondary,
          ),
        ),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.discountExceeded.tr(),
            textColor: appColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _valuesWidget(BuildContext context, WidgetRef ref) {
    final discountApprovals = ref.watch(bookingDiscountApprovalsProvider);

    return Row(
      children: [
        Expanded(
          child: Text(
            discountApprovals?.discountCap?.formatToIndianNumber ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: appColors.secondary),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            discountApprovals?.discountGiven?.formatToIndianNumber ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            ((discountApprovals?.discountGiven ?? 0) -
                    (discountApprovals?.discountCap ?? 0))
                .formatToIndianNumber,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: appColors.secondary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _reasonWidget(BuildContext context, WidgetRef ref) {
    final discountApprovals = ref.watch(bookingDiscountApprovalsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "${LocaleKeys.reasonForGivingMoreDiscount.tr()}:",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            discountApprovals?.discountReason ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _cancellationReasonWidget(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(bookingLeadRequestProvider);
    final bookingReason = lead?.booking?.bookingReasons?.lastOrNull;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "${LocaleKeys.bookingCancellationReason.tr()}:",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
          ),
        ),
        Expanded(
          child: Text(
            bookingReason?.reason ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _cancellationChargesWidget(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(bookingLeadRequestProvider);
    final bookingReason = lead?.booking?.bookingReasons?.lastOrNull;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "${LocaleKeys.bookingCancellationCharges.tr()}:",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
          ),
        ),
        Expanded(
          child: Text(
            bookingReason?.bookingCancelAmount?.toString() ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
          ),
        ),
      ],
    );
  }
}
