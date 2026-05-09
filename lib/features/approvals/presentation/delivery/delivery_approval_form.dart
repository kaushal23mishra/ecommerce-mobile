import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/discount_extensions.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/approval_users_list_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/delivery/delivery_approval_action_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/more_discount_reason_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/optional_remarks_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/pending_commitments_widget.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/permitted_by_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryApprovalForm extends SalesdocketConsumerStatefulWidget {
  const DeliveryApprovalForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryApprovalFormState();
}

class _DeliveryApprovalFormState
    extends SalesdocketConsumerState<DeliveryApprovalForm> {
  @override
  Widget build(BuildContext context) {
    final discountApprovalRequest = ref.watch(discountApprovalRequestProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            if (discountApprovalRequest?.discountGivenInExcess == true)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: const MoreDiscountReasonWidget(),
              ),
            verticalSpacing(2.h),
            const PendingCommitmentsWidget(),
            if (discountApprovalRequest?.discountGivenInExcess == true)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: const PermittedByWidget(),
              ),
            verticalSpacing(2.h),
            const OptionalRemarksWidget(),
            verticalSpacing(3.h),
            const ApprovalUsersListWidget(),
            verticalSpacing(2.h),
            const DeliveryApprovalActionWidget(),
          ],
        ),
      ),
    );
  }
}
