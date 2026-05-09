import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_interested_in_exchange_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class InterestedInExchangeWidget extends SalesdocketConsumerWidget {
  const InterestedInExchangeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestedInExchange =
        ref.watch(deliveryLeadRequestProvider)?.isExchange;
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.exchange);

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: SalesdocketInterestedInExchangeWidget(
        interestedInExchange: interestedInExchange,
        error: error?.message,
        onStatusChanged: (value) {
          ref
              .read(deliveryLeadRequestProvider.notifier)
              .update(
                (toUpdate) => toUpdate = toUpdate?.copyWith(isExchange: value),
              );

          if (value == 1) {
            final car = ref.read(selectedExchangeCarProvider);
            ref
                .read(editExistingVehicleProvider.notifier)
                .update(
                  (toUpdate) =>
                      toUpdate =
                          car?.oldVehicleId == null ||
                          car?.oldVehicleVariantId == null,
                );

            // Auto-set First Time Buyer to "No" when Exchange is selected
            final currentFirstTimeBuyer = ref.read(
              selectedFirstTimeBuyerProvider,
            );
            ref
                .read(selectedFirstTimeBuyerProvider.notifier)
                .update(
                  (toUpdate) =>
                      toUpdate = (currentFirstTimeBuyer ??
                              const FirstTimeBuyer())
                          .copyWith(
                            isExistingVehicle: 1,
                          ), // 1 = "No" (has existing vehicle)
                );
          }

          ref
              .read(deliveryFormErrorsProvider.notifier)
              .remove(LeadFormFields.exchange);
        },
      ),
    );
  }
}
