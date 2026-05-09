import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/approval_users_list_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/booking/booking_approval_action_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/more_discount_reason_widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingApprovalForm extends SalesdocketConsumerStatefulWidget {
  const BookingApprovalForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingApprovalFormState();
}

class _BookingApprovalFormState
    extends SalesdocketConsumerState<BookingApprovalForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            verticalSpacing(2.h),
            const MoreDiscountReasonWidget(),
            verticalSpacing(3.h),
            const ApprovalUsersListWidget(),
            verticalSpacing(2.h),
            const BookingApprovalActionWidget(),
          ],
        ),
      ),
    );
  }
}
