import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SummaryWidget extends SalesdocketConsumerWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotation = ref.watch(quotationProvider);
    final lead = ref.watch(deliveryLeadRequestProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.offerDetails.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const OfferSummaryHeaderWidget(canEdit: false, showTitle: false),
        verticalSpacing(1.h),
        SalesdocketOfferSummaryViewWidget(quotation: quotation, lead: lead),
        OfferSummaryFooterWidget(quotation: quotation),
        const BrokerageSummaryWidget(),
      ],
    );
  }
}
