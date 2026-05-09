import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_followup_details_card_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';
import 'package:salesdocket_mobile/features/followup_history/presentation/lead_history_item_widget.dart';
import 'package:salesdocket_mobile/features/followup_history/view_model/followup_history_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "FollowupHistoryRoute")
class FollowupHistoryScreen extends SalesdocketConsumerStatefulWidget {
  const FollowupHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowupHistoryState();
}

class _FollowupHistoryState
    extends SalesdocketConsumerState<FollowupHistoryScreen>
    with LeadEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingStateProvider);
    final lead = ref.watch(followupHistoryLead);
    final leadId = lead?.id;
    if (lead == null || leadId == null) return const SizedBox.shrink();

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.lblFollowUpHistory.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(2.h),
                  SalesdocketFollowupDetailsCardWidget(lead: lead),
                  verticalSpacing(2.h),
                  Text(
                    LocaleKeys.lblRecentFollowUps.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  verticalSpacing(1.h),
                  Expanded(child: _historyListWidget(leadId)),
                ],
              ),
            ),
            SalesdocketLoadingOverlay(isLoading: loading),
          ],
        ),
      ),
    );
  }

  Widget _historyListWidget(int leadId) {
    final pageSize = AppConfigs.pageSize;
    return ListView.builder(
      itemBuilder: (context, index) {
        final page = index ~/ pageSize + 1;
        final indexInPage = index % pageSize;
        final responseAsync = ref.watch(
          leadHistoryProvider(leadId: leadId, page: page),
        );

        return responseAsync.when(
          data: (res) {
            return res.when(
              success: (apiRes) {
                final allHistory = apiRes?.data?.data ?? [];
                final leadHistory =
                    allHistory
                        .where(
                          (history) => history.responseType != "test_drive",
                        )
                        .toList();
                if (indexInPage >= leadHistory.length) return null;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: indexInPage == leadHistory.length - 1 ? 1.h : 0,
                  ),
                  child: LeadHistoryItemWidget(
                    leadHistory: leadHistory[indexInPage],
                  ),
                );
              },
              failure: (error) => Center(child: Text('Error:, $error')),
            );
          },
          error: (err, stack) => Center(child: Text('Error:, $err')),
          loading: () => const LeadHistoryItemShimmerWidget(),
        );
      },
    );
  }

  void _fetchData() {
    ref.invalidate(leadHistoryProvider);
    final lead = ref.read(followupHistoryLead);
    final leadId = lead?.id;
    if (leadId == null) return;

    fetchLead(leadId: leadId);
    ref.read(leadHistoryProvider(leadId: leadId, page: 1));
  }

  void _initProviders(Lead? lead) {
    ref
        .read(followupHistoryLead.notifier)
        .update((state) => state = lead?.copyWith());
  }

  @override
  void onLeadFetched(Lead? lead) {
    _initProviders(lead);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
