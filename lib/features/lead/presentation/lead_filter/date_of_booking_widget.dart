import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/filter_date_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DateOfBookingWidget extends SalesdocketConsumerWidget {
  const DateOfBookingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateFrom = ref.watch(
      leadFilterRequestProvider.select((req) => req?.bookingDateFrom),
    );
    final selectedDateTo = ref.watch(
      leadFilterRequestProvider.select((req) => req?.bookingDateTo),
    );

    return FilterDateWidget(
      fromDate: selectedDateFrom,
      toDate: selectedDateTo,
      onFromDateChanged: (date) {
        final currentLeadStatus = ref.read(leadFilterRequestProvider)?.leadStatus;
        String? updatedLeadStatus;

        if (date != null) {
          // If booking date is selected, ensure Booked is in lead status
          final statuses = currentLeadStatus?.split(",") ?? [];
          if (!statuses.contains("Booked")) {
            statuses.add("Booked");
            updatedLeadStatus = statuses.join(",");
          } else {
            updatedLeadStatus = currentLeadStatus;
          }
        } else {
          // If booking date is cleared, keep existing lead status
          updatedLeadStatus = currentLeadStatus;
        }

        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(
                leadStatus: updatedLeadStatus,
                bookingDateFrom: date,
              ),
            );
      },
      onToDateChanged: (date) {
        final currentLeadStatus = ref.read(leadFilterRequestProvider)?.leadStatus;
        String? updatedLeadStatus;

        if (date != null) {
          // If booking date is selected, ensure Booked is in lead status
          final statuses = currentLeadStatus?.split(",") ?? [];
          if (!statuses.contains("Booked")) {
            statuses.add("Booked");
            updatedLeadStatus = statuses.join(",");
          } else {
            updatedLeadStatus = currentLeadStatus;
          }
        } else {
          // If booking date is cleared, keep existing lead status
          updatedLeadStatus = currentLeadStatus;
        }

        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(
                leadStatus: updatedLeadStatus,
                bookingDateTo: date,
              ),
            );
      },
    );
  }
}
