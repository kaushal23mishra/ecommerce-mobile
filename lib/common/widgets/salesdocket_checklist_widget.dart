import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/check_list_item.dart';
import 'package:salesdocket_mobile/common/widgets/check_box_widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketChecklistWidget<T> extends SalesdocketStatelessWidget {
  final List<CheckListItem<T>> items;
  final List<T>? selectedItems;
  final Function(List<T>) onChanged;
  final bool isMultiSelect;
  final bool enableScroll;
  final String? label;
  final String? error;
  final bool isRequired;

  const SalesdocketChecklistWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItems,
    this.isMultiSelect = true,
    this.enableScroll = false,
    this.label,
    this.error,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          _buildLabel(context),
        CheckListWidget<T>(
          items: items,
          onChanged: onChanged,
          selectedItems: selectedItems,
          isMultiSelect: isMultiSelect,
          enableScroll: enableScroll,
        ),
        if (error != null && error!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              "$error",
              style: Theme
                  .of(
                context,
              )
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: appColors.error),
            ),
          ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    final labelText = label ?? "";
    final defaultStyle = Theme
        .of(context)
        .textTheme
        .titleMedium;

    if (isRequired) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: labelText, style: defaultStyle),
            TextSpan(
              text: ' *',
              style: defaultStyle?.copyWith(color: appColors.accent),
            ),
          ],
        ),
      );
    }

    return Text(labelText, style: defaultStyle);
  }
}

class CheckListWidget<T> extends SalesdocketStatelessWidget {
  final List<CheckListItem<T>> items;
  final List<T>? selectedItems;
  final Function(List<T>) onChanged;
  final bool isMultiSelect;
  final bool enableScroll;

  const CheckListWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItems,
    this.isMultiSelect = true,
    this.enableScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: ListView.builder(
        shrinkWrap: !enableScroll,
        physics: enableScroll ? null : const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isChecked = selectedItems?.contains(item.key) ?? false;

          return CheckBoxWidget(
            isChecked: isChecked,
            label: item.value,
            onCheckChanged: (value) {
              final newSelectedChips = selectedItems?.toList() ?? [];
              if (!isMultiSelect) {
                newSelectedChips.clear();
              }

              if (isChecked) {
                newSelectedChips.remove(item.key);
              } else {
                newSelectedChips.add(item.key);
              }

              onChanged(
                isMultiSelect
                    ? newSelectedChips
                    : newSelectedChips.isEmpty
                    ? []
                    : [newSelectedChips.first],
              );
            },
          );
        },
      ),
    );
  }
}
