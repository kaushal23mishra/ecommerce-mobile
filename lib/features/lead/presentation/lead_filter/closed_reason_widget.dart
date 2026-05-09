import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ClosedReasonWidget extends SalesdocketConsumerWidget {
  const ClosedReasonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReasons = ref.watch(
      leadFilterRequestProvider.select((req) => req?.closedReason),
    );
    final filterItems = LeadFiltersUtils.closedReasonsFilters;

    return CheckListWidget<String>(
      items: filterItems,
      selectedItems: selectedReasons?.split(",") ?? [],
      onChanged: (selected) {
        final currentLeadStatus = ref.read(leadFilterRequestProvider)?.leadStatus;
        String? updatedLeadStatus;

        if (selected.isNotEmpty) {
          // If closed reason is selected, ensure CLOSED is in lead status
          final statuses = currentLeadStatus?.split(",") ?? [];
          if (!statuses.contains("Closed")) {
            statuses.add("Closed");
            updatedLeadStatus = statuses.join(",");
          } else {
            updatedLeadStatus = currentLeadStatus;
          }
        } else {
          // If closed reason is cleared, keep existing lead status
          updatedLeadStatus = currentLeadStatus;
        }

        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    leadStatus: updatedLeadStatus,
                    closedReason: selected.isEmpty ? null : selected.join(","),
                  ),
            );
      },
    );
  }
}
