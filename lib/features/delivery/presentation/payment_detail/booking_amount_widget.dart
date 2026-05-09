import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingAmountWidget extends SalesdocketConsumerWidget {
  const BookingAmountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref
        .watch(deliveryReceiptsProvider)
        .filteredReceipts(type: ReceiptType.booking);

    return Row(
      spacing: 3.w,
      children: [
        Container(
          constraints: BoxConstraints(minWidth: 17.w),
          child: Text(
            LocaleKeys.booking.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
                  decoration: BoxDecoration(
                    color: appColors.secondary,
                    borderRadius: BorderRadius.circular(1.w),
                    border: Border.all(color: appColors.disabled, width: 0.1.w),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      //   child: Text(
                      //     receipts.modeOfPayments.join(", "),
                      //     style: Theme.of(context).textTheme.titleSmall,
                      //   ),
                      // ),
                      // horizontalSpacing(4.w),
                      Text(
                        receipts.amount.formatIndianCommas,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              horizontalSpacing(3.w),
              receipts.amount.formatIndianCommas.parseIndianNumber() > 0
                  ? GestureDetector(
                    onTap: () {
                      _moveToReceiptsScreen(context, ref);
                    },
                    child: SizedBox(
                      width: 8.w,
                      child: Icon(Icons.info, color: appColors.info, size: 6.w),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  void _moveToReceiptsScreen(BuildContext context, WidgetRef ref) {
    final lead = ref.read(deliveryLeadRequestProvider);
    ref.read(canEditReceiptProvider.notifier).update((state) => state = false);
    ref.read(receiptLeadProvider.notifier).update((state) => state = lead);
    ref
        .read(receiptSourceProvider.notifier)
        .update((state) => state = ReceiptType.booking);
    context.router.push(const ReceiptListRoute());
  }
}
