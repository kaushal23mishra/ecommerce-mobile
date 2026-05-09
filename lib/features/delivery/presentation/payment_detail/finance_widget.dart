import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_finance_form_2_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class FinanceWidget extends SalesdocketConsumerWidget {
  const FinanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFinanceEditMode = ref.watch(isFinanceEditModeProvider);
    final booking = ref.watch(selectedBookingProvider);
    final canEdit = ref.watch(canEditDeliveryProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(deliveryFormErrorsProvider).get(field);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(minWidth: 17.w),
          padding: EdgeInsets.only(top: 1.75.h),
          child: Text(
            LocaleKeys.lblFinance.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
        horizontalSpacing(3.w),
        Expanded(
          child:
              isFinanceEditMode
                  ? SalesdocketFinanceForm2Widget(
                    booking: booking,
                    onChanged:
                        (field, key, value) =>
                            _onValueChanged(field, key, value, ref),
                    errors: errors,
                  )
                  : _viewModeWidget(context, ref),
        ),
        canEdit
            ? GestureDetector(
              onTap: () {
                ref
                    .read(isFinanceEditModeProvider.notifier)
                    .update((state) => state = !isFinanceEditMode);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 3.w, top: 1.5.h),
                child: SizedBox(
                  width: 8.w,
                  child:
                      isFinanceEditMode
                          ? Icon(
                            Icons.cancel,
                            color: appColors.redDark,
                            size: 6.w,
                          )
                          : Icon(Icons.edit, color: appColors.info, size: 6.w),
                ),
              ),
            )
            : SizedBox(width: 11.w),
      ],
    );
  }

  Widget _viewModeWidget(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(selectedBookingProvider);

    return Container(
      margin: EdgeInsets.only(top: 0.5.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.75.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(1.w),
        border: Border.all(color: appColors.disabled, width: 0.1.w),
      ),
      child: Row(
        spacing: 4.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              booking?.financeType ?? "",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Text(
            booking?.disbursalAmount?.formatIndianCommas ?? "",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(deliveryFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.financeType:
        ref
            .read(selectedBookingProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(financeType: key),
            );
        break;
      case LeadFormFields.disbursalAmount:
        ref
            .read(selectedBookingProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(disbursalAmount: key),
            );
        _setupPendingAmount(ref);
        break;
      case LeadFormFields.financeTypeOther:
        ref
            .read(selectedBookingProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(financeTypeOther: key),
            );
        break;
      default:
        break;
    }
  }

  void _setupPendingAmount(WidgetRef ref) {
    final pendingAmount =
        ref
            .read(deliveryViewModelProvider.notifier)
            .calculatePendingAmountForCreditGiven();
    ref
        .read(creditGivenProvider.notifier)
        .update(
          (state) => state = state?.copyWith(amountPending: pendingAmount),
        );
  }

  get _formFields => [
    LeadFormFields.financeType,
    LeadFormFields.disbursalAmount,
    LeadFormFields.financeTypeOther,
  ];
}
