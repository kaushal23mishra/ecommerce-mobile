import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/notification_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItemWidget extends SalesdocketConsumerWidget {
  final SalesdocketNotification notification;
  final VoidCallback onItemClicked;
  final bool isLastItem;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onItemClicked,
    this.isLastItem = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loggy.debug(notification.alertType);
    final lead = notification.lead;

    return GestureDetector(
      onTap: onItemClicked,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.secondary,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(color: appColors.border, width: 0.3.w),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (lead?.stateColor != null)
                Container(
                  width: 1.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w),
                    ),
                    color: lead?.stateColor,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 3.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NotificationHeader(notification: notification),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _carWidget(context),
                              Expanded(
                                child: Text(
                                  notification.notificationBody?.trim() ?? "",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: appColors.textPrimary,
                                    fontSize: 15.sp,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carWidget(BuildContext context) {
    final lead = notification.lead;
    final carImage = lead?.productImage;
    final vehicleName = lead?.primaryCarName ?? notification.vehicleName;

    return carImage == null && vehicleName.isEmpty
        ? SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.only(right: 3.w),
          child: SizedBox(
            width: 30.w,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: appColors.primaryLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1.w),
                      topRight: Radius.circular(1.w),
                    ),
                  ),
                  child:
                      carImage == null || carImage.isEmpty
                          ? Container(
                            width: 30.w,
                            padding: EdgeInsets.all(2.w),
                            child: Image.asset(
                              Assets.images.appLogo.path,
                              height: 12.w,
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1.w),
                              topRight: Radius.circular(1.w),
                            ),
                            child: SalesDocketImageWidget(
                              width: 30.w,
                              imagePath: carImage,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                ),
                Container(
                  width: 30.w,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: appColors.grayLight,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(1.w),
                      bottomRight: Radius.circular(1.w),
                    ),
                  ),
                  child: Text(
                    lead?.primaryCarName ?? vehicleName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: appColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

class NotificationHeader extends SalesdocketStatelessWidget {
  final SalesdocketNotification? notification;

  const NotificationHeader({super.key, this.notification});

  @override
  Widget build(BuildContext context) {
    if (notification == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              notification?.notificationTitle ?? "",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: appColors.textTertiary,
                fontSize: 15.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            timeago.format(
              notification?.createdAt?.toDateTime() ?? DateTime.now(),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: appColors.link),
          ),
        ],
      ),
    );
  }
}