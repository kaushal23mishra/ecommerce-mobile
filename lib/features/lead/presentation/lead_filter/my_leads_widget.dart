import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';

class MyLeadsWidget extends SalesdocketConsumerWidget {
  const MyLeadsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMyLeads = ref.watch(
      leadFilterRequestProvider.select((req) => req?.myLeads),
    );
    final filterItems = LeadFiltersUtils.myLeadsFilters;

    return CheckListWidget(
      items: filterItems,
      isMultiSelect: false,
      selectedItems: selectedMyLeads == null ? [] : [selectedMyLeads],
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    myLeads: selected.isEmpty ? null : selected.firstOrNull,
                  ),
            );
      },
    );
  }
}
