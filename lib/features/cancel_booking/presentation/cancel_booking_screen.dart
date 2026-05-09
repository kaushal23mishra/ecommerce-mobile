import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/action_widget.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/cancel_reason_widget.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/cancellation_charges_widget.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/cancellation_users_list_widget.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/receipts_widget.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "CancelBookingRoute")
class CancelBookingScreen extends SalesdocketConsumerStatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CancelBookingState();
}

class _CancelBookingState
    extends SalesdocketConsumerState<CancelBookingScreen> {
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
    final user = ref.watch(profileProvider);
    final isLoading = ref.watch(loadingStateProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.cancelBooking.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpacing(2.5.h),
                    const CancelReasonWidget(),
                    verticalSpacing(2.h),
                    const CancellationChargesWidget(),
                    verticalSpacing(2.5.h),
                    const ReceiptsWidget(),
                    if ((user?.isSalesConsultant ?? false) ||
                        (user?.isSalesManager ?? false))
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: const CancellationUsersListWidget(),
                      ),
                    verticalSpacing(3.h),
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
    final providers = [
      cancelBookingRequestProvider,
      cancelBookingUsersProvider,
      addMoreReceiptProvider,
    ];

    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [cancelBookingFormErrorsProvider];

    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders() {
    final user = ref.read(profileProvider);
    var bookingCancelled =
        user?.isSalesManager == true
            ? "SM_BOOKING_CANCELLED"
            : "SC_BOOKING_CANCELLED";

    ref
        .read(cancelBookingRequestProvider.notifier)
        .update(
          (state) =>
              state = ChangeLeadStatusRequest(
                leadStatus: "CANCELLED",
                bookingCancelled: bookingCancelled,
                sentFrom: user?.id,
              ),
        );
  }
}
