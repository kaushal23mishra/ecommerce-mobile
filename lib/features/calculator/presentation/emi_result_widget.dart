import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/features/calculator/view_model/calculator_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class EmiResultWidget extends SalesdocketConsumerWidget {
  const EmiResultWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(localAmountProvider);
    final tenure = ref.watch(tenureProvider);
    final interestRate = ref.watch(interestProvider);
    final emiPerMonth = _calculateEmi(amount * 100000, tenure, interestRate);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(2.w)),
        gradient: LinearGradient(
          colors: [appColors.primary, appColors.primaryLight],
          begin: const Alignment(-1.0, -4.0),
          end: const Alignment(1.0, 4.0),
          //stops: [0.2, 0.6],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.emiPerMonth.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textSecondary),
          ),
          verticalSpacing(0.5.h),
          Text(
            "₹ ${emiPerMonth.formatToIndianNumber}",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: appColors.textSecondary,
              fontSize: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateEmi(double amount, double tenure, double interestRate) {
    final monthlyInterestRate = interestRate / (12 * 100);
    final emi =
        (amount *
            monthlyInterestRate *
            (pow(1 + monthlyInterestRate, tenure))) /
        (pow(1 + monthlyInterestRate, tenure) - 1);

    return emi.roundToDouble();
  }
}
