import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_edit_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_view_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SummaryWidget extends SalesdocketConsumerWidget {
  final bool canEdit;

  const SummaryWidget({super.key, this.canEdit = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(prospectLeadRequestProvider);
    final editOfferSummary = ref.watch(editOfferSummaryProvider);
    final quotation = ref.watch(quotationProvider);

    return Column(
      children: [
        OfferSummaryHeaderWidget(
          editSummary: editOfferSummary,
          onEditChanged: (value) {
            ref
                .read(editOfferSummaryProvider.notifier)
                .update((state) => state = value);
          },
          canEdit: canEdit,
        ),
        verticalSpacing(1.h),
        editOfferSummary
            ? SalesdocketOfferSummaryEditWidget(
              lead: lead,
              quotation: quotation,
            )
            : SalesdocketOfferSummaryViewWidget(
              quotation: quotation,
              lead: lead,
            ),
        OfferSummaryFooterWidget(
          quotation: quotation,
          editSummary: editOfferSummary,
        ),
        const BrokerageSummaryWidget(),
      ],
    );
  }
}
