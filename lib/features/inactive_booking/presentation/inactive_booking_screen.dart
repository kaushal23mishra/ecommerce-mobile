import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/inactive_booking/presentation/action_widget.dart';
import 'package:salesdocket_mobile/features/inactive_booking/presentation/inactive_reason_widget.dart';
import 'package:salesdocket_mobile/features/inactive_booking/view_model/inactive_booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "InactiveBookingRoute")
class InactiveBookingScreen extends SalesdocketConsumerStatefulWidget {
  const InactiveBookingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InactiveBookingState();
}

class _InactiveBookingState
    extends SalesdocketConsumerState<InactiveBookingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          titleText: LocaleKeys.inactiveBooking.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpacing(2.h),
                    const InactiveReasonWidget(),
                    verticalSpacing(2.h),
                    const ActionWidget(),
                  ],
                ),
              ),
            ),
            SalesdocketLoadingOverlay(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  void _invalidateProviders() {
    final providers = [inactiveBookingRequestProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [inactiveBookingFormErrorsProvider];

    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders() {
    ref
        .read(inactiveBookingRequestProvider.notifier)
        .update(
          (state) =>
              state = const ChangeLeadStatusRequest(
                leadStatus: "INACTIVE",
                bookingInactive: "BOOKING_INACTIVE",
              ),
        );
  }
}
