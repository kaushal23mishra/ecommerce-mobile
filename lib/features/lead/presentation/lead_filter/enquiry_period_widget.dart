import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/filter_date_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class EnquiryPeriodWidget extends SalesdocketConsumerWidget {
  const EnquiryPeriodWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateFrom = ref.watch(
      leadFilterRequestProvider.select((req) => req?.creationDateFrom),
    );
    final selectedDateTo = ref.watch(
      leadFilterRequestProvider.select((req) => req?.creationDateTo),
    );

    return FilterDateWidget(
      fromDate: selectedDateFrom,
      toDate: selectedDateTo,
      onFromDateChanged: (date) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(creationDateFrom: date),
            );
      },
      onToDateChanged: (date) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(creationDateTo: date),
            );
      },
    );
  }
}
