import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DetailsWidget extends SalesdocketConsumerWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(prevBookingLeadRequestProvider);

    final detailItems = lead?.bookingExchangeDetailsItems ?? [];

    return SalesdocketDetailsCardWidget(items: detailItems);
  }
}
