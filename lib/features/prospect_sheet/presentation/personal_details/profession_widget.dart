import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/profession.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProfessionWidget extends SalesdocketConsumerStatefulWidget {
  const ProfessionWidget({super.key});

  @override
  ConsumerState<ProfessionWidget> createState() => _ProfessionWidgetState();
}

class _ProfessionWidgetState
    extends SalesdocketConsumerState<ProfessionWidget> {
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final existing = ref.read(prospectLeadRequestProvider)?.otherProfession;
    if (existing != null && existing.isNotEmpty) {
      _otherController.text = existing;
    }
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProfession = ref.watch(
      prospectLeadRequestProvider.select((state) => state?.profession),
    );
    final error = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.profession);

    final isOtherSelected = selectedProfession == Profession.other.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketDropDownWidget(
          text: LocaleKeys.lblProfession.tr(),
          isRequired: true,
          itemList: professionList,
          itemValue: selectedProfession,
          imagePath: Assets.svg.arrowDown.path,
          errorText: error?.message,
          onChanged: (value) {
            if (value != Profession.other.value) {
              _otherController.clear();
              ref
                  .read(prospectLeadRequestProvider.notifier)
                  .update((state) => state?.copyWith(
                        profession: value,
                        otherProfession: null,
                      ));
            } else {
              ref
                  .read(prospectLeadRequestProvider.notifier)
                  .update((state) => state?.copyWith(profession: value));
            }
            ref
                .read(prospectFormErrorsProvider.notifier)
                .remove(LeadFormFields.profession);
          },
        ),
        if (isOtherSelected) ...[
          SizedBox(height: 2.h),
          SalesDocketInputWidget(
            maxLength: 100,
            inputType: TextInputType.text,
            label: LocaleKeys.lblProfession.tr(),
            controller: _otherController,
            hint: LocaleKeys.enterProfession.tr(),
            errorMsg: error?.message,
            onChanged: (value) {
              ref
                  .read(prospectFormErrorsProvider.notifier)
                  .remove(LeadFormFields.profession);
              ref
                  .read(prospectLeadRequestProvider.notifier)
                  .update(
                    (state) => state?.copyWith(
                      profession: Profession.other.value,
                      otherProfession: value.trim().isNotEmpty
                          ? value.trim()
                          : null,
                    ),
                  );
            },
          ),
        ],
      ],
    );
  }
}
