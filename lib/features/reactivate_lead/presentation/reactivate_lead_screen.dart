import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/presentation/details_widget.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/presentation/lead_status_widget.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/presentation/reactivate_lead_action_widget.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/presentation/reactivate_lead_plan_followup_widget.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/presentation/remarks_widget.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'ReactivateLeadRoute')
class ReactivateLeadScreen extends SalesdocketConsumerStatefulWidget {
  const ReactivateLeadScreen({super.key});

  @override
  ConsumerState<ReactivateLeadScreen> createState() =>
      _ReactivateLeadScreenState();
}

class _ReactivateLeadScreenState
    extends SalesdocketConsumerState<ReactivateLeadScreen>
    with UiComponentWidget {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
      _invalidateProviders();
      _initProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.reactivateLead.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            _reactiveLeadBody,
            SalesdocketLoadingOverlay(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  Widget get _reactiveLeadBody {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(2.h),
            const DetailsWidget(),
            verticalSpacing(3.h),
            const RemarksWidget(),
            verticalSpacing(3.h),
            const LeadStatusWidget(),
            verticalSpacing(3.h),
            const ReactivateLeadPlanFollowupWidget(),
            verticalSpacing(2.h),
            const ReactivateLeadActionWidget(),
          ],
        ),
      ),
    );
  }

  void _invalidateProviders() {
    final providers = [
      createLeadHistoryRequestProvider,
      reactivateLeadFollowupRequestProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [reactivateLeadFormErrorsProvider, loadingStateProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders() {
    final userId = ref.read(profileProvider)?.id;
    ref
        .read(createLeadHistoryRequestProvider.notifier)
        .update((state) => state = const CreateLeadHistoryRequest());
    ref
        .read(reactivateLeadFollowupRequestProvider.notifier)
        .update((state) => state = LeadFollowupRequest(actorId: userId));
  }
}
