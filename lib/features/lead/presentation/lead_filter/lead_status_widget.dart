import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadStatusWidget extends SalesdocketConsumerWidget {
  const LeadStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeadStatus = ref.watch(
      leadFilterRequestProvider.select((req) => req?.leadStatus),
    );
    final leadCounts = ref.watch(leadCountsProviders);
    final filterItems = LeadFiltersUtils.leadStatusFilters(leadCounts);

    return CheckListWidget<String>(
      items: filterItems,
      selectedItems: selectedLeadStatus?.split(",") ?? [],
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    leadStatus: selected.isEmpty ? null : selected.join(","),
                  ),
            );
      },
    );
  }
}
