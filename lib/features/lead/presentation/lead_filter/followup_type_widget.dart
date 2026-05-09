import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class FollowupTypeWidget extends SalesdocketConsumerWidget {
  const FollowupTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFollowup = ref.watch(
      leadFilterRequestProvider.select((req) => req?.followup),
    );
    final filterItems = LeadFiltersUtils.followupTypeFilters;

    return CheckListWidget<String>(
      items: filterItems,
      selectedItems: selectedFollowup?.split(",") ?? [],
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    followup: selected.isEmpty ? null : selected.join(","),
                  ),
            );
      },
    );
  }
}
