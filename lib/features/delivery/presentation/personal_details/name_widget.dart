import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/constants/strings.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/delivery_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_required_label.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class NameWidget extends SalesdocketConsumerWidget {
  const NameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSalutation = ref.watch(
      selectedDeliveryProvider.select((state) => state?.salutation),
    );
    final fullName =
        ref
            .watch(selectedDeliveryProvider.select((state) => state))
            ?.fullNameWOSalutation ?? ref.read(deliveryLeadRequestProvider)?.deliveryFullNameWOSalutation;
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.fullName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketRequiredLabel(
          text: LocaleKeys.lblFullName.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.w,
          children: [
            Expanded(
              flex: 2,
              child: SalesDocketDropDownWidget(
                imagePath: Assets.svg.arrowDown.path,
                itemList: CommonString.salutations,
                itemValue: selectedSalutation,
                hintText: LocaleKeys.lblTitle.tr(),
                onChanged: (selected) {
                  ref
                      .read(selectedDeliveryProvider.notifier)
                      .update(
                        (state) =>
                            state = state?.copyWith(salutation: selected),
                      );
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: SalesDocketInputWidget(
                maxLength: 50,
                inputType: TextInputType.text,
                hint: LocaleKeys.lblFullName.tr(),
                isRequired: true,
                initialValue: fullName ?? "",
                errorMsg: error?.message,
                inputFormatters: InputFormatters.name,
                onChanged: (value) {
                  String? firstname;
                  String? lastname;
                  final newValue = value.trim();
                  final nameValues = newValue.split(" ");

                  final size = nameValues.length;
                  if (size > 1) {
                    lastname = nameValues.removeLast();
                    firstname = nameValues.join(" ");
                  } else {
                    firstname = newValue;
                  }

                  ref
                      .read(selectedDeliveryProvider.notifier)
                      .update(
                        (state) =>
                            state = state?.copyWith(
                              firstName: firstname?.trim(),
                              lastName: lastname?.trim(),
                            ),
                      );
                  ref
                      .read(deliveryFormErrorsProvider.notifier)
                      .remove(LeadFormFields.fullName);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
