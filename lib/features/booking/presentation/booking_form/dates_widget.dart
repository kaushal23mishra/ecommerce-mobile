import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DatesWidget extends SalesdocketConsumerStatefulWidget {
  const DatesWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DatesState();
}

class _DatesState extends SalesdocketConsumerState<DatesWidget>
    with ReceiptEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lead = ref.read(bookingLeadRequestProvider);
      fetchReceipts(leadId: lead?.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _expectedDateWidget,
        verticalSpacing(2.h),
        _amountCollectedDateWidget,
        verticalSpacing(2.h),
        _dateOfBookingWidget,
        verticalSpacing(2.h),
        _scheduleCallFollowupWidget,
      ],
    );
  }

  Widget get _scheduleCallFollowupWidget {
    final isScheduled = ref.watch(scheduleCallFollowupProvider);
    final followupDateTime = ref.watch(bookingFollowupDateTimeProvider);
    final canEdit = ref.watch(canEditBookingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.scheduleCallFollowup.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: isScheduled,
                onChanged: canEdit
                    ? (value) {
                        ref
                            .read(scheduleCallFollowupProvider.notifier)
                            .update((state) => value);
                      }
                    : null,
                activeTrackColor: appColors.primary,
              ),
            ),
          ],
        ),
        if (isScheduled) ...[
          verticalSpacing(2.h),
          SalesdocketTimePickerSpinnerPopUp(
            label: LocaleKeys.msgFollowupDateTime.tr(),
            isRequired: true,
            enable: canEdit,
            minTime: followupDateTime == null
                ? DateTime.now()
                : DateTime.tryParse(followupDateTime)
                    ?.subtract(const Duration(minutes: 5)),
            mode: CupertinoDatePickerMode.dateAndTime,
            initTime: followupDateTime == null
                ? null
                : DateTime.tryParse(followupDateTime),
            onChange: (newDateTime) {
              ref
                  .read(bookingFollowupDateTimeProvider.notifier)
                  .update((state) => newDateTime.formatDateTime());
            },
          ),
        ],
      ],
    );
  }

  Widget get _expectedDateWidget {
    final booking = ref.watch(selectedBookingProvider);
    final expectedDate = booking?.expectedDelivery;
    final selectedDateTime =
        expectedDate == null ? null : DateTime.parse(expectedDate);
    final error = ref
        .watch(bookingFormErrorsProvider)
        .get(LeadFormFields.expectedDeliveryDate);
    final canEdit = ref.watch(canEditBookingProvider);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.expectedDateOfDelivery.tr(),
      isRequired: true,
      minTime: DateTimeConstants.currentMinDateTime,
      mode: CupertinoDatePickerMode.date,
      initTime: selectedDateTime,
      ignoring: !canEdit,
      onChange: (newDate) {
        ref
            .read(selectedBookingProvider.notifier)
            .update(
              (select) =>
                  select = select?.copyWith(
                    expectedDelivery: newDate.formatDateTime(),
                  ),
            );
        ref
            .read(bookingFormErrorsProvider.notifier)
            .remove(LeadFormFields.expectedDeliveryDate);
      },
      errorText: error?.message,
    );
  }

  Widget get _amountCollectedDateWidget {
    final error = ref
        .watch(bookingFormErrorsProvider)
        .get(LeadFormFields.amountCollected);
    final receipts = ref
        .watch(bookingReceiptsProvider)
        .filteredReceipts(type: ReceiptType.booking);
    final amountCollected = receipts.amount;

    return SalesdocketTextInfoWidget(
      label: LocaleKeys.amountCollected.tr(),
      isRequired: true,
      text: amountCollected.formatIndianCommas,
      onClicked: () {
        _moveToReceiptScreen();
      },
      showIcon: amountCollected > 0,
      errorText: error?.message,
      onIconClicked: () {
        _moveToReceiptListScreen();
      },
    );
  }

  Widget get _dateOfBookingWidget {
    final booking = ref.watch(selectedBookingProvider);
    final bookingDate = booking?.bookingDate;
    final selectedDateTime =
        bookingDate == null ? null : DateTime.parse(bookingDate);
    final error = ref
        .watch(bookingFormErrorsProvider)
        .get(LeadFormFields.dateOfBooking);
    final canEdit = ref.watch(canEditBookingProvider);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.dateOfBooking.tr(),
      isRequired: true,
      maxTime: DateTimeConstants.currentMaxDateTime,
      mode: CupertinoDatePickerMode.date,
      initTime: selectedDateTime,
      ignoring: !canEdit,
      onChange: (newDate) {
        ref
            .read(selectedBookingProvider.notifier)
            .update(
              (select) =>
                  select = select?.copyWith(
                    bookingDate: newDate.formatDateTime(),
                  ),
            );
        ref
            .read(bookingFormErrorsProvider.notifier)
            .remove(LeadFormFields.dateOfBooking);
      },
      errorText: error?.message,
    );
  }

  void _moveToReceiptScreen() {
    final canEdit = ref.read(canEditBookingProvider);
    if (!canEdit) return;

    final lead = ref.read(bookingLeadRequestProvider);
    ref.read(receiptLeadProvider.notifier).update((state) => state = lead);
    ref
        .read(receiptSourceProvider.notifier)
        .update((state) => state = ReceiptType.booking);
    ref
        .read(sendReceiptRequestProvider.notifier)
        .update(
          (state) => Receipt(leadId: lead?.id, type: ReceiptType.booking.value),
        );
    context.router.push(const AddEditReceiptRoute()).then((_) {
      fetchReceipts(leadId: lead?.id);
    });
  }

  void _moveToReceiptListScreen() {
    final lead = ref.read(bookingLeadRequestProvider);
    final canEdit = ref.watch(canEditBookingProvider);

    ref.read(receiptLeadProvider.notifier).update((state) => state = lead);
    ref
        .read(receiptSourceProvider.notifier)
        .update((state) => state = ReceiptType.booking);
    ref
        .read(canEditReceiptProvider.notifier)
        .update((state) => state = canEdit);
    context.router.push(const ReceiptListRoute()).then((_) {
      fetchReceipts(leadId: lead?.id);
    });
  }

  void _setupAmountCollected() {
    final receipts = ref
        .read(bookingReceiptsProvider)
        .filteredReceipts(type: ReceiptType.booking);
    final amountCollected = receipts.amount;
    ref
        .read(selectedBookingProvider.notifier)
        .update(
          (select) =>
              select = select?.copyWith(
                amountCollected: amountCollected == 0 ? null : amountCollected,
              ),
        );
    ref
        .read(bookingFormErrorsProvider.notifier)
        .remove(LeadFormFields.amountCollected);
  }

  @override
  void onReceiptsFetched(List<Receipt> list) {
    ref.read(bookingReceiptsProvider.notifier).update((state) => state = list);
    _setupAmountCollected();
  }

  @override
  WidgetRef get eventRef => ref;
}
