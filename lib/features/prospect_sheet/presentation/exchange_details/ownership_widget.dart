import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_ownership_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';

class OwnershipWidget extends SalesdocketConsumerWidget {
  const OwnershipWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownership = ref.watch(
      selectedExchangeProductProvider.select((product) => product?.ownership),
    );

    return SalesdocketOwnershipWidget(
      ownership: ownership,
      isRequired: false,
      onChanged: (value) {
        ref.read(selectedExchangeProductProvider.notifier).update(
              (state) => state = state?.copyWith(ownership: value),
            );
      },
    );
  }
}
