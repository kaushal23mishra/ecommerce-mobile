import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/ownership.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketOwnershipWidget extends SalesdocketStatelessWidget {
  final String? ownership;
  final Function(String) onChanged;
  final bool isRequired;

  const SalesdocketOwnershipWidget({
    super.key,
    this.ownership,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemList = ownershipList.map((item) => item.value).toList();
    final selected = itemList.firstWhereOrNull((item) => item == ownership);

    return SalesDocketDropDownWidget(
      text: LocaleKeys.selectOwnership.tr(),
      itemList: itemList,
      itemValue: selected,
      imagePath: Assets.svg.arrowDown.path,
      isRequired: isRequired,
      onChanged: (selected) {
        final selectedOwnership = itemList.firstWhereOrNull(
          (item) => item == selected,
        );

        if (selectedOwnership != null) {
          onChanged(selectedOwnership);
        }
      },
    );
  }
}
