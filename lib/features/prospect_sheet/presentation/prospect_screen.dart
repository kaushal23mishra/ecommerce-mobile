import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/prospect_sheet_steps.dart';
import 'package:salesdocket_mobile/common/entity/stepper_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_stepper.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "ProspectRoute")
class ProspectScreen extends SalesdocketConsumerStatefulWidget {
  const ProspectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProspectScreenState();
}

class _ProspectScreenState extends SalesdocketConsumerState<ProspectScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
      _invalidateProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingStateProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBackNavigation();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: SalesDocketAppBarWidget(
            titleText: LocaleKeys.lblProspectSheet.tr(),
            onBackClicked: () => _handleBackNavigation(),
            onHomeClicked: () => onHomeClicked(),
          ),
          body: Stack(
            children: [
              Padding(padding: EdgeInsets.only(top: 2.h), child: _stepperWidget),
              SalesdocketLoadingOverlay(isLoading: loading),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _stepperWidget {
    final selectedStep = ref.watch(selectedProspectSheetStepProvider);
    final lead = ref.watch(prospectLeadRequestProvider);
    final user = ref.watch(profileProvider);

    return SalesdocketStepper(
      steps: prospectStepItems(lead, user?.isEvaluator ?? false),
      selectedStep: (user?.isEvaluator ?? false) ? 2 : selectedStep,
      canClick: user?.isAdmin ?? false,
      onStepChanged: (step) {
        if (selectedStep == step) return;

        ref.invalidate(prospectLeadRequestProvider);
        ref
            .read(selectedProspectSheetStepProvider.notifier)
            .update((toUpdate) => toUpdate = step);
      },
    );
  }

  void _handleBackNavigation() {
    final currentStep = ref.read(selectedProspectSheetStepProvider);
    if (currentStep > 0) {
      final lead = ref.read(prospectLeadRequestProvider);
      final user = ref.read(profileProvider);
      final steps = prospectStepItems(lead, user?.isEvaluator ?? false);
      final targetStep = steps.prevEnableStep(currentStep);
      ref.invalidate(prospectLeadRequestProvider);
      ref
          .read(selectedProspectSheetStepProvider.notifier)
          .update((state) => targetStep);
    } else {
      context.router.popTop();
    }
  }

  void _invalidateProviders() {
    final notifiers = [loadingStateProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }
}
