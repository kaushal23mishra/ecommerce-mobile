import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/amount_to_be_paid_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DealClosureWidget extends SalesdocketConsumerWidget {
  const DealClosureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationProvider);
    final totalCost = quotation?.totalCost ?? 0;
    final totalDiscount = quotation?.totalDiscount ?? 0;
    final upfrontNotGiven = quotation?.upfrontNotGiven ?? 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: appColors.primaryLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 1.h,
        children: [
          Text(
            "${LocaleKeys.totalDealClosure.tr()} : ${(totalCost - totalDiscount).formatIndianCommas}",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${LocaleKeys.amountToBePaid.tr()} : ${(totalCost - totalDiscount + upfrontNotGiven).formatIndianCommas}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textDisabled,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showAmountToBePaidBottomSheet(context, quotation);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: SizedBox(
                    width: 6.w,
                    child: Icon(
                      Icons.info,
                      color: appColors.primary,
                      size: 6.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAmountToBePaidBottomSheet(
    BuildContext context,
    Quotation? quotation,
  ) {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketBottomSheet(
          title: "",
          padding: EdgeInsets.zero,
          widget: Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
            child: AmountToBePaidWidget(quotation: quotation),
          ),
        );
      },
    );
  }
}
