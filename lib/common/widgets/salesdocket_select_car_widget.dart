import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_engine_type_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_model_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_variant_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_selected_variants_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSelectCarWidget extends SalesdocketStatelessWidget {
  final bool canEdit;
  final InterestedVariant? selectedCar;
  final List<InterestedVariant> selectedVariants;
  final Function(InterestedVariant)? onVariantRemoved;
  final bool editCarDetails;
  final Function(bool)? onEditCarDetailsChanged;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;

  const SalesdocketSelectCarWidget({
    super.key,
    this.selectedCar,
    this.canEdit = true,
    this.editCarDetails = false,
    this.onEditCarDetailsChanged,
    this.errors = const {},
    this.onChanged,
    this.selectedVariants = const [],
    this.onVariantRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _editSwitchWidget(context),
        editCarDetails
            ? Column(
              spacing: 2.h,
              children: [
                _modelWidget,
                _engineTypeWidget,
                _variantWidget,
                _selectedVariantsWidget,
              ],
            )
            : _carDetailsWidget(context),
      ],
    );
  }

  Widget _editSwitchWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, bottom: canEdit ? 0 : 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              LocaleKeys.lblInterestedIn.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (canEdit)
            SalesdocketSwitchWidget(
              label: LocaleKeys.edit.tr(),
              value: editCarDetails,
              onChanged: (value) {
                if (onEditCarDetailsChanged != null) {
                  onEditCarDetailsChanged!(value);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _carDetailsWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: appColors.primaryLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.3.w),
      ),
      child: Text(
        selectedVariants.map((variant) => variant.carName).join("\n"),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
      ),
    );
  }

  Widget get _modelWidget {
    final selectedModelId = selectedCar?.productId;

    return SalesdocketSelectModelWidget(
      selectedModelId: selectedModelId,
      error: errors[LeadFormFields.selectModel],
      onModelSelected: (key, value) {
        if (onChanged != null) {
          onChanged!(LeadFormFields.selectModel, key, value);
        }
      },
    );
  }

  Widget get _engineTypeWidget {
    final selectedModelId = selectedCar?.productId;
    final selectedEngineType = selectedCar?.engineType;

    return SalesdocketSelectEngineTypeWidget(
      selectedModelId: selectedModelId,
      selectedEngine: selectedEngineType,
      error: errors[LeadFormFields.selectEngineType],
      onEngineSelected: (selected) {
        if (onChanged != null) {
          onChanged!(LeadFormFields.selectEngineType, selected, null);
        }
      },
    );
  }

  Widget get _variantWidget {
    final selectedVariant = selectedCar?.id;

    return SalesdocketSelectVariantWidget(
      selectedVariantId: selectedVariant,
      error: errors[LeadFormFields.selectVariant],
      onVariantSelected: (key, value) {
        if (onChanged != null) {
          onChanged!(LeadFormFields.selectVariant, key, value);
        }
      },
    );
  }

  Widget get _selectedVariantsWidget {
    return SalesdocketSelectedVariantsWidget(
      variants: selectedVariants,
      onRemoved: onVariantRemoved,
    );
  }
}
