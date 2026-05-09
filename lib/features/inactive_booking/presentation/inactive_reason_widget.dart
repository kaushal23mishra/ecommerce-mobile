import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/inactive_booking_reasons.dart';
import 'package:salesdocket_mobile/common/entity/check_list_item.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/inactive_booking/view_model/inactive_booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class InactiveReasonWidget extends SalesdocketConsumerWidget {
  const InactiveReasonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasons = InactiveBookingReasons.values;
    final inactiveBookingRequest = ref.watch(inactiveBookingRequestProvider);
    final prevSelected = inactiveBookingRequest?.bookingInactiveReasons ?? [];
    final errors = ref.watch(inactiveBookingFormErrorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketChecklistWidget(
          label: LocaleKeys.lblReason.tr(),
          selectedItems: prevSelected,
          items:
              reasons
                  .map(
                    (item) => CheckListItem(key: item.value, value: item.value),
                  )
                  .toList(),
          onChanged: (selected) {
            if (!selected.contains(InactiveBookingReasons.others.value)) {
              ref
                  .read(inactiveBookingRequestProvider.notifier)
                  .update(
                    (state) =>
                        state = state?.copyWith(otherInactiveReason: null),
                  );
            }
            ref
                .read(inactiveBookingRequestProvider.notifier)
                .update(
                  (state) =>
                      state = state?.copyWith(bookingInactiveReasons: selected),
                );
            ref
                .read(inactiveBookingFormErrorsProvider.notifier)
                .remove(InactiveBookingFormFields.inactiveBookingReasons);
          },
          error:
              errors
                  .get(InactiveBookingFormFields.inactiveBookingReasons)
                  ?.message,
        ),
        if (prevSelected.contains(InactiveBookingReasons.others.value))
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketInputWidget(
              initialValue: inactiveBookingRequest?.otherInactiveReason,
              label: LocaleKeys.otherReason.tr(),
              hint: LocaleKeys.otherReason.tr(),
              errorMsg:
                  errors
                      .get(InactiveBookingFormFields.otherInactiveBookingReason)
                      ?.message,
              onChanged: (value) {
                ref
                    .read(inactiveBookingRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(
                            otherInactiveReason: value.trim(),
                          ),
                    );
                ref
                    .read(inactiveBookingFormErrorsProvider.notifier)
                    .remove(
                      InactiveBookingFormFields.otherInactiveBookingReason,
                    );
              },
            ),
          ),
      ],
    );
  }
}
