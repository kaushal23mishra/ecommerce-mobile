import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExchangeDetailsWidget extends SalesdocketConsumerWidget {
  const ExchangeDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(prospectLeadRequestProvider);
    final detailItems = LeadUtils.getExchangeDetailItems(lead: lead);

    return SalesdocketDetailsCardWidget(items: detailItems);
  }
}
