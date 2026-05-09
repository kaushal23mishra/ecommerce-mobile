import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/car_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_searchable_dropdown_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSelectModelWidget extends SalesdocketConsumerStatefulWidget {
  final String? label;
  final int? selectedModelId;
  final String? selectedModel;
  final FormFieldError? error;
  final Function(int?, String?) onModelSelected;
  final bool onlyModel;
  final String? fallbackName;
  final FocusNode? focusNode;

  const SalesdocketSelectModelWidget({
    super.key,
    this.label,
    this.selectedModelId,
    this.selectedModel,
    this.fallbackName,
    this.error,
    required this.onModelSelected,
    this.onlyModel = false,
    this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectModelWidgetState();
}

class _SelectModelWidgetState
    extends SalesdocketConsumerState<SalesdocketSelectModelWidget>
    with CarEvents {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchLeadModels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(modelsProvider);

    final selectedModel = models.firstWhereOrNull(
      (model) =>
          model.productId == widget.selectedModelId ||
          model.productName == widget.selectedModel,
    );

    return SalesdocketSearchableDropdownWidget<Product>(
      label: widget.label ?? LocaleKeys.lblSelectModel.tr(),
      isRequired: true,
      selectedItem: selectedModel,
      placeholder: widget.fallbackName,
      focusNode: widget.focusNode,
      items: models,
      itemAsString: (item) => item.productName ?? '',
      compareFn: (a, b) => a.productId == b.productId,
      errorText: widget.error?.message,
      onChanged: (selected) {
        if (selected == null) return;
        widget.onModelSelected(selected.productId, selected.productName);
        if (!widget.onlyModel && selected.productId != null) {
          ref.invalidate(variantsProvider);
          fetchEngineTypes(modelId: selected.productId!);
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
