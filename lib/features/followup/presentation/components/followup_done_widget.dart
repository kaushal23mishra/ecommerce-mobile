import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/core/sizer/sizer.dart';
import 'package:salesdocket_ui_component/widget/salesdocket_button_widget.dart';
import 'package:salesdocket_ui_component/widget/salesdocket_spacing.dart';

class FollowUpDoneWidget extends SalesdocketConsumerWidget {
  final void Function(WidgetRef, bool) updateStatus;

  const FollowUpDoneWidget({super.key, required this.updateStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          'Follow up Status:',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: appColors.textPrimary),
        ),
        horizontalSpacing(3.w),
        Expanded(
          child: SalesDocketButtonWidget(
            onPressed: () => updateStatus(ref, true),
            text: "Done",
          ),
        ),
        Expanded(
          child: SalesDocketButtonWidget(
            onPressed: () => updateStatus(ref, false),
            text: "Not Done",
          ),
        ),
      ],
    );
  }
}
