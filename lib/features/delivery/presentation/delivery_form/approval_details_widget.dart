import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/discount_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ApprovalDetailsWidget extends SalesdocketConsumerWidget {
  const ApprovalDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(deliveryLeadRequestProvider);
    final discountApprovals = ref.watch(deliveryDiscountApprovalsProvider);

    return Container(
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.circular(1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Column(
        children: [
          verticalSpacing(1.h),
          if ((lead?.showDeliveryDiscountApproval ?? false) &&
              (discountApprovals?.discountGivenInExcess ?? false)) ...[
            _headersWidget(context),
            verticalSpacing(1.h),
            _valuesWidget(context, ref),
            verticalSpacing(1.h),
            _reasonWidget(context, ref),
            _permittedBy(context, ref),
          ],
          _pendingCommitments(context, ref),
          _optionalRemarks(context, ref),
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
    final discountApprovals = ref.watch(deliveryDiscountApprovalsProvider);

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

  Widget _permittedBy(BuildContext context, WidgetRef ref) {
    final discountPermittedBy =
        ref.watch(selectedDeliveryProvider)?.discountPermittedBy ?? "";
    if (discountPermittedBy.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "${LocaleKeys.permittedBy.tr()}:",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              discountPermittedBy,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingCommitments(BuildContext context, WidgetRef ref) {
    final pendingCommitment =
        ref.watch(selectedDeliveryProvider)?.pendingCommitment ?? "";
    if (pendingCommitment.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "${LocaleKeys.pendingCommitments.tr()}:",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              pendingCommitment,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionalRemarks(BuildContext context, WidgetRef ref) {
    final deliveryRemarks =
        ref.watch(selectedDeliveryProvider)?.deliveryRemarks ?? "";
    if (deliveryRemarks.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "${LocaleKeys.optionalRemarks.tr()}:",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              deliveryRemarks,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonWidget(BuildContext context, WidgetRef ref) {
    final discountApprovals = ref.watch(deliveryDiscountApprovalsProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
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
      ),
    );
  }
}
