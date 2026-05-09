import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/more_discount_reasons.dart';
import 'package:salesdocket_mobile/common/entity/check_list_item.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class MoreDiscountReasonWidget extends SalesdocketConsumerWidget {
  const MoreDiscountReasonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasons = MoreDiscountReasons.values;
    final discountApproval = ref.watch(discountApprovalRequestProvider);
    final prevSelected = ref.watch(moreDiscountApprovalReasonsProvider);
    final noneOfTheAbove = MoreDiscountReasons.noneOfAbove.value;
    final errors = ref.watch(discountApprovalFormErrorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketChecklistWidget(
          label: LocaleKeys.reasonForGivingMoreDiscount.tr(),
          isRequired: true,
          selectedItems: prevSelected,
          items:
              reasons
                  .map(
                    (item) => CheckListItem(key: item.value, value: item.value),
                  )
                  .toList(),
          onChanged: (selected) {
            var newValue = selected.toList();
            if (selected.contains(noneOfTheAbove)) {
              if (prevSelected.contains(noneOfTheAbove)) {
                newValue.remove(noneOfTheAbove);
              } else {
                newValue = [noneOfTheAbove];
              }
            }

            ref
                .read(discountApprovalRequestProvider.notifier)
                .update(
                  (state) => state = state?.copyWith(discountReason: null),
                );
            ref
                .read(moreDiscountApprovalReasonsProvider.notifier)
                .update((state) => state = newValue);
            ref
                .read(discountApprovalFormErrorsProvider.notifier)
                .remove(DiscountFormFields.discountReasons);
          },
          error: errors.get(DiscountFormFields.discountReasons)?.message,
        ),
        if (prevSelected.contains(noneOfTheAbove))
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketInputWidget(
              initialValue: discountApproval?.discountReason,
              label: LocaleKeys.otherReason.tr(),
              hint: LocaleKeys.otherReason.tr(),
              errorMsg:
                  errors.get(DiscountFormFields.otherDiscountReason)?.message,
              onChanged: (value) {
                ref
                    .read(discountApprovalRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(discountReason: value.trim()),
                    );
                ref
                    .read(discountApprovalFormErrorsProvider.notifier)
                    .remove(DiscountFormFields.otherDiscountReason);
              },
            ),
          ),
      ],
    );
  }
}
