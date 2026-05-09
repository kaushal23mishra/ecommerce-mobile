import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CancelBookingPopup extends SalesdocketConsumerStatefulWidget {
  const CancelBookingPopup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CancelBookingPopupState();
}

class _CancelBookingPopupState
    extends SalesdocketConsumerState<CancelBookingPopup>
    with LeadEvents {
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

    return SalesdocketBottomSheet(
      title: LocaleKeys.cancelBooking.tr(),
      padding: EdgeInsets.zero,
      widget: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Icon(Icons.warning, color: appColors.warning, size: 10.w),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        'Are you sure, you want to cancel the booking?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: appColors.textDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SalesdocketActionWidget(
                  positiveText: LocaleKeys.cancelBooking.tr(),
                  onPositiveClicked: () {
                    _changeLeadStatus();
                  },
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: SalesdocketLoadingOverlay(
              isLoading: isLoading,
              barrierColor: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  void _invalidateProviders() {
    final providers = [cancelBookingRequestProvider];

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
    ref
        .read(cancelBookingRequestProvider.notifier)
        .update(
          (state) =>
              state = ChangeLeadStatusRequest(
                leadStatus: "CANCELLED",
                sentFrom: user?.id,
              ),
        );
  }

  void _changeLeadStatus() {
    final lead = ref.read(cancelBookingLeadProvider);
    final request = ref.read(cancelBookingRequestProvider);
    changeLeadStatus(leadId: lead?.id, request: request);
  }

  @override
  void onLeadStatusChanged(String? status) {
    showSnackBar("Booking Cancelled", type: SnackBarType.success);
    context.router.maybePop();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
