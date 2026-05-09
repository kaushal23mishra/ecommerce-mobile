import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_followup_details_card_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/followup_details_widget.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/lead_history_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import '../view_model/followup_view_model.dart';
import 'components/call_action_widget.dart';
import 'package:auto_route/auto_route.dart';

import 'components/cc_lead_history_widget.dart';

@RoutePage(name: 'FollowupRoute')
class FollowupScreen extends SalesdocketConsumerStatefulWidget {
  const FollowupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowupScreenState();
}

class _FollowupScreenState extends SalesdocketConsumerState<FollowupScreen>
    with LeadEvents, NavigationEvents {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  Future<void> _initializeScreen() async {
    setupStatusBar();
    _invalidateProviders();
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingStateProvider);
    final lead = ref.watch(followupLeadRequestProvider);

    if (lead == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _handleBackNavigation();
            _resetFollowupState();
          }
        },
        child: Scaffold(
          appBar: SalesDocketAppBarWidget(
            onBackClicked: _handleBackNavigation,
            titleText: LocaleKeys.lblFollowup.tr(),
            onHomeClicked: _handleHomeClicked,
          ),
          body: Stack(
            children: [
              _buildContent(lead),
              SalesdocketLoadingOverlay(isLoading: loading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Lead lead) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(2.h),
            SalesdocketFollowupDetailsCardWidget(lead: lead),
            verticalSpacing(2.h),
            lead.isItCCLead ? const CCLeadHistoryWidget() : const LeadHistoryWidget(),
            verticalSpacing(2.h),
            const FollowupDetailsWidget(),
            verticalSpacing(2.h),
            const CallActionWidget(),
            verticalSpacing(2.h),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleWillPop() async {
    _handleBackNavigation();
    _resetFollowupState();
    return true;
  }

  void _handleBackNavigation() {
    final lead = ref.read(followupLeadRequestProvider);
    final leadType = ref.read(leadTypeProvider(lead?.isCCLead));
    _resetFollowupState();

    if (leadType == LeadType.ccLead) {
      context.router.popTop();
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _handleHomeClicked() {
    _resetFollowupState();
    onHomeClicked();
  }

  void _resetFollowupState() {
    ref.read(followupCallStatusProvider.notifier).state = false;
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    // Reset call states
    ref.read(callInProgressProvider.notifier).state = false;
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callStatusProvider.notifier).state = null;
    // Reset followup request data
    ref.read(followupRequestProvider.notifier).state = null;
  }

  void _invalidateProviders() {
    // Add any providers to invalidate here
    final providers = <ProviderBase>[
      followupImagesProvider,
      followupTestDriveGivenProvider,
    ];
    for (final provider in providers) {
      ref.invalidate(provider);
    }

    // Invalidate form errors
    final notifiers = [createFollowUpFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  Future<void> _fetchData() async {
    final lead = ref.read(followupLeadRequestProvider);
    if (lead != null) {
      if (lead.isCCLead != 1) {
        await fetchLead(leadId: lead.id);
      }
    }
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (lead != null) {
      ref.read(followupLeadRequestProvider.notifier).state = lead.copyWith();
      // Fetch lead history to populate test drive data
      // fetchLeadHistory(leadId: lead.id);
    }
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    final testDriveHistory = history.firstWhereOrNull(
      (toFilter) => toFilter.responseType == 'test_drive',
    );
    final lead = ref.read(followupLeadRequestProvider);
    final testDriveGiven = testDriveHistory?.testDriveGiveDerails
        ?.defaultTestDriveGivenValues(lead);
    ref
        .read(followupTestDriveGivenProvider.notifier)
        .update((state) => state = testDriveGiven);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    if (mounted) {
      context.showSnackBar(message, type: type);
    }
  }

  @override
  WidgetRef get eventRef => ref;
}
