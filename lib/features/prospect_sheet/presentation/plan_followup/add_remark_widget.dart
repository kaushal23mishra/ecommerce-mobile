import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AddRemarkWidget extends SalesdocketConsumerWidget {
  const AddRemarkWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remark = ref.watch(
      updatedFollowupPlanProvider.select((state) => state?.remarks),
    );
    final error = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.remarks);

    return SalesDocketInputWidget(
      initialValue: remark,
      label: LocaleKeys.lblAddCustomerRemarkHere.tr(),
      hint: LocaleKeys.lblAddCustomerRemarkHere.tr(),
      inputType: TextInputType.multiline,
      maxLines: 4,
      isRequired: true,
      onChanged: (value) {
        ref
            .read(updatedFollowupPlanProvider.notifier)
            .update((state) => state = state?.copyWith(remarks: value.trim()));
        ref
            .read(prospectFormErrorsProvider.notifier)
            .remove(LeadFormFields.remarks);
      },
      errorMsg: error?.message,
    );
  }
}
