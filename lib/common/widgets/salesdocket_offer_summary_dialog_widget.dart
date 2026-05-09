import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketOfferSummaryDialogWidget extends SalesdocketStatelessWidget {
  final Quotation? quotation;
  final Lead? lead;

  const SalesdocketOfferSummaryDialogWidget({
    super.key,
    this.quotation,
    this.lead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.h, horizontal: 1.w),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacing(2.h),
          Text(
            LocaleKeys.summary.tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          verticalSpacing(2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: appColors.primaryLight,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(color: appColors.primary, width: 0.3.w),
            ),
            child: Text(
              lead?.primaryVariant?.carName ?? "",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          verticalSpacing(2.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SalesdocketOfferSummaryViewWidget(
                    quotation: quotation,
                    lead: lead,
                  ),
                  OfferSummaryFooterWidget(quotation: quotation),
                ],
              ),
            ),
          ),
          verticalSpacing(1.h),
          SalesDocketButtonWidget(
            isOutlined: true,
            onPressed: () {
              context.router.maybePop(true);
            },
            text: LocaleKeys.looksGood.tr(),
          ),
          verticalSpacing(1.h),
        ],
      ),
    );
  }
}
