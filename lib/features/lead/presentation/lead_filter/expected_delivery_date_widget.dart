import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/filter_date_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExpectedDeliveryDateWidget extends SalesdocketConsumerWidget {
  const ExpectedDeliveryDateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateFrom = ref.watch(
      leadFilterRequestProvider.select((req) => req?.expectedDeliveryFrom),
    );
    final selectedDateTo = ref.watch(
      leadFilterRequestProvider.select((req) => req?.expectedDeliveryTo),
    );

    return FilterDateWidget(
      fromDate: selectedDateFrom,
      toDate: selectedDateTo,
      onFromDateChanged: (date) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(expectedDeliveryFrom: date),
            );
      },
      onToDateChanged: (date) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(expectedDeliveryTo: date),
            );
      },
    );
  }
}
