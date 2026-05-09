import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_address_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AddressWidget extends SalesdocketConsumerStatefulWidget {
  const AddressWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends SalesdocketConsumerState<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    final errors = ref.watch(deliveryFormErrorsProvider);

    return SalesdocketAddressWidget(
      errors: errors,
      removeError: (field) {
        ref.read(deliveryFormErrorsProvider.notifier).remove(field);
      },
    );
  }
}
