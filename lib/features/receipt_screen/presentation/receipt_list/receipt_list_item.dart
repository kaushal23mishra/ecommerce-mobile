import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ReceiptListItem extends SalesdocketStatelessWidget {
  final Receipt receipt;
  final Function onEditClicked;
  final bool canEdit;

  const ReceiptListItem({
    super.key,
    required this.receipt,
    required this.onEditClicked,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: 1.h,
              children:
                  receiptItems
                      .map(
                        (item) => Row(
                          children: [
                            Text(
                              "${item.title} :  ",
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: appColors.primary,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              item.subtitle ?? "",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
          if (canEdit)
            GestureDetector(
              onTap: () {
                onEditClicked();
              },
              child: SizedBox(
                width: 8.w,
                height: 8.w,
                child: Icon(Icons.edit, size: 6.w, color: appColors.disabled),
              ),
            ),
        ],
      ),
    );
  }

  List<MenuItem> get receiptItems {
    return [
      MenuItem(
        title: LocaleKeys.receiptNameOrNo.tr(),
        subtitle: receipt.receiptNo,
      ),
      MenuItem(
        title: LocaleKeys.receiptDate.tr(),
        subtitle: receipt.date?.formatDateTime(),
      ),
      MenuItem(
        title: LocaleKeys.receiptAmount.tr(),
        subtitle: "${receipt.amount ?? ""}",
      ),
      MenuItem(
        title: LocaleKeys.modeOfPayment.tr(),
        subtitle: receipt.paymentMode,
      ),
      MenuItem(
        title: LocaleKeys.chequePermittedBy.tr(),
        subtitle: receipt.permittedBy,
      ),
      MenuItem(title: LocaleKeys.receiptType.tr(), subtitle: receipt.type),
    ].filteredNonEmptyItems;
  }
}
