import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../features/profile/view_model/profile_view_model.dart';

class SalesdocketFollowupDetailsCardWidget extends SalesdocketStatelessWidget {
  final Lead lead;

  const SalesdocketFollowupDetailsCardWidget({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsCardWidget(lead: lead),
        ExchangeDetailsCardWidget(lead: lead),
        LostDetailsCardWidget(lead: lead),
      ],
    );
  }
}

class DetailsCardWidget extends SalesdocketConsumerWidget {
  final Lead lead;

  const DetailsCardWidget({super.key, required this.lead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: appColors.primaryLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _nameWidget(context)),
              SizedBox(width: 4.w),
              _phoneWidget(context, ref),
            ],
          ),
          _variantWidget(context),
          verticalSpacing(1.h),
          Row(
            children: [
              Expanded(child: _totalPriceWidget(context)),
              SizedBox(width: 4.w),
              _leadStateWidget(context),
            ],
          ),
          verticalSpacing(1.h),
          _dmsIdWidget(context),
        ],
      ),
    );
  }

  Widget _nameWidget(BuildContext context) {
    return Text(
      lead.fullName.isNotEmpty ? lead.fullName : lead.campaignFullName,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: appColors.textPrimary,
        fontSize: 15.sp,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _phoneWidget(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final hideMobile = profile?.hideMobile ?? 0;

    String getPhoneNumber({required bool masked}) {
      final primary =
          masked
              ? lead.primaryContactNumber.maskedPhoneNumber
              : lead.primaryContactNumber;
      final secondary =
          masked
              ? lead.leadMobileNumber?.maskedPhoneNumber
              : lead.leadMobileNumber;
      return primary.isNotEmpty == true ? primary : secondary ?? '';
    }

    return Text(
      hideMobile != 0
          ? getPhoneNumber(masked: true)
          : getPhoneNumber(masked: false),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: appColors.textDisabled,
        fontSize: 15.sp,
      ),
    );
  }

  Widget _variantWidget(BuildContext context) {
    final carName = lead.primaryVariant?.carName ?? "";
    final carColor = lead.interestedColor?.lastOrNull?.color ?? "";

    if (carName.isEmpty && carColor.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              carName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            carColor,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.textDisabled),
          ),
        ],
      ),
    );
  }

  Widget _totalPriceWidget(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${LocaleKeys.totalPrice.tr()} : ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
          ),
          TextSpan(
            text: "", // Add actual price data here if available
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _leadStateWidget(BuildContext context) {
    return Text(
      lead.stateValue ?? "",
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: appColors.textDisabled,
        fontSize: 15.sp,
      ),
    );
  }

  Widget _dmsIdWidget(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${LocaleKeys.dmsId.tr()} : ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
          ),
          TextSpan(
            text: lead.dmsId ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.primary),
          ),
        ],
      ),
    );
  }
}

class ExchangeDetailsCardWidget extends SalesdocketStatelessWidget {
  final Lead lead;

  const ExchangeDetailsCardWidget({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final exchangeProduct = lead.exchangeProducts?.lastOrNull;

    return exchangeProduct == null
        ? const SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(2.h),
            Text(
              LocaleKeys.exchangeDetails.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            verticalSpacing(1.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
              decoration: BoxDecoration(
                color: appColors.primaryLight,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(color: appColors.primary, width: 0.3.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 4.w,
                    children: [
                      Expanded(child: _nameWidget(context, exchangeProduct)),
                      _phoneWidget(context, exchangeProduct),
                    ],
                  ),
                  verticalSpacing(1.h),
                  _expectedPriceWidget(context, exchangeProduct),
                  verticalSpacing(1.h),
                  _quotedPriceWidget(context, exchangeProduct),
                ],
              ),
            ),
          ],
        );
  }

  Widget _nameWidget(BuildContext context, ExchangeProduct product) {
    return Text(
      "${product.variant?.product?.name ?? ""} ${product.variant?.variant ?? ""}",
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: appColors.textDisabled,
        fontSize: 15.sp,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _phoneWidget(BuildContext context, ExchangeProduct product) {
    return Text(
      "${product.modelYear ?? ""}",
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(color: appColors.textDisabled),
    );
  }

  Widget _expectedPriceWidget(BuildContext context, ExchangeProduct product) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${LocaleKeys.expectedPrice.tr()} : ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
          ),
          TextSpan(
            text: product.expectedPrice?.formatIndianCommas ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _quotedPriceWidget(BuildContext context, ExchangeProduct product) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${LocaleKeys.quotedPrice.tr()} : ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
          ),
          TextSpan(
            text: product.quotedPrice?.formatIndianCommas ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.primary),
          ),
        ],
      ),
    );
  }
}

class LostDetailsCardWidget extends SalesdocketStatelessWidget {
  final Lead lead;

  const LostDetailsCardWidget({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final isLPA = lead.workflow?.isLPA ?? false;

    return !isLPA
        ? const SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(2.h),
            Text(
              LocaleKeys.lostDetails.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            verticalSpacing(1.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
              decoration: BoxDecoration(
                color: appColors.primaryLight,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(color: appColors.primary, width: 0.3.w),
              ),
              child: Row(
                spacing: 2.w,
                children: [
                  Expanded(child: _lostToWidget(context)),
                  _lostCoDealerWidget(context),
                ],
              ),
            ),
          ],
        );
  }

  Widget _lostToWidget(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${LocaleKeys.lostTo.tr()} : ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
          ),
          TextSpan(
            text: lead.workflow?.lostTo ?? "",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: appColors.primary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lostCoDealerWidget(BuildContext context) {
    final lostToProduct =
        "${lead.workflow?.lostToProduct?.brand?.name ?? ""} ${lead.workflow?.lostToProduct?.name ?? ""}";
    final lostTo =
        lostToProduct.trim().isEmpty
            ? lead.workflow?.lostToCoDealerName ?? ""
            : lostToProduct;

    return lostTo.isEmpty
        ? const SizedBox.shrink()
        : Text(
          " - $lostTo",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: appColors.textDisabled,
            fontSize: 15.sp,
          ),
        );
  }
}
