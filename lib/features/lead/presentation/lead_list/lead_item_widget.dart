import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_details_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_footer_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_header_widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadItemWidget extends SalesdocketStatelessWidget {
  final Lead lead;
  final Function? onLeadClicked;
  final bool isSelected;
  final bool hasActions;
  final SalesdocketNotification? notification;

  const LeadItemWidget({
    super.key,
    required this.lead,
    this.onLeadClicked,
    this.isSelected = false,
    this.hasActions = true,
    this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onLeadClicked != null) {
          onLeadClicked!();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.75.h),
        decoration: BoxDecoration(
          color: appColors.secondary,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(color: appColors.border, width: 0.3.w),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeadItemHeaderWidget(lead: lead),
                LeadItemDetailsWidget(lead: lead, notification: notification),
                if (hasActions) LeadItemFooterWidget(lead: lead),
              ],
            ),
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: appColors.primary,
                    size: 12.w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
