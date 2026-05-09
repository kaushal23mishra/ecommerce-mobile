import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/calculator/view_model/calculator_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SelectTenureWidget extends SalesdocketConsumerWidget {
  const SelectTenureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenureValue = ref.watch(tenureProvider);

    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.paybackPeriodMonths.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "${tenureValue.toStringAsFixed(0)} months",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          verticalSpacing(1.5.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
            decoration: BoxDecoration(
              border: Border.all(color: appColors.grayDark, width: 0.1.w),
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
            ),
            child: SalesdocketHorizontalPicker(
              minValue: 12,
              maxValue: 120,
              divisions: 9,
              height: 9.h,
              showCursor: false,
              backgroundColor: Colors.transparent,
              activeItemTextColor: appColors.primary,
              passiveItemsTextColor: appColors.textPrimary,
              initialPosition: InitialPosition.start,
              initialValueIndex: 0,
              onChanged: (value) {
                ref
                    .read(tenureProvider.notifier)
                    .update((tenure) => tenure = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
