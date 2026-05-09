import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PendingCommitmentsWidget extends SalesdocketConsumerWidget {
  const PendingCommitmentsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryDiscountApproval = ref.watch(deliveryApprovalRequestProvider);
    final error = ref
        .watch(discountApprovalFormErrorsProvider)
        .get(DiscountFormFields.pendingCommitments);

    return SalesDocketInputWidget(
      label: LocaleKeys.pendingCommitments.tr(),
      hint: LocaleKeys.pendingCommitments.tr(),
      initialValue: deliveryDiscountApproval?.pendingCommitment,
      maxLines: 4,
      inputType: TextInputType.multiline,
      onChanged: (newValue) {
        ref
            .read(deliveryApprovalRequestProvider.notifier)
            .update(
              (state) =>
                  state = state?.copyWith(pendingCommitment: newValue.trim()),
            );
        ref
            .read(discountApprovalFormErrorsProvider.notifier)
            .remove(DiscountFormFields.pendingCommitments);
      },
      errorMsg: error?.message,
    );
  }
}
