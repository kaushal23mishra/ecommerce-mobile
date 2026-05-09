import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/followup_history/presentation/lead_history_item_widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/widget.dart';
import '../../../../common/entity/followup_data_given.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../booking/view_model/booking_view_model.dart';

class LeadHistoryWidget extends SalesdocketConsumerStatefulWidget {
  const LeadHistoryWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadHistoryState();
}

class _LeadHistoryState extends SalesdocketConsumerState<LeadHistoryWidget>
    with LeadEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lead = ref.read(followupLeadRequestProvider);
      setupStatusBar();
      _invalidateProviders();
      _fetchData();
      _initProviders(lead);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leadHistory =
        ref
            .watch(followupLeadHistoryProvider)
            .where((history) => history.responseType != "test_drive")
            .take(3)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.lblRecentFollowUps.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leadHistory.length,
          itemBuilder: (context, index) {
            return LeadHistoryItemWidget(leadHistory: leadHistory[index]);
            // final comment = (leadHistory[index].leadHistoryResponse?.comment ??
            //     leadHistory[index].notDoneReason) ?? '';
            // if (leadHistory.isNotEmpty && leadHistory.first.leadProgress?.toLowerCase() == 'registered') {
            //   return LeadHistoryItemWidget(leadHistory: leadHistory[index]);
            // } else {
            //   return comment.isNotEmpty
            //       ? LeadHistoryItemWidget(leadHistory: leadHistory[index])
            //       : const SizedBox.shrink();
            // }
          },
        ),
      ],
    );
  }

  void _initProviders(Lead? lead) {
    ref
        .read(selectBrandAndModelProvider.notifier)
        .update((_) => lead?.interestedInCompDetails);

    ref
        .read(selectedExchangeHouseProvider.notifier)
        .update((_) => lead?.bookingExchangeHouse);

    ref
        .read(followupRequestProvider.notifier)
        .update((_) => const FollowupDataGiven());
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    final testDriveHistory = history.firstWhereOrNull(
      (toFilter) => toFilter.responseType == 'test_drive',
    );
    final lead = ref.read(bookingLeadRequestProvider);
    final testDriveGiven = testDriveHistory?.testDriveGiveDerails
        ?.defaultTestDriveGivenValues(lead);
    ref
        .read(followupTestDriveGivenProvider.notifier)
        .update((state) => state = testDriveGiven);

    ref
        .read(followupLeadHistoryProvider.notifier)
        .update((state) => state = history);
  }

  void _invalidateProviders() {
    final notifiers = [createFollowUpFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
    final providers = [
      selectBrandAndModelProvider,
      followupRequestProvider,
      followupLeadHistoryProvider,
      followupTestDriveGivenProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    final lead = ref.read(followupLeadRequestProvider);
    if (lead != null) {
      fetchLeadHistory(leadId: lead.id);
    }
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
