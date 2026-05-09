import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/car_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_searchable_dropdown_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSelectEngineTypeWidget
    extends SalesdocketConsumerStatefulWidget {
  final int? selectedModelId;
  final String? selectedEngine;
  final FormFieldError? error;
  final Function(String?) onEngineSelected;
  final FocusNode? focusNode;

  const SalesdocketSelectEngineTypeWidget({
    super.key,
    this.selectedModelId,
    this.selectedEngine,
    this.error,
    required this.onEngineSelected,
    this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectEngineTypeState();
}

class _SelectEngineTypeState
    extends SalesdocketConsumerState<SalesdocketSelectEngineTypeWidget>
    with CarEvents {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchEngineTypes(modelId: widget.selectedModelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemList = ref
        .watch(engineTypesProvider)
        .map((e) => e.engineType ?? '')
        .toSet()
        .toList();

    return SalesdocketSearchableDropdownWidget<String>(
      label: LocaleKeys.lblSelectEngineType.tr(),
      isRequired: true,
      selectedItem: widget.selectedEngine,
      focusNode: widget.focusNode,
      items: itemList,
      itemAsString: (item) => item,
      compareFn: (a, b) => a == b,
      errorText: widget.error?.message,
      onChanged: (selected) {
        if (selected != widget.selectedEngine) {
          widget.onEngineSelected(selected);
          fetchVariants(
            modelId: widget.selectedModelId,
            engineType: selected,
          );
        }
      },
    );
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
