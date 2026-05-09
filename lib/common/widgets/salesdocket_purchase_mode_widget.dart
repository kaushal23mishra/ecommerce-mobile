import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketPurchaseModeWidget extends SalesdocketStatelessWidget {
  final String? selectedMode;
  final Function(String) onModeChanged;
  final String? error;
  final bool isRequired;

  const SalesdocketPurchaseModeWidget({
    super.key,
    this.selectedMode,
    required this.onModeChanged,
    this.error,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return SalesDocketChipWidget(
      label: LocaleKeys.lblModeOfPurchase.tr(),
      isRequired: isRequired,
      chips: purchaseModeList.map((source) => source.value).toList(),
      selectedChips: selectedMode == null ? [] : [selectedMode ?? ""],
      errorText: error,
      onSelected: (selected) {
        final newValue = selected?.firstOrNull;
        if (newValue != null) {
          onModeChanged(newValue);
        }
      },
    );
  }
}
