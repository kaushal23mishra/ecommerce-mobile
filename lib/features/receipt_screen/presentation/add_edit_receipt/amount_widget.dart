import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AmountWidget extends SalesdocketConsumerStatefulWidget {
  const AmountWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmountState();
}

class _AmountState extends SalesdocketConsumerState<AmountWidget> {
  final _amountController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = ref.read(sendReceiptRequestProvider);
      _amountController.text = "${request?.amount ?? ""}";
    });
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = ref
        .watch(receiptFormErrorsProvider)
        .get(ReceiptFormFields.receiptAmount);
    ref.listen<Receipt?>(sendReceiptRequestProvider, _requestListener);

    return SalesDocketInputWidget(
      label: LocaleKeys.lblReceiptAmount.tr(),
      hint: LocaleKeys.lblReceiptAmount.tr(),
      isRequired: true,
      controller: _amountController,
      inputType: TextInputType.number,
      inputFormatters: InputFormatters.digitsOnly,
      onChanged: (value) {
        ref
            .read(sendReceiptRequestProvider.notifier)
            .update(
              (state) =>
                  state = state?.copyWith(amount: int.tryParse(value.trim())),
            );
        ref
            .read(receiptFormErrorsProvider.notifier)
            .remove(ReceiptFormFields.receiptAmount);
      },
      errorMsg: error?.message,
    );
  }

  void _requestListener(Receipt? previous, Receipt? next) {
    loggy.debug(previous);
    loggy.debug(next);
    if (previous?.amount != next?.amount) {
      _amountController.text = "${next?.amount ?? ""}";
    }
  }
}
