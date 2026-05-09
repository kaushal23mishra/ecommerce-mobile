import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExchangeWidget extends SalesdocketConsumerWidget {
  const ExchangeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExchange = ref.watch(
      leadFilterRequestProvider.select((req) => req?.isExchange),
    );
    final filterItems = LeadFiltersUtils.exchangeFilters;

    return CheckListWidget(
      items: filterItems,
      isMultiSelect: false,
      selectedItems: selectedExchange == null ? [] : [selectedExchange],
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    isExchange: selected.firstOrNull,
                  ),
            );
      },
    );
  }
}
