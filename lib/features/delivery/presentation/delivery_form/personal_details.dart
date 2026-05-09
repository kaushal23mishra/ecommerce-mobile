import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/delivery_extensions.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DeliveryPersonalDetails extends SalesdocketConsumerWidget {
  const DeliveryPersonalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(deliveryLeadRequestProvider);
    final detailItems = (lead?.delivery ?? const Delivery())
        .deliveryPersonalDetailItems(lead);

    return SalesdocketDetailsCardWidget(
      label: LocaleKeys.personalDetails.tr(),
      items: detailItems,
    );
  }
}
