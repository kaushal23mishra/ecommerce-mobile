import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/strings.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class NameWidget extends SalesdocketConsumerWidget {
  const NameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSalutation = ref.watch(
      prospectLeadRequestProvider.select((lead) => lead?.salutation),
    );
    final fullName = ref
        .watch(prospectLeadRequestProvider.select((lead) => lead))
        ?.prospectFullNameWOSalutation;
    final error =
        ref.watch(prospectFormErrorsProvider).get(LeadFormFields.fullName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.lblFullName.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        Row(
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
                  ref.read(prospectLeadRequestProvider.notifier).update(
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
                initialValue: fullName ?? "",
                isRequired: true,
                errorMsg: error?.message,
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

                  ref.read(prospectLeadRequestProvider.notifier).update(
                        (state) => state = state?.copyWith(
                          firstName: firstname?.trim(),
                          lastName: lastname?.trim(),
                        ),
                      );
                  ref
                      .read(prospectFormErrorsProvider.notifier)
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
