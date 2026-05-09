import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SummaryWidget extends SalesdocketConsumerWidget {
  final bool canEdit;

  const SummaryWidget({super.key, this.canEdit = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationProvider);
    final lead = ref.watch(bookingLeadRequestProvider);

    return Column(
      children: [
        const OfferSummaryHeaderWidget(canEdit: false),
        verticalSpacing(1.h),
        SalesdocketOfferSummaryViewWidget(quotation: quotation, lead: lead),
        OfferSummaryFooterWidget(quotation: quotation),
        const BrokerageSummaryWidget(),
      ],
    );
  }
}
