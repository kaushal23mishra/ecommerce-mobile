import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/shapes/slider_thumb_shaps.dart';
import 'package:salesdocket_mobile/features/calculator/view_model/calculator_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SelectAmountWidget extends SalesdocketConsumerWidget {
  const SelectAmountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountValue = ref.watch(localAmountProvider);

    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.loanAmountLakhs.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "₹ ${amountValue.formatLakhsToRupees}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          verticalSpacing(1.5.h),
          Container(
            padding: EdgeInsets.only(
              top: 4.h,
              bottom: 1.h,
              left: 1.5.w,
              right: 1.5.w,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: appColors.grayDark, width: 0.1.w),
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
            ),
            child: SfSliderTheme(
              data: SfSliderThemeData(
                activeTrackHeight: 0,
                inactiveTrackHeight: 0,
                tickSize: Size(0.3.w, 1.5.h),
                tooltipBackgroundColor: Colors.transparent,
              ),
              child: SfSlider(
                min: 0.25,
                max: 80,
                value: amountValue,
                shouldAlwaysShowTooltip: false,
                showTicks: true,
                enableTooltip: true,
                stepSize: 0.25,
                interval: 10,
                minorTicksPerInterval: 3,
                activeColor: appColors.primary,
                inactiveColor: appColors.primaryLight,
                tooltipTextFormatterCallback: (_, value) => "",
                thumbShape: SliderThumbShape(
                  buildContext: context,
                  value: "${amountValue.toStringAsFixed(2)} L",
                ),
                onChanged: (value) {
                  ref
                      .read(localAmountProvider.notifier)
                      .update((amount) => amount = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
