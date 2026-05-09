import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadListMenuWidget extends StatelessWidget {
  final List<LeadListMenuMoreAction> menuItems;

  const LeadListMenuWidget({super.key, this.menuItems = const []});

  @override
  Widget build(BuildContext context) {
    return SalesdocketMenuBottomSheet(items: _menuItems, hasClose: true);
  }

  List<BottomSheetItem> get _menuItems {
    return [
      _downloadExcel,
      _transferLeads,
    ].where((item) => menuItems.contains(item.key)).toList();
  }

  BottomSheetItem get _downloadExcel => BottomSheetItem(
    text: LocaleKeys.downloadExcel.tr(),
    key: LeadListMenuMoreAction.downloadExcel,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.svg.icDownload.path,
      width: 5.w,
    ),
  );

  BottomSheetItem get _transferLeads => BottomSheetItem(
    text: "Transfer Leads",
    key: LeadListMenuMoreAction.transferLeads,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.svg.transfer.path,
      width: 5.w,
    ),
  );
}
