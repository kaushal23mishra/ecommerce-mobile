import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadHistoryItemWidget extends SalesdocketStatelessWidget {
  final LeadHistory leadHistory;

  const LeadHistoryItemWidget({super.key, required this.leadHistory});

  @override
  Widget build(BuildContext context) {
    final historyStatus = getStatus(leadHistory);
    final historyDate = leadHistory.workflow?.dueDate?.formatDateTime() ?? "";
    final hasHistoryHeader =
        historyDate.trim().isNotEmpty ||
        historyStatus.isNotEmpty ||
        leadHistory.createdBy != null;

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
            Container(
              width: 1.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  bottomLeft: Radius.circular(3.w),
                ),
                color:
                    leadHistory.status == 1
                        ? appColors.success
                        : leadHistory.status == null
                        ? appColors.secondary
                        : appColors.redDark,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasHistoryHeader)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            Text(
                              historyDate,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: appColors.textDisabled,
                                fontSize: 15.sp,
                              ),
                            ),
                            if (historyDate.trim().isNotEmpty)
                              horizontalSpacing(2.w),
                            Expanded(
                              child: Text(
                                historyStatus.sentenceToCamelCase,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: appColors.textDisabled),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              leadHistory.createdBy?.fullName ?? "",
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: appColors.textDisabled,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    _customerCommentWidget(context, leadHistory),
                    verticalSpacing(1.h),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        leadHistory.createdAt?.formatDateTime() ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _customerCommentWidget(BuildContext context, LeadHistory leadHistory) {
    var comment =
        (leadHistory.leadHistoryResponse?.comment ??
            leadHistory.notDoneReason) ??
        "";
    if (leadHistory.leadProgress == "LOST") {
      comment = comment.contains("rReactivate -") ? comment : "Lost";
    }

    return comment.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            comment,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: appColors.textDisabled),
          ),
        );
  }

  String getStatus(LeadHistory history) {
    switch (history.responseType?.toLowerCase()) {
      case "dealer visit":
        return "Showroom visit";
      case "lpa_call":
        return "LPA Call";
      case "registration_comment":
        return "Comment";
      default:
        return history.responseType ?? "";
    }
  }
}

class LeadHistoryItemShimmerWidget extends SalesdocketStatelessWidget {
  const LeadHistoryItemShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SalesDocketShimmerWidget.rectangular(height: 2.h, width: 25.w),
              SalesDocketShimmerWidget.rectangular(height: 2.h, width: 20.w),
            ],
          ),
          verticalSpacing(0.5.h),
          SalesDocketShimmerWidget.rectangular(height: 2.h, width: 40.w),
          verticalSpacing(0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SalesDocketShimmerWidget.rectangular(height: 2.h, width: 20.w),
            ],
          ),
        ],
      ),
    );
  }
}
