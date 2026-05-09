import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/followup/providers/cc_lead_followups_provider.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/entity/followup_data_given.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../booking/view_model/booking_view_model.dart';

/// Widget for displaying lead history specifically for CC (Call Center) leads
/// This component shows recent follow-ups and interactions for CC leads
class CCLeadHistoryWidget extends SalesdocketConsumerStatefulWidget {
  const CCLeadHistoryWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CCLeadHistoryState();
}

class _CCLeadHistoryState extends SalesdocketConsumerState<CCLeadHistoryWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lead = ref.read(followupLeadRequestProvider);
      setupStatusBar();
      _invalidateProviders();
      _initProviders(lead);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lead = ref.watch(followupLeadRequestProvider);



    final followupsAsync =
        ref.watch(cCLeadFollowupsProvider(lead!.id!));

    return followupsAsync.when(
      data: (followups) {
        // Skip the first followup (current/active one) and show max 3 past followups
        // Skip index 0, then take next 3 (index 1, 2, 3)
        final displayFollowups = followups.length > 1
            ? followups.skip(1).take(3).toList()
            : <CCLeadFollowup>[];

        if (displayFollowups.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.lblRecentFollowUps.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            verticalSpacing(1.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayFollowups.length,
              itemBuilder: (context, index) {
                return _CCLeadFollowupItem(followup: displayFollowups[index]);
              },
            ),
          ],
        );
      },
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:  CircularProgressIndicator(color: appColors.primary)
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  void _initProviders(Lead? lead) {
    ref
        .read(selectBrandAndModelProvider.notifier)
        .update((_) => lead?.interestedInCompDetails);

    ref
        .read(selectedExchangeHouseProvider.notifier)
        .update((_) => lead?.bookingExchangeHouse);

    ref
        .read(followupRequestProvider.notifier)
        .update((_) => const FollowupDataGiven());
  }

  void _invalidateProviders() {
    final notifiers = [createFollowUpFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
    final providers = [
      selectBrandAndModelProvider,
      followupRequestProvider,
      followupTestDriveGivenProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }
}

/// Widget to display individual CC lead followup item
class _CCLeadFollowupItem extends SalesdocketConsumerWidget {
  final CCLeadFollowup followup;

  const _CCLeadFollowupItem({required this.followup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = followup.isDone == 1 && followup.followupResponse == 0;
    final dueDate = followup.followupDueAt ?? '';
    final createdDate = followup.createdAt ?? '';
    final responseRemarks = followup.followupResponseRemarks ?? '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left color bar
            Container(
              width: 1.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
                color: isDone ? appColors.success : appColors.redDark,
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with due date and status
                    if (dueDate.isNotEmpty )
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            if (dueDate.isNotEmpty) ...[
                              Text(
                                _formatDate(dueDate),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: appColors.textDisabled,
                                      fontSize: 15.sp,
                                    ),
                              ),
                              horizontalSpacing(2.w),
                            ],

                          ],
                        ),
                      ),
                    // Response remarks
                    if (responseRemarks.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          responseRemarks,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: appColors.textDisabled),
                        ),
                      ),
                    verticalSpacing(1.h),
                    // Created date at bottom right
                    if (createdDate.isNotEmpty)
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatDate(createdDate),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: appColors.textDisabled,
                                    fontSize: 15.sp,
                                  ),
                        ),
                      ),
                    verticalSpacing(0.5.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('MMM dd, yyyy hh:mm a');
      return formatter.format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
