import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_add_remarks_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';

class AddRemarksWidget extends SalesdocketConsumerWidget {
  const AddRemarksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAddRemarks = ref.watch(addRemarksProvider);
    final quotation = ref.watch(quotationProvider);

    return SalesdocketAddRemarksWidget(
      canAddRemark: canAddRemarks,
      remark: quotation?.remark,
      onAddRemarksChanged: (value) {
        ref.read(addRemarksProvider.notifier).update((state) => state = value);
        ref
            .read(quotationProvider.notifier)
            .update((state) => state = state?.copyWith(remark: null));
      },
      onChanged: (value) {
        ref
            .read(quotationProvider.notifier)
            .update((state) => state = state?.copyWith(remark: value?.trim()));
      },
    );
  }
}
