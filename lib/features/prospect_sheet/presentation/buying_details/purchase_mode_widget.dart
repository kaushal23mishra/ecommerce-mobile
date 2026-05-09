import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_purchase_mode_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PurchaseModeWidget extends SalesdocketConsumerWidget {
  const PurchaseModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(
      prospectLeadRequestProvider.select((state) => state?.purchaseMode),
    );
    final errors = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.modeOfPurchase);

    return SalesdocketPurchaseModeWidget(
      selectedMode: selectedMode,
      error: errors?.message,
      isRequired: true,
      onModeChanged: (value) {
        ref
            .read(prospectLeadRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(purchaseMode: value),
            );
        ref
            .read(prospectFormErrorsProvider.notifier)
            .remove(LeadFormFields.modeOfPurchase);
      },
    );
  }
}
