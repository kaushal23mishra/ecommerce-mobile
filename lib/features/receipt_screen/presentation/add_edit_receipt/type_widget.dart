import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class TypeWidget extends SalesdocketConsumerWidget {
  const TypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptType = ref.watch(
      sendReceiptRequestProvider.select((state) => state?.type),
    );

    return SalesDocketInputWidget(
      label: LocaleKeys.lblReceiptType.tr(),
      hint: LocaleKeys.lblReceiptType.tr(),
      initialValue: receiptType,
      enable: false,
      viewOnly: true,
    );
  }
}
