import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../view_model/followup_view_model.dart';

class FollowupCustomerCommentWidget extends SalesdocketConsumerWidget {
  const FollowupCustomerCommentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remark = ref.watch(
      followupRequestProvider.select((state) => state?.remarks),
    );

    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.remarks);

    return SalesDocketInputWidget(
      initialValue: remark,
      label: "Enter Customer Comments Here...",
      hint: "Enter Customer Comments Here...",
      isRequired: true,
      onChanged: (value) {
        ref
            .read(followupRequestProvider.notifier)
            .update((state) => state?.copyWith(remarks: value.trim()));

        if (value.trim().isNotEmpty) {
          ref
              .read(createFollowUpFormErrorsProvider.notifier)
              .remove(CreateFollowUpFormFields.remarks);
        }
      },
      errorMsg: error?.message,
    );
  }
}
