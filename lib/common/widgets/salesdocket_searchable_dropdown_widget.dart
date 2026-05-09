import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSearchableDropdownWidget<T> extends SalesdocketStatelessWidget {
  final String label;
  final bool isRequired;
  final bool enabled;
  final T? selectedItem;
  final String? placeholder;
  final List<T> items;
  final String Function(T) itemAsString;
  final bool Function(T, T) compareFn;
  final void Function(T?) onChanged;
  final String? errorText;
  final FocusNode? focusNode;

  const SalesdocketSearchableDropdownWidget({
    super.key,
    required this.label,
    required this.items,
    required this.itemAsString,
    required this.compareFn,
    required this.onChanged,
    this.selectedItem,
    this.placeholder,
    this.isRequired = false,
    this.enabled = true,
    this.errorText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: appColors.accent),
                ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        DropdownSearch<T>(
          enabled: enabled,
          selectedItem: selectedItem,
          items: (filter, _) {
            final query = filter.trim();
            if (query.length < 3) return items;
            return items
                .where((item) => itemAsString(item)
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
          },
          itemAsString: itemAsString,
          compareFn: compareFn,
          onChanged: onChanged,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            constraints: BoxConstraints(maxHeight: 40.h),
            searchFieldProps: TextFieldProps(
              autofocus: true,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: LocaleKeys.lblKeyword.tr(),
                hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: appColors.grayDark,
                    ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: appColors.inputBorder, width: 0.1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: appColors.inputBorder, width: 0.1.w),
                ),
                filled: true,
                fillColor: appColors.inputBackground,
                isDense: true,
              ),
            ),
            emptyBuilder: (ctx, _) => Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: Text(
                  LocaleKeys.noDataAvailable.tr(),
                  style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                        color: appColors.grayDark,
                      ),
                ),
              ),
            ),
            itemBuilder: (ctx, item, isDisabled, isSelected) => Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              color: isSelected ? appColors.primaryLight : appColors.secondary,
              child: Text(
                itemAsString(item),
                style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? appColors.primary
                          : appColors.textPrimary,
                    ),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.w),
                borderSide: BorderSide(
                  color: hasError ? appColors.error : appColors.inputBorder,
                  width: 0.1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.w),
                borderSide:
                    BorderSide(color: appColors.inputBorder, width: 0.1.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.w),
                borderSide: BorderSide(color: appColors.error, width: 0.1.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.w),
                borderSide:
                    BorderSide(color: appColors.inputBorder, width: 0.1.w),
              ),
              filled: true,
              fillColor: appColors.secondary,
              errorText: errorText,
              isDense: true,
            ),
          ),
          dropdownBuilder: (ctx, selected) => Text(
            selected != null ? itemAsString(selected) : (placeholder ?? label),
            style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                  color: selected != null
                      ? appColors.textPrimary
                      : appColors.grayDark,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
