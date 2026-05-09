import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketMediaMenuWidget extends SalesdocketStatelessWidget {
  final bool hasPreview;

  const SalesdocketMediaMenuWidget({super.key, this.hasPreview = true});

  @override
  Widget build(BuildContext context) {
    return SalesdocketMenuBottomSheet(items: _menuItems, hasClose: true);
  }

  List<BottomSheetItem> get _menuItems {
    final items = [_cameraItem, _galleryItem];
    if (hasPreview) {
      items.add(_previewItem);
      items.add(_removeItem);
    }

    return items;
  }

  BottomSheetItem get _galleryItem => BottomSheetItem(
    text: LocaleKeys.gallery.tr(),
    key: MediaItemMenuAction.gallery,
    iconWidget: Icon(Icons.image, color: appColors.textDisabled, size: 6.w),
  );

  BottomSheetItem get _cameraItem => BottomSheetItem(
    text: LocaleKeys.camera.tr(),
    key: MediaItemMenuAction.camera,
    iconWidget: Icon(Icons.camera, color: appColors.textDisabled, size: 6.w),
  );

  BottomSheetItem get _previewItem => BottomSheetItem(
    text: LocaleKeys.preview.tr(),
    key: MediaItemMenuAction.preview,
    iconWidget: Icon(Icons.preview, color: appColors.textDisabled, size: 6.w),
  );

  BottomSheetItem get _removeItem => BottomSheetItem(
    text: LocaleKeys.remove.tr(),
    fontColor: appColors.redDark,
    key: MediaItemMenuAction.remove,
    iconWidget: Icon(Icons.delete_outline, color: appColors.redDark, size: 6.w),
  );
}
