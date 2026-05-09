import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class RemarksWidget extends SalesdocketConsumerWidget {
  const RemarksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remarksError = ref
        .watch(reactivateLeadFormErrorsProvider)
        .get(LeadFormFields.remarks);

    return SalesDocketInputWidget(
      errorMsg: remarksError?.message,
      label: LocaleKeys.typeRemarksHere.tr(),
      hint: LocaleKeys.typeRemarksHere.tr(),
      inputType: TextInputType.multiline,
      maxLines: 4,
      isRequired: true,
      validator: validateEmptyInput,
      onChanged: (value) {
        ref
            .read(createLeadHistoryRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(remarks: value.trim()),
            );
        ref
            .read(reactivateLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.remarks);
      },
    );
  }
}
