import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CancellationChargesWidget extends SalesdocketConsumerWidget {
  const CancellationChargesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errors = ref.watch(cancelBookingFormErrorsProvider);

    return SalesDocketInputWidget(
      label: LocaleKeys.cancellationCharges.tr(),
      hint: LocaleKeys.cancellationCharges.tr(),
      inputType: TextInputType.number,
      onChanged: (newValue) {
        ref
            .read(cancelBookingRequestProvider.notifier)
            .update(
              (state) =>
                  state = state?.copyWith(
                    bookingCancelAmount: int.tryParse(newValue.trim()),
                  ),
            );
        ref
            .read(cancelBookingFormErrorsProvider.notifier)
            .remove(CancelBookingFormFields.cancellationCharges);
      },
      errorMsg:
          errors.get(CancelBookingFormFields.cancellationCharges)?.message,
    );
  }
}
