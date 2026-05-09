import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LostReasonWidget extends SalesdocketConsumerWidget {
  const LostReasonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReasons = ref.watch(
      leadFilterRequestProvider.select((req) => req?.lostReason),
    );
    final filterItems = LeadFiltersUtils.lostReasonsFilters;

    return CheckListWidget<String>(
      items: filterItems,
      selectedItems: selectedReasons?.split(",") ?? [],
      onChanged: (selected) {
        final currentLeadStatus = ref.read(leadFilterRequestProvider)?.leadStatus;
        String? updatedLeadStatus;

        if (selected.isNotEmpty) {
          // If lost reason is selected, ensure Lost is in lead status
          final statuses = currentLeadStatus?.split(",") ?? [];
          if (!statuses.contains("Lost")) {
            statuses.add("Lost");
            updatedLeadStatus = statuses.join(",");
          } else {
            updatedLeadStatus = currentLeadStatus;
          }
        } else {
          // If lost reason is cleared, keep existing lead status
          updatedLeadStatus = currentLeadStatus;
        }

        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    leadStatus: updatedLeadStatus,
                    lostReason: selected.isEmpty ? null : selected.join(","),
                  ),
            );
      },
    );
  }
}
