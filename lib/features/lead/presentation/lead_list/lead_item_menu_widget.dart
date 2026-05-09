import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadItemMenuWidget extends StatelessWidget {
  final List<LeadListItemMenuAction> actions;

  const LeadItemMenuWidget({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return SalesdocketMenuBottomSheet(
      items:
          _menuItems
              .where(
                (item) =>
                    actions.map((action) => action.value).contains(item.text),
              )
              .toList(),
      hasClose: true,
    );
  }

  List<BottomSheetItem> get _menuItems {
    return [
      _callItem,
      // _messageItem,
      // _whatsappItem,
      // _emailItem,
      _transferLeadItem,
      _reactivateItem,
      _validateItem,
      _followupHistoryItem,
      _testDriveItem,
      _cancelBookingItem,
      _inactiveBooking,
      _iconOfPaymentReceiptItem,
      _addDeliveryReceiptItem,
      _viewDeliveryReceiptItem,
      _bookingFollowupItem,
    ];
  }

  BottomSheetItem get _bookingFollowupItem => BottomSheetItem(
        text: LeadListItemMenuAction.bookingFollowup.value,
        key: LeadListItemMenuAction.bookingFollowup,
        iconWidget: Icon(Icons.book_online, size: 5.w),
      );

  BottomSheetItem get _callItem => BottomSheetItem(
    text: LeadListItemMenuAction.call.value,
    key: LeadListItemMenuAction.call,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.svg.phoneCall.path,
      width: 5.w,
    ),
  );

  // BottomSheetItem get _messageItem => BottomSheetItem(
  //   text: LeadListItemMenuAction.message.value,
  //   key: LeadListItemMenuAction.message,
  //   iconWidget: SalesDocketImageWidget(
  //     imagePath: Assets.svg.message.path,
  //     width: 5.w,
  //   ),
  // );

  // BottomSheetItem get _whatsappItem => BottomSheetItem(
  //   text: LeadListItemMenuAction.whatsapp.value,
  //   key: LeadListItemMenuAction.whatsapp,
  //   iconWidget: SalesDocketImageWidget(
  //     imagePath: Assets.svg.whatsapp.path,
  //     width: 5.w,
  //   ),
  // );

  // BottomSheetItem get _emailItem => BottomSheetItem(
  //   text: LeadListItemMenuAction.email.value,
  //   key: LeadListItemMenuAction.email,
  //   iconWidget: SalesDocketImageWidget(
  //     imagePath: Assets.svg.email.path,
  //     width: 5.w,
  //   ),
  // );

  BottomSheetItem get _transferLeadItem => BottomSheetItem(
    text: LeadListItemMenuAction.transferLead.value,
    key: LeadListItemMenuAction.transferLead,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.svg.transfer.path,
      width: 5.w,
    ),
  );

  BottomSheetItem get _followupHistoryItem => BottomSheetItem(
    text: LeadListItemMenuAction.followupHistory.value,
    key: LeadListItemMenuAction.followupHistory,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.svg.followupHistory.path,
      width: 5.w,
    ),
  );

  BottomSheetItem get _testDriveItem => BottomSheetItem(
    text: LeadListItemMenuAction.testDrive.value,
    key: LeadListItemMenuAction.testDrive,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.images.testDrive.path,
      width: 5.w,
    ),
  );

  BottomSheetItem get _cancelBookingItem => BottomSheetItem(
    text: LeadListItemMenuAction.cancelBooking.value,
    key: LeadListItemMenuAction.cancelBooking,
    iconWidget: Icon(Icons.cancel_outlined, size: 5.w),
  );

  BottomSheetItem get _inactiveBooking => BottomSheetItem(
    text: LeadListItemMenuAction.inactiveBooking.value,
    key: LeadListItemMenuAction.inactiveBooking,
    iconWidget: Icon(Icons.block, size: 5.w),
  );

  BottomSheetItem get _iconOfPaymentReceiptItem => BottomSheetItem(
    text: LeadListItemMenuAction.paymentReceipt.value,
    key: LeadListItemMenuAction.paymentReceipt,
    iconWidget: Icon(Icons.receipt_long, size: 5.w),
  );

  BottomSheetItem get _reactivateItem => BottomSheetItem(
    text: LeadListItemMenuAction.reactivate.value,
    key: LeadListItemMenuAction.reactivate,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.images.testDrive.path,
      width: 5.w,
    ),
  );

  BottomSheetItem get _validateItem => BottomSheetItem(
    text: LeadListItemMenuAction.validate.value,
    key: LeadListItemMenuAction.validate,
    iconWidget: SalesDocketImageWidget(
      imagePath: Assets.images.testDrive.path,
      width: 5.w,
    ),
  );

  BottomSheetItem get _addDeliveryReceiptItem => BottomSheetItem(
    text: LeadListItemMenuAction.addDeliveryReceipt.value,
    key: LeadListItemMenuAction.addDeliveryReceipt,
    iconWidget: Icon(Icons.add_circle_outline, size: 5.w),
  );

  BottomSheetItem get _viewDeliveryReceiptItem => BottomSheetItem(
    text: LeadListItemMenuAction.viewDeliveryReceipt.value,
    key: LeadListItemMenuAction.viewDeliveryReceipt,
    iconWidget: Icon(Icons.receipt_long, size: 5.w),
  );
}
