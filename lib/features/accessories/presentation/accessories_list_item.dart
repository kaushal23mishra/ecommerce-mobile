import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AccessoriesListItem extends SalesdocketConsumerWidget {
  final Accessory accessory;
  final VoidCallback? onRemoved;
  const AccessoriesListItem({
    super.key,
    required this.accessory,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccessories = ref.watch(selectedAccessoriesProvider).toList();
    final isSelected = selectedAccessories.any(
      (toCheck) => toCheck.name == accessory.name,
    );

    return Column(
      children: [
        Row(
          children: [
            horizontalSpacing(2.w),
            Expanded(
              child: Text(
                accessory.name?.sentenceToCamelCase ?? "N/A",
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SalesdocketSwitchWidget(
              value: isSelected,
              label: "${accessory.priceMrp ?? ""}",
              onChanged: (value) => _onSwitchChanged(value, ref),
              // onChanged: (value) async {
              //   if (isSelected) {
              //     selectedAccessories.remove(accessory);
              //   } else {
              //     selectedAccessories.add(accessory);
              //   }
              //
              //   ref
              //       .read(selectedAccessoriesProvider.notifier)
              //       .update((state) => state = selectedAccessories);
              // },
            ),
          ],
        ),
      ],
    );
  }

  void _onSwitchChanged(bool value, WidgetRef ref) {
    final selectedAccessories = ref.read(selectedAccessoriesProvider).toList();

    if (value) {
      selectedAccessories.add(accessory);
    } else {
      selectedAccessories.removeWhere((a) => a.name == accessory.name);
      // Call the removal callback if provided
      onRemoved?.call();
    }

    ref.read(selectedAccessoriesProvider.notifier).state = selectedAccessories;
  }
}
