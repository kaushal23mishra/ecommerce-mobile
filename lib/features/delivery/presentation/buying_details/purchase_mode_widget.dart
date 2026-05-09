import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/purchase_mode_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_finance_from_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_image_container.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_purchase_mode_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PurchaseModeWidget extends SalesdocketConsumerWidget {
  const PurchaseModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(
      deliveryLeadRequestProvider.select((state) => state?.purchaseMode),
    );
    final selectedBooking = ref.watch(selectedBookingProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(deliveryFormErrorsProvider).get(field);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketPurchaseModeWidget(
          selectedMode: selectedMode,
          error: errors[LeadFormFields.modeOfPurchase]?.message,
          onModeChanged: (value) {
            ref
                .read(deliveryLeadRequestProvider.notifier)
                .update(
                  (toUpdate) =>
                      toUpdate = toUpdate?.copyWith(purchaseMode: value),
                );
            ref.read(selectedBookingProvider.notifier).update(
              (toUpdate) => toUpdate?.copyWith(purchaseMode: value),
            );
            resetPurchaseModeFields(ref.read(selectedBookingProvider.notifier));
            ref
                .read(deliveryFormErrorsProvider.notifier)
                .remove(LeadFormFields.modeOfPurchase);
          },
        ),
        if (selectedMode == PurchaseMode.po.value)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SalesdocketImageContainer(
                  title: LocaleKeys.lblPoPhoto.tr(),
                  path: selectedBooking?.poPhoto,
                  height: 45.w,
                  isRequired: true,
                  onImageChanged: (file) {
                    ref.read(selectedBookingProvider.notifier).update(
                      (state) => state?.copyWith(poPhoto: file?.path),
                    );
                    ref
                        .read(deliveryFormErrorsProvider.notifier)
                        .remove(LeadFormFields.poPhoto);
                  },
                ),
                if ((errors[LeadFormFields.poPhoto]?.message ?? "").isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
                    child: Text(
                      errors[LeadFormFields.poPhoto]!.message!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: appColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (selectedMode == PurchaseMode.finance.value)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesdocketFinanceFromWidget.booking(
              booking: selectedBooking,
              onChanged: (field, key, value) {
                _onValueChanged(field, key, value, ref);
              },
              errors: errors,
              showDisbursalAmount: true,
            ),
          ),
        if (selectedMode == PurchaseMode.finance.value &&
            selectedBooking?.financeType == FinanceForm.dO.value)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SalesdocketImageContainer(
                  title: LocaleKeys.lblDoPhoto.tr(),
                  path: selectedBooking?.doPhoto,
                  height: 45.w,
                  isRequired: true,
                  onImageChanged: (file) {
                    ref.read(selectedBookingProvider.notifier).update(
                      (state) => state?.copyWith(doPhoto: file?.path),
                    );
                    ref
                        .read(deliveryFormErrorsProvider.notifier)
                        .remove(LeadFormFields.doPhoto);
                  },
                ),
                if ((errors[LeadFormFields.doPhoto]?.message ?? "").isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
                    child: Text(
                      errors[LeadFormFields.doPhoto]!.message!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: appColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(deliveryFormErrorsProvider.notifier).remove(field);
    applyPurchaseModeFieldChange(
      field,
      key,
      value,
      ref.read(selectedBookingProvider.notifier),
    );
  }

  get _formFields => [
    LeadFormFields.financeType,
    LeadFormFields.disbursalAmount,
    LeadFormFields.financeReason,
    LeadFormFields.dsaName,
    LeadFormFields.dsaMobile,
    LeadFormFields.financeTypeOther,
    LeadFormFields.poPhoto,
    LeadFormFields.doPhoto,
  ];
}
