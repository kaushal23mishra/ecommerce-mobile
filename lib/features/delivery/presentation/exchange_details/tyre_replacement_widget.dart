import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_tyre_replacement_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class TyreReplacementWidget extends SalesdocketConsumerWidget {
  const TyreReplacementWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeCar = ref.watch(selectedExchangeProductProvider);
    final canEditTyres = ref.watch(editTyreReplacementProvider);

    return SalesdocketTyreReplacementWidget(
      exchangeCar: exchangeCar,
      canEditTyre: canEditTyres,
      onChanged: (value) {
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update((state) => state = value);
      },
      onEditTyreReplacementChanged: (value) {
        ref
            .read(editTyreReplacementProvider.notifier)
            .update((state) => state = value);
      },
    );
  }
}
