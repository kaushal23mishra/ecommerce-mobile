import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryAmountWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveryAmountWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeliveryAmountState();
}

class _DeliveryAmountState
    extends SalesdocketConsumerState<DeliveryAmountWidget>
    with ReceiptEvents {
  @override
  Widget build(BuildContext context) {
    final receipts = ref
        .watch(deliveryReceiptsProvider)
        .filteredReceipts(type: ReceiptType.delivery);
    final errorText =
        ref
            .watch(deliveryFormErrorsProvider)
            .get(LeadFormFields.amountCollected)
            ?.message;
    final amount = receipts.amount;
    final canEdit = ref.watch(canEditDeliveryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 17.w),
              child: Text(
                LocaleKeys.lblDelivery.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: appColors.textDisabled,
                ),
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 2.75.w,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.secondary,
                        borderRadius: BorderRadius.circular(1.w),
                        border: Border.all(
                          color: appColors.disabled,
                          width: 0.1.w,
                        ),
                      ),
                      child: Text(
                        amount.formatIndianCommas,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  if (amount > 0)
                    GestureDetector(
                      onTap: () {
                        _moveToReceiptListScreen();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: SizedBox(
                          width: 8.w,
                          child: Icon(
                            Icons.info,
                            color: appColors.info,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            horizontalSpacing(3.w),

            if (canEdit) ...[
              SalesDocketButtonWidget(
                width: 34.w,
                onPressed: () {
                  _moveToReceiptScreen();
                },
                text: LocaleKeys.addReceipts.tr(),
                isOutlined: true,
              ),
              horizontalSpacing(3.w),
            ],
          ],
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              errorText,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: appColors.error),
            ),
          ),
      ],
    );
  }

  void _moveToReceiptScreen() {
    final lead = ref.read(deliveryLeadRequestProvider);
    ref.read(receiptLeadProvider.notifier).update((state) => state = lead);
    ref
        .read(receiptSourceProvider.notifier)
        .update((state) => state = ReceiptType.delivery);
    ref
        .read(sendReceiptRequestProvider.notifier)
        .update(
          (state) =>
              Receipt(leadId: lead?.id, type: ReceiptType.delivery.value),
        );
    context.router.push(const AddEditReceiptRoute()).then((_) {
      fetchReceipts(leadId: lead?.id);
    });
  }

  void _moveToReceiptListScreen() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final canEdit = ref.read(canEditDeliveryProvider);
    ref
        .read(canEditReceiptProvider.notifier)
        .update((state) => state = canEdit);
    ref.read(receiptLeadProvider.notifier).update((state) => state = lead);
    ref
        .read(receiptSourceProvider.notifier)
        .update((state) => state = ReceiptType.delivery);
    context.router.push(const ReceiptListRoute()).then((_) {
      fetchReceipts(leadId: lead?.id);
    });
  }

  @override
  void onReceiptsFetched(List<Receipt> list) {
    ref.read(deliveryReceiptsProvider.notifier).update((state) => state = list);
    ref
        .read(deliveryFormErrorsProvider.notifier)
        .remove(LeadFormFields.amountCollected);
  }

  @override
  WidgetRef get eventRef => ref;
}
