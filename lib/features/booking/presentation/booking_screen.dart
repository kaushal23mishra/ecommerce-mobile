import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/booking_steps.dart';
import 'package:salesdocket_mobile/common/entity/stepper_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_stepper.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "BookingRoute")
class BookingScreen extends SalesdocketConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends SalesdocketConsumerState<BookingScreen> {
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
    final canEdit = ref.watch(canEditBookingProvider);
    final loading = ref.watch(loadingStateProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBackNavigation();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: SalesDocketAppBarWidget(
            titleText:
                canEdit
                    ? LocaleKeys.lblBooking.tr()
                    : LocaleKeys.bookingDetails.tr(),
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
    final selectedStep = ref.watch(selectedBookingStepProvider);
    final lead = ref.watch(bookingLeadRequestProvider);
    final user = ref.watch(profileProvider);

    return SalesdocketStepper(
      steps: bookingStepItems(lead),
      selectedStep: selectedStep,
      canClick: user?.isAdmin ?? false,
      onStepChanged: (step) {
        if (selectedStep == step) return;

        ref.invalidate(bookingLeadRequestProvider);
        ref
            .read(selectedBookingStepProvider.notifier)
            .update((toUpdate) => toUpdate = step);
      },
    );
  }

  void _handleBackNavigation() {
    final currentStep = ref.read(selectedBookingStepProvider);
    if (currentStep > 0) {
      final lead = ref.read(bookingLeadRequestProvider);
      final steps = bookingStepItems(lead);
      final targetStep = steps.prevEnableStep(currentStep);
      ref.invalidate(bookingLeadRequestProvider);
      ref
          .read(selectedBookingStepProvider.notifier)
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
