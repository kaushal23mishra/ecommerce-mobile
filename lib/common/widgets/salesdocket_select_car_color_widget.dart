import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSelectCarColorWidget extends SalesdocketConsumerWidget {
  final int? selectedColorId;
  final int? selectedVariantId;
  final FormFieldError? error;
  final Function(int?) onColorSelected;
  final int? organisationId;
  final bool isRequired;

  const SalesdocketSelectCarColorWidget({
    super.key,
    this.selectedColorId,
    this.selectedVariantId,
    this.error,
    required this.onColorSelected,
    this.organisationId,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carColors =
        (ref.watch(productProvider)?.colors ?? [])
            .where((product) => product.organizationId == organisationId)
            .toList();

    return SalesDocketDropDownWidget(
      text: LocaleKeys.selectColor.tr(),
      isRequired: isRequired,
      itemList: carColors.map((item) => item.color ?? "").toList(),
      itemValue:
          carColors
              .firstWhereOrNull((color) => color.id == selectedColorId)
              ?.color,
      imagePath: Assets.svg.arrowDown.path,
      errorText: error?.message,
      onChanged: (selected) {
        final newColorId =
            carColors.firstWhere((car) => car.color == selected).id;
        if (newColorId != selectedColorId) {
          onColorSelected(newColorId);
        }
      },
    );
  }
}
