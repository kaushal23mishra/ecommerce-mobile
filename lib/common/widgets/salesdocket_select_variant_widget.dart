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

class SalesdocketSelectVariantWidget extends SalesdocketConsumerStatefulWidget {
  final int? selectedModelId;
  final String? selectedEngine;
  final int? selectedVariantId;
  final FormFieldError? error;
  final Function(int?, String?) onVariantSelected;
  final FocusNode? focusNode;

  const SalesdocketSelectVariantWidget({
    super.key,
    this.selectedModelId,
    this.selectedEngine,
    this.selectedVariantId,
    this.error,
    required this.onVariantSelected,
    this.focusNode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketSelectVariantState();
}

class _SalesdocketSelectVariantState
    extends SalesdocketConsumerState<SalesdocketSelectVariantWidget>
    with CarEvents {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchVariants(
        modelId: widget.selectedModelId,
        engineType: widget.selectedEngine,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemList = ref.watch(variantsProvider);

    final selected = itemList.firstWhereOrNull(
      (item) => item.variantId == widget.selectedVariantId,
    );

    return SalesdocketSearchableDropdownWidget<Product>(
      label: LocaleKeys.lblSelectVariant.tr(),
      isRequired: true,
      selectedItem: selected,
      focusNode: widget.focusNode,
      items: itemList,
      itemAsString: (item) => item.variant ?? '',
      compareFn: (a, b) => a.variantId == b.variantId,
      errorText: widget.error?.message,
      onChanged: (selected) {
        if (selected == null) return;
        widget.onVariantSelected(selected.variantId, selected.variant);
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
