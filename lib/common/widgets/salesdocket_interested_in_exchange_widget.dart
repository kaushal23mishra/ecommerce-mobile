import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketInterestedInExchangeWidget extends SalesdocketStatelessWidget {
  final int? interestedInExchange;
  final Function(int)? onStatusChanged;
  final String? error;
  final bool isEnabled;
  final bool isRequired;

  const SalesdocketInterestedInExchangeWidget({
    super.key,
    this.interestedInExchange,
    this.onStatusChanged,
    this.error,
    this.isEnabled = true,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final selected = getInterestedInExchangeLabel(interestedInExchange);

    final allChips =
        interestedInExchangeStateList.map((value) => value.label).toList();
    final disabledChips = isEnabled ? <String>[] : allChips;

    return SalesDocketChipWidget<String>(
      label: LocaleKeys.interestedInExchange.tr(),
      isRequired: isRequired,
      chips: allChips,
      selectedChips: selected == null ? [] : [selected],
      disabledChips: disabledChips,
      onSelected: (selected) {
        final newValue = selected?.firstOrNull;
        if (newValue != null && onStatusChanged != null && isEnabled) {
          onStatusChanged!(getInterestedInExchangeValue(newValue));
        }
      },
      errorText: error,
    );
  }
}
