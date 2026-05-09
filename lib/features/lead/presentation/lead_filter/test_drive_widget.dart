import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class TestDriveWidget extends SalesdocketConsumerWidget {
  const TestDriveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTestDrive = ref.watch(
      leadFilterRequestProvider.select((req) => req?.isTestDriveGiven),
    );
    final filterItems = LeadFiltersUtils.testDriveFilters;

    return CheckListWidget(
      items: filterItems,
      isMultiSelect: false,
      selectedItems: selectedTestDrive == null ? [] : [selectedTestDrive],
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    isTestDriveGiven: selected.firstOrNull,
                  ),
            );
      },
    );
  }
}
