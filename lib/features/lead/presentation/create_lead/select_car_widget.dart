import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/form_field_focus_node.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_engine_type_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_model_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_variant_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_selected_variants_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SelectCarWidget extends SalesdocketConsumerWidget {
  const SelectCarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 2.h,
      children: [
        _modelWidget(context, ref),
        _engineTypeWidget(context, ref),
        _variantWidget(context, ref),
        _selectedVariantsWidget(ref),
      ],
    );
  }

  Widget _modelWidget(BuildContext context, WidgetRef ref) {
    final selectedModelId = ref.watch(
      leadRequestProvider.select((lead) => lead?.model),
    );
    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.selectModel);
    final node = ref
        .watch(createLeadFormFocusNodesProvider)
        .get(LeadFormFields.selectModel);

    return SalesdocketSelectModelWidget(
      selectedModelId: selectedModelId,
      error: error,
      focusNode: node?.focusNode,
      onModelSelected: (selectedId, selected) {
        ref
            .read(leadRequestProvider.notifier)
            .update(
              (lead) =>
                  lead = lead?.copyWith(
                    model: selectedId,
                    modelName: selected,
                    engineType: null,
                    primaryVariantId: null,
                    variant: null,
                  ),
            );
        ref
            .read(createLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.selectModel);
        ref
            .read(createLeadFormFocusNodesProvider.notifier)
            .focusNext(context, field: LeadFormFields.selectEngineType);
      },
    );
  }

  Widget _engineTypeWidget(BuildContext context, WidgetRef ref) {
    final selectedModelId = ref.watch(
      leadRequestProvider.select((lead) => lead?.model),
    );
    final itemValue = ref.watch(
      leadRequestProvider.select((lead) => lead?.engineType),
    );
    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.selectEngineType);
    final node = ref
        .watch(createLeadFormFocusNodesProvider)
        .get(LeadFormFields.selectEngineType);

    return SalesdocketSelectEngineTypeWidget(
      selectedModelId: selectedModelId,
      selectedEngine: itemValue,
      error: error,
      focusNode: node?.focusNode,
      onEngineSelected: (selected) {
        ref
            .read(leadRequestProvider.notifier)
            .update(
              (lead) =>
                  lead = lead?.copyWith(
                    engineType: selected,
                    primaryVariantId: null,
                    variant: null,
                  ),
            );
        ref
            .read(createLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.selectEngineType);
        ref
            .read(createLeadFormFocusNodesProvider.notifier)
            .focusNext(context, field: LeadFormFields.selectVariant);
      },
    );
  }

  Widget _variantWidget(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(leadRequestProvider);
    final itemValue = lead?.primaryVariantId;

    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.selectVariant);
    final node = ref
        .watch(createLeadFormFocusNodesProvider)
        .get(LeadFormFields.selectVariant);

    return SalesdocketSelectVariantWidget(
      selectedModelId: lead?.model,
      selectedEngine: lead?.engineType,
      selectedVariantId: itemValue,
      error: error,
      focusNode: node?.focusNode,
      onVariantSelected: (selectedId, selected) {
        if (selectedId == null || selectedId == itemValue) return;

        ref
            .read(leadRequestProvider.notifier)
            .update(
              (lead) =>
                  lead = lead?.copyWith(
                    primaryVariantId: selectedId,
                    variant: [selectedId],
                    variants: lead.updatedVariants(selectedId, selected),
                  ),
            );
        ref
            .read(createLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.selectVariant);
        ref
            .read(createLeadFormFocusNodesProvider.notifier)
            .focusNext(context, field: LeadFormFields.leadSource);
      },
    );
  }

  Widget _selectedVariantsWidget(WidgetRef ref) {
    final variants =
        ref.watch(leadRequestProvider.select((state) => state?.variants)) ?? [];

    return SalesdocketSelectedVariantsWidget(
      variants: variants,
      onRemoved: (variant) {
        ref
            .read(leadRequestProvider.notifier)
            .update((state) => state = state?.onVariantRemoved(variant.id));
      },
    );
  }
}
