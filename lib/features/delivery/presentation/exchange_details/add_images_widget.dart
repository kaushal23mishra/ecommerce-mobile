import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_exchange_images_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AddImagesWidget extends SalesdocketConsumerWidget {
  const AddImagesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addExchangeVehicleImages = ref.watch(
      addExchangeVehicleImagesProvider,
    );
    final addMoreExchangeVehicleImages = ref.watch(
      addMoreExchangeVehicleImagesProvider,
    );
    final exchangeImages = ref.watch(exchangeImagesProvider);

    return SalesdocketExchangeImagesWidget(
      images: exchangeImages,
      canAddImages: addExchangeVehicleImages,
      canAddMoreImages: addMoreExchangeVehicleImages,
      onAddImagesChanged: (value) {
        ref
            .read(addExchangeVehicleImagesProvider.notifier)
            .update((state) => state = value);
        ref.invalidate(addMoreExchangeVehicleImagesProvider);
      },
      onAddMoreImagesChanged: (value) {
        ref
            .read(addMoreExchangeVehicleImagesProvider.notifier)
            .update((state) => state = value);
      },
      onChanged: (value) {
        ref
            .read(exchangeImagesProvider.notifier)
            .update((state) => state = value);
      },
    );
  }
}
