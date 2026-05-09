import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/strings.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/form_field_focus_node.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_required_label.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class NameWidget extends SalesdocketConsumerWidget {
  const NameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSalutation = ref.watch(
      leadRequestProvider.select((lead) => lead?.salutation),
    );
    final firstName = ref.watch(
      leadRequestProvider.select((lead) => lead?.firstName),
    );
    final lastName = ref.watch(
      leadRequestProvider.select((lead) => lead?.lastName),
    );
    final isEdit = ref.watch(
      leadRequestProvider.select((lead) => lead?.isEdit),
    );
    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.fullName);
    final fullName = [
      if (firstName?.isNotEmpty ?? false) firstName,
      if (lastName?.isNotEmpty ?? false) lastName,
    ].join(' ');
    final node = ref
        .watch(createLeadFormFocusNodesProvider)
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
                      .read(leadRequestProvider.notifier)
                      .update(
                        (lead) => lead = lead?.copyWith(salutation: selected),
                      );
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: SalesDocketInputWidget(
                // enable: isEdit != null ? false : true,
                maxLength: 50,
                inputType: TextInputType.text,
                // inputFormatters: InputFormatters.name,
                hint: LocaleKeys.lblFullName.tr(),
                isRequired: true,
                errorMsg: error?.message,
                initialValue: fullName,
                focusNode: node?.focusNode,
                onFieldSubmitted: (_) {
                  loggy.debug("On Name Saved");
                  ref
                      .read(createLeadFormFocusNodesProvider.notifier)
                      .focusNext(context, field: LeadFormFields.fullName);
                },
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
                    lastname = null;
                  }

                  ref
                      .read(leadRequestProvider.notifier)
                      .update(
                        (lead) =>
                            lead = lead?.copyWith(
                              firstName: firstname?.trim(),
                              lastName: lastname?.trim(),
                            ),
                      );
                  ref
                      .read(createLeadFormErrorsProvider.notifier)
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
