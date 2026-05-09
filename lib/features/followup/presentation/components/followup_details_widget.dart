import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/classes/salesdocket_consumer_state.dart';

class FollowupDetailsWidget extends SalesdocketConsumerWidget {
  const FollowupDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(followupLeadRequestProvider);
    final followupAction = lead?.workflow?.actions?.lastOrNull;
    final dueDate = followupAction?.dueDate;

    final action = followupAction?.action ?? "";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.3.w),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                lead!.isItCCLead ?
                Text(
                  lead.followups?.firstOrNull?.followupDueAt
                          ?.formatDateTime() ??
                      "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textPrimary,
                    fontSize: 15.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ):
                Text(
                  (dueDate?.formatDateTime() ??
                          lead.followups?.firstOrNull?.createdAt
                              ?.formatDateTime()) ??
                      "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textPrimary,
                    fontSize: 15.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                horizontalSpacing(2.w),
                Flexible(
                  child: Text(
                    _formatAction(
                      action.isNotEmpty
                          ? action
                          : (lead.followups?.isNotEmpty ?? false)
                          ? lead.followups!.first.followupType ?? ''
                          : '',
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: appColors.textDisabled,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _pendingWidget(context),
                horizontalSpacing(2.w),
                _nameWidget(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAction(String action) {
    switch (action.toLowerCase()) {
      case 'dealer visit':
        return 'Showroom visit';
      case 'lpa_call':
        return 'Call';
      case 'call':
        return 'Call';
      default:
        return action;
    }
  }

  Widget _pendingWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.warning,
        borderRadius: BorderRadius.circular(1.w),
      ),
      padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 1.w),
      child: Text(
        'Pending',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: appColors.textSecondary),
      ),
    );
  }

  Widget _nameWidget(BuildContext context, WidgetRef ref) {
    final leadHistory = ref
        .watch(followupLeadHistoryProvider)
        .lastWhereOrNull((history) => history.responseType != "test_drive");

    return Text(
      leadHistory?.createdBy?.fullNameWOSalutation ?? "",
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: appColors.textPrimary,
        fontSize: 15.sp,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
