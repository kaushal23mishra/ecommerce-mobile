import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/notification_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/features/notification/presentation/notification_item_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadItemDetailsWidget extends SalesdocketStatelessWidget {
  final Lead lead;
  final SalesdocketNotification? notification;

  const LeadItemDetailsWidget({
    super.key,
    required this.lead,
    this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final detailItems = LeadUtils.getDetailItems(
      lead,
      showEvaluationDetails: notification?.showEvaluationDetails == true,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      child: Column(
        children: [
          NotificationHeader(notification: notification),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3.w,
            children: [
              _carWidget(context),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      itemCount: detailItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = detailItems[index];
                        return _detailRow(context, item: item);
                      },
                    ),
                    if (lead.id != null &&
                        (lead.workflow?.isDelivered ?? false))
                      Consumer(
                        builder: (context, ref, _) {
                          final asyncReasons = ref.watch(
                            deliveryLeadPendingDisplayReasonsProvider(lead.id!),
                          );
                          return asyncReasons.maybeWhen(
                            data: (reasons) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: reasons.map((reason) {
                                  final label = reason.reason ==
                                          ReceiptReasonType
                                              .oldCarPaymentPendingFromAgent
                                              .value
                                      ? LocaleKeys.oldCarPendingFromAgent.tr()
                                      : LocaleKeys.creditGivenToCustomer.tr();
                                  return _detailRow(
                                    context,
                                    item: MenuItem(
                                      title: '$label:',
                                      subtitle:
                                          '₹${(reason.pendingAmount ?? 0).toStringAsFixed(0)}',
                                      show: true,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                            orElse: () => const SizedBox.shrink(),
                          );
                        },
                      ),
                    _leadIconsWidget(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, {required MenuItem item}) {
    return item.show && (item.subtitle ?? "").isNotEmpty
        ? Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: RichText(
            softWrap: true,
            text: TextSpan(
              children: [
                TextSpan(
                  text: item.title,
                  style:
                      item.titleStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: appColors.grayDark,
                      ),
                ),
                if ((item.title ?? "").isNotEmpty)
                  WidgetSpan(child: SizedBox(width: 1.w)),
                TextSpan(
                  text: item.subtitle,
                  style:
                      item.subtitleStyle ??
                      Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontSize: 15.sp),
                ),
              ],
            ),
          ),
        )
        : const SizedBox.shrink();
  }

  Widget _carWidget(BuildContext context) {
    final carImage = lead.productImage;

    return SizedBox(
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
                    ? Padding(
                      padding: EdgeInsets.all(4.w),
                      child: SalesDocketImageWidget(
                        imagePath: Assets.images.appLogo.path,
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
              lead.primaryCarName,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: appColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadIconsWidget(BuildContext context) {
    final widgets = <Widget>[].toList();
    if (lead.isExchange == 1 || lead.campaign?.isExchange == 1) {
      widgets.add(
        SalesDocketImageWidget(
          imagePath: Assets.svg.carExchange.path,
          width: 8.w,
        ),
      );
    }
    if (lead.purchaseMode?.toLowerCase() ==
        PurchaseMode.finance.value.toLowerCase()) {
      widgets.add(
        SalesDocketImageWidget(imagePath: Assets.svg.finance.path, width: 8.w),
      );
    }
    if (lead.isTestDriveGiven == 1) {
      widgets.add(
        SalesDocketImageWidget(
          imagePath: Assets.images.testDrive.path,
          width: 6.w,
        ),
      );
    }
    if (lead.isHoCampaign == 1) {
      widgets.add(
        SalesDocketImageWidget(
          imagePath: Assets.images.hoLeadsIcon.path,
          width: 6.w,
        ),
      );
    }
    if (lead.isItCCLead) {
      widgets.add(
        SalesDocketImageWidget(
          imagePath: Assets.images.coldCallingIcon.path,
          width: 6.w,
        ),
      );
    }

    return widgets.isNotEmpty
        ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6.w,
          children: widgets,
        )
        : const SizedBox.shrink();
  }
}
