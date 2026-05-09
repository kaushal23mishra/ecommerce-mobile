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

class PendingAmountTypeWidget extends SalesdocketConsumerWidget {
  const PendingAmountTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptType = ref.watch(
      sendReceiptRequestProvider.select((s) => s?.type),
    );
    final leadId = ref.watch(receiptLeadProvider.select((l) => l?.id));

    if (receiptType != ReceiptType.postDelivery.value || leadId == null) {
      return const SizedBox.shrink();
    }

    final options =
        ref.watch(deliveryLeadPaymentTypeOptionsProvider(leadId)).valueOrNull ??
        [];

    if (options.isEmpty) return const SizedBox.shrink();

    return _buildDropdown(context, ref, options);
  }

  Widget _buildDropdown(
    BuildContext context,
    WidgetRef ref,
    List<String> options,
  ) {
    final selectedPaymentType = ref.watch(
      sendReceiptRequestProvider.select((state) => state?.paymentType),
    );
    final error = ref
        .watch(receiptFormErrorsProvider)
        .get(ReceiptFormFields.receiptPaymentType);

    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: SalesDocketDropDownWidget(
        text: LocaleKeys.typeOfPendingAmount.tr(),
        isRequired: true,
        itemList: options,
        itemValue: selectedPaymentType,
        imagePath: Assets.svg.arrowDown.path,
        onChanged: (selected) {
          ref
              .read(sendReceiptRequestProvider.notifier)
              .update((state) => state?.copyWith(paymentType: selected));
          ref
              .read(receiptFormErrorsProvider.notifier)
              .remove(ReceiptFormFields.receiptPaymentType);
        },
        errorText: error?.message,
      ),
    );
  }
}
