import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PendingCommitmentWidget extends SalesdocketConsumerWidget {
  const PendingCommitmentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(selectedDeliveryProvider);
    final pendingCommitment = delivery?.pendingCommitment;
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.pendingCommitment);

    return SalesDocketInputWidget(
      initialValue: pendingCommitment,
      label: LocaleKeys.pendingCommitments.tr(),
      hint: LocaleKeys.pendingCommitments.tr(),
      onChanged: (value) {
        ref.read(selectedDeliveryProvider.notifier).update(
              (state) => state?.copyWith(pendingCommitment: value.trim()),
            );
        ref
            .read(deliveryFormErrorsProvider.notifier)
            .remove(LeadFormFields.pendingCommitment);
      },
      errorMsg: error?.message,
    );
  }
}
