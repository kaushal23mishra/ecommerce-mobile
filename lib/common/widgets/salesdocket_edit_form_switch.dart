import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketEditFormSwitch extends SalesdocketStatelessWidget {
  final Function(bool) onChanged;
  final bool isInEditMode;
  final Widget form;
  final String? label;

  const SalesdocketEditFormSwitch({
    super.key,
    this.isInEditMode = false,
    required this.onChanged,
    required this.form,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SalesdocketSwitchWidget(
          mainAxisAlignment: MainAxisAlignment.end,
          label: label ?? LocaleKeys.edit.tr(),
          onChanged: (value) => onChanged(value),
          value: isInEditMode,
          show: true,
        ),
        isInEditMode ? form : const SizedBox.shrink(),
      ],
    );
  }
}
