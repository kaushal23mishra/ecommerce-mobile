import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/call_now_component/lost_to_component/lost_to_competitor_widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../../../common/constants/form_fields.dart';
import '../../../../view_model/followup_view_model.dart';
import '../../call_status_mode.dart';
import 'lost_to_co_dealer_widget.dart';

class LostToWidget extends ConsumerWidget {
  const LostToWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lostToStatus = ref.watch(
      followupRequestProvider.select((followup) => followup?.lostTo ?? ''),
    );
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.lostTo);

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lost To', style: Theme.of(context).textTheme.titleMedium),
          verticalSpacing(1.h),
          SalesDocketChipWidget(
            chips: LostToType.lostToList.map((source) => source.label).toList(),
            selectedChips: lostToStatus.isNotEmpty ? [lostToStatus] : [],
            errorText: error?.message,
            onSelected: (selected) {
              final newSelectedSource = selected?.firstOrNull ?? '';

              ref
                  .read(followupRequestProvider.notifier)
                  .update(
                    (followup) => followup?.copyWith(lostTo: newSelectedSource),
                  );

              ref
                  .read(createFollowUpFormErrorsProvider.notifier)
                  .remove(CreateFollowUpFormFields.lostTo);
            },
          ),
          if (lostToStatus == 'Competitor') const LostToCompetitorWidget(),
          if (lostToStatus == 'Co-Dealer') const LostToCoDealerWidget(),
        ],
      ),
    );
  }
}
