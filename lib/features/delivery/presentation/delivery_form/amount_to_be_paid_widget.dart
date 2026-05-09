import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AmountToBePaidWidget extends SalesdocketConsumerWidget {
  final Quotation? quotation;

  const AmountToBePaidWidget({super.key, this.quotation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(children: [_offerHeaders, _offerPrices]),
    );
  }

  Widget get _offerHeaders {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TableHeaderItem(LocaleKeys.scheme.tr()),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.discount.tr(),
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget get _offerPrices {
    final quotationFields =
    (quotation?.quotationFields ?? [])
        .where(
          (quotationField) =>
      quotationField.priceOrSchemeType == 'scheme' &&
          quotationField.schemeType == 0,
    )
        .toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final quotation = quotationFields[index];

        return Container(
          decoration: BoxDecoration(color: appColors.grayLight),
          child: Row(
            children: [
              Expanded(
                child: TableRowItem(
                  child: Text(
                    quotation.description?.sentenceToCamelCase ?? "N/A",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                      color: appColors.textTertiary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TableRowItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        (quotation.discount ?? 0).formatIndianCommas,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                          color:
                          quotation.freeFlag == 1
                              ? appColors.primary
                              : appColors.textPrimary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder:
          (context, index) =>
          Row(
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 0,
                  child: Divider(color: appColors.grayMedium),
                ),
              ),
            ],
          ),
      itemCount: quotationFields.length,
    );
  }
}
