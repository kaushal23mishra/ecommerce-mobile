import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class EmailWidget extends SalesdocketConsumerWidget {
  const EmailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchBy = ref.watch(
      leadFilterRequestProvider.select((req) => req?.searchBy),
    );
    final filterItems = LeadFiltersUtils.emailFilters;

    return CheckListWidget<String>(
      items: filterItems,
      isMultiSelect: false,
      selectedItems: searchBy == null ? [] : [searchBy],
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    searchBy:
                        selected.firstOrNull?.isEmpty == true
                            ? null
                            : selected.firstOrNull,
                    search: selected.isEmpty ? null : '@',
                  ),
            );
      },
    );
  }
}
