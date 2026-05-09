import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/share_document_type.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ShareDocumentTypeMenuBottomSheet extends SalesdocketConsumerWidget {
  const ShareDocumentTypeMenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SalesdocketMenuBottomSheet(items: _menuItems, hasClose: true);
  }

  List<BottomSheetItem> get _menuItems {
    final items = [
      _smsItem,
      _emailItem,
      //_whatsappItem
    ];

    return items;
  }

  BottomSheetItem get _smsItem => BottomSheetItem(
    text: ShareDocumentType.sms.value,
    key: ShareDocumentType.sms,
    iconWidget: Icon(Icons.sms_outlined, size: 5.w),
  );

  BottomSheetItem get _emailItem => BottomSheetItem(
    text: ShareDocumentType.email.value,
    key: ShareDocumentType.email,
    iconWidget: Icon(Icons.email_outlined, size: 5.w),
  );

  BottomSheetItem get _whatsappItem => BottomSheetItem(
    text: ShareDocumentType.whatsapp.value,
    key: ShareDocumentType.whatsapp,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.svg.whatsapp.path,
      width: 5.w,
    ),
  );
}
