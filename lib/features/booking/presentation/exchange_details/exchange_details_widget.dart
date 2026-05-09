import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExchangeDetailsWidget extends SalesdocketConsumerWidget {
  const ExchangeDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(bookingLeadRequestProvider);
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);

    final items = LeadUtils.getExchangeDetailItems(
      lead: lead,
      exchangeHouse: exchangeHouse,
    );

    return SalesdocketDetailsCardWidget(items: items);
  }
}
