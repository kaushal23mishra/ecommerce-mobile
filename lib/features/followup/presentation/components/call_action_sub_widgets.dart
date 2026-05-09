import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:easy_localization/easy_localization.dart';

import 'booking_followup_spoke_widget.dart';
import 'new_lead_status_widget.dart';
import 'not_done_component/done_document_widget.dart';
import 'not_done_component/met_whom_widget.dart';
import 'not_done_component/not_done_reason_widget.dart';
import 'not_done_component/visit_by_widget.dart';
import 'not_done_component/visit_date_widget.dart';

class DoneWidgets extends ConsumerWidget {
  const DoneWidgets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowroomVisit = ref.watch(isShowroomVisitProvider);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: VisitDateWidget()),
            SizedBox(width: 2.w),
            Expanded(
              child:
                  isShowroomVisit == 1
                      ? const VisitByWidget()
                      : const MetWhomWidget(),
            ),
          ],
        ),
        if (isShowroomVisit == 1) const DoneDocumentWidget(),
        const NewLeadStatusWidget(),
        SizedBox(height: 2.h),
      ],
    );
  }
}

class NotDoneWidgets extends ConsumerWidget {
  const NotDoneWidgets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [const NotDoneReasonWidget(), SizedBox(height: 2.h)],
    );
  }
}

class AlreadySpokenWidgets extends ConsumerWidget {
  const AlreadySpokenWidgets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.read(leadListScreenTypeProvider).isBookingFollowup) {
      return const BookingFollowupAlreadySpokenWrapper();
    }
    return Column(
      children: [const NewLeadStatusWidget(), SizedBox(height: 2.h)],
    );
  }
}

class BookingFollowupAlreadySpokenWrapper extends ConsumerWidget {
  const BookingFollowupAlreadySpokenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.lblCallStatus.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          verticalSpacing(1.h),
          const BookingFollowupSpokeWidget(),
        ],
      ),
    );
  }
}
