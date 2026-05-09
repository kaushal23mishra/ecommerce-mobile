import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/cancel_booking_reasons.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CancelReasonWidget extends SalesdocketConsumerWidget {
  const CancelReasonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasons = CancelBookingReasons.values;
    final cancelBookingRequest = ref.watch(cancelBookingRequestProvider);
    final prevSelected = cancelBookingRequest?.bookingCancelReason;
    final errors = ref.watch(cancelBookingFormErrorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketDropDownWidget(
          text: LocaleKeys.reasonOfCancellation.tr(),
          itemValue: cancelBookingRequest?.bookingCancelReason,
          itemList: reasons.map((reason) => reason.value).toList(),
          imagePath: Assets.svg.arrowDown.path,
          isRequired: true,
          onChanged: (selected) {
            if (selected != CancelBookingReasons.others.value) {
              ref
                  .read(cancelBookingRequestProvider.notifier)
                  .update(
                    (state) =>
                        state = state?.copyWith(otherCancelledReason: null),
                  );
            }
            ref
                .read(cancelBookingRequestProvider.notifier)
                .update(
                  (state) =>
                      state = state?.copyWith(bookingCancelReason: selected),
                );
            ref
                .read(cancelBookingFormErrorsProvider.notifier)
                .remove(CancelBookingFormFields.reasonOfCancellation);
          },
          errorText:
              errors.get(CancelBookingFormFields.reasonOfCancellation)?.message,
        ),
        if (prevSelected == CancelBookingReasons.others.value)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketInputWidget(
              initialValue: cancelBookingRequest?.otherCancelledReason,
              label: LocaleKeys.enterReason.tr(),
              hint: LocaleKeys.enterReason.tr(),
              errorMsg:
                  errors
                      .get(CancelBookingFormFields.otherCancellationReason)
                      ?.message,
              onChanged: (value) {
                ref
                    .read(cancelBookingRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(
                            otherCancelledReason: value.trim(),
                          ),
                    );
                ref
                    .read(cancelBookingFormErrorsProvider.notifier)
                    .remove(CancelBookingFormFields.otherCancellationReason);
              },
            ),
          ),
      ],
    );
  }
}
