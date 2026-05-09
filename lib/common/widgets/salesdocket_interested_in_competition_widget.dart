import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_comp_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_searchable_dropdown_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketInterestedInCompetitionWidget
    extends SalesdocketConsumerStatefulWidget {
  final InterestedInComp? interestedInComp;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final bool isRequired;

  const SalesdocketInterestedInCompetitionWidget({
    super.key,
    this.interestedInComp,
    this.onChanged,
    this.errors = const {},
    this.isRequired = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketInterestedInCompetitionState();
}

class _SalesdocketInterestedInCompetitionState
    extends SalesdocketConsumerState<SalesdocketInterestedInCompetitionWidget>
    with ProductEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCompetitionProducts();
      getCompetitionModels(brandId: widget.interestedInComp?.brand);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selected = getInterestedInCompLabel(widget.interestedInComp?.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketChipWidget<String>(
          label: LocaleKeys.interestedInCompetition.tr(),
          isRequired: widget.isRequired,
          chips: interestedInCompStateList.map((value) => value.label).toList(),
          selectedChips: selected == null ? [] : [selected],
          onSelected: (selected) {
            final newValue = selected?.firstOrNull;
            if (newValue != null && widget.onChanged != null) {
              widget.onChanged!(
                LeadFormFields.interestedInComp,
                getInterestedInCompValue(newValue),
                null,
              );
            }
          },
          errorText: widget.errors[LeadFormFields.interestedInComp]?.message,
        ),
        widget.interestedInComp?.status == InterestedInCompState.yes.value
            ? _brandModelWidget(context)
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _brandModelWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.w,
        children: [
          Expanded(child: _brandsWidget(context)),
          Expanded(child: _modelsWidget(context)),
        ],
      ),
    );
  }

  Widget _brandsWidget(BuildContext context) {
    final brands = ref.watch(competitionProductsProvider).map((p) => p.brand);
    final Set<int> seenBrandIds = {};
    final itemList = brands.where((brand) {
      final brandId = brand?.id;
      if (brandId == null) return false;
      return seenBrandIds.add(brandId);
    }).toList();

    final selected = itemList.firstWhereOrNull(
      (item) => item?.id == widget.interestedInComp?.brand,
    );

    return SalesdocketSearchableDropdownWidget<ProductBrand?>(
      label: LocaleKeys.selectBrand.tr(),
      isRequired: true,
      selectedItem: selected,
      items: itemList,
      itemAsString: (item) => item?.name ?? '',
      compareFn: (a, b) => a?.id == b?.id,
      errorText: widget.errors[LeadFormFields.compBrand]?.message,
      onChanged: (selected) {
        if (selected?.id != null && widget.onChanged != null) {
          widget.onChanged!(LeadFormFields.compBrand, selected!.id, null);
          getCompetitionModels(brandId: selected.id!);
        }
      },
    );
  }

  Widget _modelsWidget(BuildContext context) {
    final itemList = ref.watch(competitionModelsProvider).toSet().toList();
    final selected = itemList.firstWhereOrNull(
      (item) => item.id == widget.interestedInComp?.model,
    );

    return SalesdocketSearchableDropdownWidget<CompetitionProduct>(
      label: LocaleKeys.selectModel.tr(),
      isRequired: true,
      selectedItem: selected,
      items: widget.interestedInComp?.brand == null ? [] : itemList,
      itemAsString: (item) => item.name ?? '',
      compareFn: (a, b) => a.id == b.id,
      errorText: widget.errors[LeadFormFields.compModel]?.message,
      onChanged: (selected) {
        if (selected?.id != null && widget.onChanged != null) {
          widget.onChanged!(LeadFormFields.compModel, selected!.id, null);
        }
      },
    );
  }

  @override
  void onCompetitionProductsFetched(List<CompetitionProduct> list) {
    ref
        .read(competitionProductsProvider.notifier)
        .update((state) => state = list);
  }

  @override
  void onCompetitionModelsFetched(List<CompetitionProduct> list) {
    ref
        .read(competitionModelsProvider.notifier)
        .update((state) => state = list);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
