import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead_result/action_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead_result/details_card_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead_result/query_success_message_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'CreateLeadResultRoute')
class CreateLeadResultScreen extends SalesdocketConsumerStatefulWidget {
  const CreateLeadResultScreen({super.key});

  @override
  SalesdocketConsumerState<CreateLeadResultScreen> createState() =>
      _CreateLeadResultScreenState();
}

class _CreateLeadResultScreenState
    extends SalesdocketConsumerState<CreateLeadResultScreen>
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _navigateBack(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: SalesDocketAppBarWidget(
            titleText: "",
            onHomeClicked: () => onHomeClicked(),
            onBackClicked: () => _navigateBack(context),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                verticalSpacing(3.h),
                const QuerySuccessMessageWidget(),
                verticalSpacing(2.h),
                const DetailsCardWidget(),
                verticalSpacing(2.h),
                const ActionWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchData() {
    final lead = ref.read(createdLeadProvider);
    fetchLead(leadId: lead?.id);
  }

  void _navigateBack(BuildContext context) {
    // Check if LeadListRoute exists in the navigation stack
    final hasLeadListRoute = context.router.stack.any(
      (page) => page.name == LeadListRoute.name,
    );

    if (hasLeadListRoute) {
      // Navigate back to lead listing screen (for CC leads, HO leads, etc.)
      context.router.popUntilRouteWithName(LeadListRoute.name);
    } else {
      // Navigate to dashboard (for new lead flow from home)
      Navigator.pop(context);
    }
  }

  @override
  void onLeadFetched(Lead? lead) {
    ref
        .read(createdLeadProvider.notifier)
        .update((state) => state = lead ?? state);
  }

  @override
  WidgetRef get eventRef => ref;
}
