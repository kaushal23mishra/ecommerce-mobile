import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ModeOfPaymentWidget extends SalesdocketConsumerWidget {
  const ModeOfPaymentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptPaymentMode = ref.watch(
      sendReceiptRequestProvider.select((state) => state?.paymentMode),
    );
    final receiptPermittedBy = ref.watch(
      sendReceiptRequestProvider.select((state) => state?.permittedBy),
    );
    final errorModeOfPayment = ref
        .watch(receiptFormErrorsProvider)
        .get(ReceiptFormFields.receiptModeOfPayment);
    final errorPermittedBy = ref
        .watch(receiptFormErrorsProvider)
        .get(ReceiptFormFields.receiptPermittedBy);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketDropDownWidget(
          text: LocaleKeys.modeOfPayment.tr(),
          isRequired: true,
          itemList: receiptPurchaseModeList.map((item) => item.value).toList(),
          itemValue: receiptPaymentMode,
          imagePath: Assets.svg.arrowDown.path,
          onChanged: (selected) {
            ref
                .read(sendReceiptRequestProvider.notifier)
                .update(
                  (state) =>
                      state = state?.copyWith(
                        paymentMode: selected,
                        permittedBy: null,
                      ),
                );
            ref
                .read(receiptFormErrorsProvider.notifier)
                .remove(ReceiptFormFields.receiptModeOfPayment);
          },
          errorText: errorModeOfPayment?.message,
        ),
        if (receiptPaymentMode == ReceiptPurchaseMode.cheque.value)
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: SalesDocketInputWidget(
              label: LocaleKeys.chequePermittedBy.tr(),
              hint: LocaleKeys.chequePermittedBy.tr(),
              isRequired: true,
              initialValue: receiptPermittedBy,
              onChanged: (value) {
                ref
                    .read(sendReceiptRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(permittedBy: value.trim()),
                    );
                ref
                    .read(receiptFormErrorsProvider.notifier)
                    .remove(ReceiptFormFields.receiptPermittedBy);
              },
              errorMsg: errorPermittedBy?.message,
            ),
          ),
      ],
    );
  }
}
