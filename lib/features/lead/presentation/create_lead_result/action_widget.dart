import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerWidget {
  const ActionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(createdLeadProvider);

    return Column(
      children: [
        Text(
          LocaleKeys.howDoYouWantToProceed.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(2.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _moveToProspectScreen(lead, context, ref);
                },
                child: Column(
                  children: [
                    SalesDocketImageWidget(
                      imagePath: Assets.images.registration.path,
                      width: 20.w,
                    ),
                    verticalSpacing(0.5.h),
                    Text(
                      LocaleKeys.register.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _moveToBookingScreen(lead, context, ref);
                },
                child: Column(
                  children: [
                    SalesDocketImageWidget(
                      imagePath: Assets.images.booking.path,
                      width: 20.w,
                    ),
                    verticalSpacing(0.5.h),
                    Text(
                      LocaleKeys.booking.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _moveToProspectScreen(Lead? lead, BuildContext context, WidgetRef ref) {
    ref.invalidate(selectedProspectSheetStepProvider);
    ref.invalidate(prospectLeadRequestProvider);
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.replace(const ProspectRoute());
  }

  void _moveToBookingScreen(Lead? lead, BuildContext context, WidgetRef ref) {
    if (lead == null) return;

    ref.invalidate(selectedBookingStepProvider);
    ref.invalidate(bookingLeadRequestProvider);
    ref
        .read(canEditBookingProvider.notifier)
        .update((state) => state = LeadUtils.canEditBooking(lead));
    ref
        .read(prevBookingLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.replace(const BookingRoute());
  }
}
