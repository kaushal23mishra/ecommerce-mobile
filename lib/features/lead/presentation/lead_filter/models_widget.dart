import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ModelsWidget extends SalesdocketConsumerStatefulWidget {
  const ModelsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModelWidgetState();
}

class _ModelWidgetState extends SalesdocketConsumerState<ModelsWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLeadModels();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProductIds = ref.watch(
      leadFilterRequestProvider.select((req) => req?.productIds),
    );
    final models = ref.watch(leadModelsProviders);
    final filterItems = LeadFiltersUtils.modelsFilters(models);

    return CheckListWidget<int>(
      items: filterItems,
      selectedItems: selectedProductIds,
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    productIds: selected.isEmpty ? null : selected,
                  ),
            );
      },
    );
  }

  void _fetchLeadModels() {
    const request = GetProductsRequest(
      returnType: 'product',
      currentOrganizationOnly: 'yes',
    );

    ref
        .read(productsViewModelProvider.notifier)
        .getProductsName(request: request)
        .then((result) {
          result.when(
            success: (data) {
              final products = data?.data ?? [];
              if (products.isNotEmpty) {
                ref
                    .read(leadModelsProviders.notifier)
                    .update((state) => state = products);
              }
            },
            failure: (error) {
              context.showSnackBar(
                error.message ?? LocaleKeys.defaultErrorMessage.tr(),
                type: SnackBarType.error,
              );
            },
          );
        });
  }
}
