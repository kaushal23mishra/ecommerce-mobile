import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/tyre_replacement.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketTyreReplacementWidget extends SalesdocketStatelessWidget {
  final ExchangeProduct? exchangeCar;
  final Function(ExchangeProduct?)? onChanged;
  final Function(bool)? onEditTyreReplacementChanged;
  final bool canEditTyre;

  const SalesdocketTyreReplacementWidget({
    super.key,
    this.exchangeCar,
    this.onChanged,
    this.onEditTyreReplacementChanged,
    this.canEditTyre = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTyres = exchangeCar?.tyreReplacement?.split(",") ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.tyreReplacement.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: canEditTyre,
                onChanged: (value) {
                  if (onEditTyreReplacementChanged != null) {
                    onEditTyreReplacementChanged!(value);
                  }
                },
                activeTrackColor: appColors.primary,
              ),
            ),
          ],
        ),
        canEditTyre
            ? Padding(
              padding: EdgeInsets.only(top: 0.25.h),
              child: SalesDocketChipWidget(
                chips:
                    tyreReplacementList
                        .map((source) => source.value.formatTyreText)
                        .toList(),
                selectedChips:
                    selectedTyres
                        .map((source) => source.formatTyreText)
                        .toList(),
                isMultiSelect: true,
                onSelected: (selected) {
                  if (onChanged != null) {
                    final newValue = exchangeCar?.copyWith(
                      tyreReplacement: selected
                          ?.map((item) => item.revertTyreText)
                          .join(","),
                    );
                    onChanged!(newValue);
                  }
                },
              ),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
