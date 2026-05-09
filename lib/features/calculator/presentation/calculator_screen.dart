import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/calculator/presentation/emi_result_widget.dart';
import 'package:salesdocket_mobile/features/calculator/presentation/select_amount_widget.dart';
import 'package:salesdocket_mobile/features/calculator/presentation/select_interest_rate_widget.dart';
import 'package:salesdocket_mobile/features/calculator/presentation/select_tenure_widget.dart';
import 'package:salesdocket_mobile/features/calculator/view_model/calculator_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CalculatorScreen extends SalesdocketConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState
    extends SalesdocketConsumerState<CalculatorScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            verticalSpacing(3.h),
            const SelectAmountWidget(),
            verticalSpacing(3.h),
            const SelectTenureWidget(),
            verticalSpacing(3.h),
            const SelectInterestRateWidget(),
            verticalSpacing(3.h),
            const EmiResultWidget(),
            verticalSpacing(2.h),
          ],
        ),
      ),
    );
  }

  _invalidateProviders() {
    ref.invalidate(localAmountProvider);
    ref.invalidate(tenureProvider);
    ref.invalidate(interestProvider);
  }
}
