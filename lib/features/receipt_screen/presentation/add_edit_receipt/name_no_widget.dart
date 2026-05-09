import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class NameNoWidget extends SalesdocketConsumerStatefulWidget {
  const NameNoWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NameNoState();
}

class _NameNoState extends SalesdocketConsumerState<NameNoWidget> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = ref.read(sendReceiptRequestProvider);
      _nameController.text = request?.receiptNo ?? "";
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = ref
        .watch(receiptFormErrorsProvider)
        .get(ReceiptFormFields.receiptName);
    ref.listen<Receipt?>(sendReceiptRequestProvider, _requestListener);

    return SalesDocketInputWidget(
      label: LocaleKeys.receiptNameOrNo.tr(),
      hint: LocaleKeys.receiptNameOrNo.tr(),
      isRequired: true,
      controller: _nameController,
      onChanged: (value) {
        ref
            .read(sendReceiptRequestProvider.notifier)
            .update(
              (state) => state = state?.copyWith(receiptNo: value.trim()),
            );
        ref
            .read(receiptFormErrorsProvider.notifier)
            .remove(ReceiptFormFields.receiptName);
      },
      errorMsg: error?.message,
    );
  }

  void _requestListener(Receipt? previous, Receipt? next) {
    if (previous?.receiptNo != next?.receiptNo) {
      _nameController.text = next?.receiptNo ?? "";
    }
  }
}
