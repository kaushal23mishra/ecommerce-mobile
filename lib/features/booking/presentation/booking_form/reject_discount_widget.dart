import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class RejectDiscountWidget extends SalesdocketConsumerWidget {
  final Function onRejectClicked;

  const RejectDiscountWidget({super.key, required this.onRejectClicked});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref
        .watch(bookingFormErrorsProvider)
        .get(DiscountFormFields.rejectReason);

    return SalesdocketBottomSheet(
      title: LocaleKeys.rejectBooking.tr(),
      padding: EdgeInsets.zero,
      widget: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            SalesDocketInputWidget(
              label: LocaleKeys.enterReason.tr(),
              hint: LocaleKeys.enterReason.tr(),
              onChanged: (newValue) {
                ref
                    .read(sendBookingDiscountApprovalRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(
                            requestResponse: newValue.trim(),
                          ),
                    );
                ref
                    .read(bookingFormErrorsProvider.notifier)
                    .remove(DiscountFormFields.rejectReason);
              },
              errorMsg: error?.message,
            ),
            verticalSpacing(2.h),
            SalesdocketActionWidget(
              positiveText: LocaleKeys.reject.tr(),
              onPositiveClicked: () {
                if (_isValidForm(ref)) {
                  onRejectClicked();
                  context.router.maybePop();
                }
              },
              buttonColor: appColors.error,
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidForm(WidgetRef ref) {
    final request = ref.read(sendBookingDiscountApprovalRequestProvider);
    final errors =
        request?.bookingRejectDiscountApprovalValidationErrors() ?? [];

    if (errors.isNotEmpty) {
      ref.read(bookingFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }
}
