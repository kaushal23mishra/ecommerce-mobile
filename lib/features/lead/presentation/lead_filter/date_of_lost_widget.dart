import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/filter_date_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DateOfLostWidget extends SalesdocketConsumerWidget {
  const DateOfLostWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateFrom = ref.watch(
      leadFilterRequestProvider.select((req) => req?.lostDateFrom),
    );
    final selectedDateTo = ref.watch(
      leadFilterRequestProvider.select((req) => req?.lostDateTo),
    );

    return FilterDateWidget(
      fromDate: selectedDateFrom,
      toDate: selectedDateTo,
      onFromDateChanged: (date) {
        final currentLeadStatus = ref.read(leadFilterRequestProvider)?.leadStatus;
        String? updatedLeadStatus;

        if (date != null) {
          // If lost date is selected, ensure Lost is in lead status
          final statuses = currentLeadStatus?.split(",") ?? [];
          if (!statuses.contains("Lost")) {
            statuses.add("Lost");
            updatedLeadStatus = statuses.join(",");
          } else {
            updatedLeadStatus = currentLeadStatus;
          }
        } else {
          // If lost date is cleared, keep existing lead status
          updatedLeadStatus = currentLeadStatus;
        }

        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(
                leadStatus: updatedLeadStatus,
                lostDateFrom: date,
              ),
            );
      },
      onToDateChanged: (date) {
        final currentLeadStatus = ref.read(leadFilterRequestProvider)?.leadStatus;
        String? updatedLeadStatus;

        if (date != null) {
          // If lost date is selected, ensure Lost is in lead status
          final statuses = currentLeadStatus?.split(",") ?? [];
          if (!statuses.contains("Lost")) {
            statuses.add("Lost");
            updatedLeadStatus = statuses.join(",");
          } else {
            updatedLeadStatus = currentLeadStatus;
          }
        } else {
          // If lost date is cleared, keep existing lead status
          updatedLeadStatus = currentLeadStatus;
        }

        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(
                leadStatus: updatedLeadStatus,
                lostDateTo: date,
              ),
            );
      },
    );
  }
}
