import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class TypeOfCustomersWidget extends SalesdocketConsumerWidget {
  const TypeOfCustomersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerType = ref.watch(
      prospectLeadRequestProvider.select((state) => state?.customerType),
    );
    final error = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.typeOfCustomer);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketChipWidget(
          label: LocaleKeys.lblTypeOfCustomer.tr(),
          isRequired: true,
          chips: CustomerType.values.map((status) => status.value).toList(),
          selectedChips: [customerType],
          errorText: error?.message,
          onSelected: (selected) {
            final newValue = selected?.firstOrNull;
            if (newValue != null) {
              ref
                  .read(prospectLeadRequestProvider.notifier)
                  .update(
                    (state) =>
                        state = state?.copyWith(
                          customerType: newValue,
                          corporateName: "",
                        ),
                  );
              ref
                  .read(prospectFormErrorsProvider.notifier)
                  .remove(LeadFormFields.typeOfCustomer);
            }
          },
        ),
        _corporateNameWidget(context, ref),
      ],
    );
  }

  Widget _corporateNameWidget(BuildContext context, WidgetRef ref) {
    final customerType = ref.watch(
      prospectLeadRequestProvider.select((state) => state?.customerType),
    );
    final corporateName = ref.watch(
      prospectLeadRequestProvider.select((state) => state?.corporateName),
    );
    final error = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.corporateName);

    return customerType == CustomerType.corporate.value
        ? Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: SalesDocketInputWidget(
            initialValue: corporateName,
            maxLength: 25,
            inputType: TextInputType.text,
            label: "${LocaleKeys.lblCorporate.tr()} ${LocaleKeys.name.tr()}",
            hint: "${LocaleKeys.lblCorporate.tr()} ${LocaleKeys.name.tr()}",
            isRequired: true,
            onChanged: (value) {
              ref
                  .read(prospectLeadRequestProvider.notifier)
                  .update(
                    (state) => state = state?.copyWith(corporateName: value),
                  );
              ref
                  .read(prospectFormErrorsProvider.notifier)
                  .remove(LeadFormFields.corporateName);
            },
            errorMsg: error?.message,
          ),
        )
        : const SizedBox.shrink();
  }
}
