import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/stepper_item.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/delivery_form.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/buying_details/delivery_buying_details.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/exchange_details/delivery_exchange_details.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/offer_details/delivery_offer_details.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/delivery_payment_details.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/personal_details/delivery_personal_details.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';

List<StepperItem> deliveryStepItems(Lead? lead) {
  final isFirstTimeBuyer = lead?.isFirstTimeBuyer ?? false;
  final delivery = lead?.delivery;
  final isDeliveryCreated =
      delivery != null && delivery.id != null && delivery.addressId != null;

  return [
    StepperItem(
      step: 1,
      title: 'Personal\nDetails',
      content: const DeliveryPersonalDetails(),
      imagePath: Assets.svg.person.path,
    ),
    StepperItem(
      step: 2,
      title: 'Buying\nDetails',
      content: const DeliveryBuyingDetails(),
      imagePath: Assets.svg.cart.path,
      isDisabled: !isDeliveryCreated,
    ),
    StepperItem(
      step: 3,
      title: 'Exchange\nDetails',
      content: const DeliveryExchangeDetails(),
      imagePath: Assets.svg.carExchange.path,
      isDisabled: !isDeliveryCreated || isFirstTimeBuyer,
    ),
    StepperItem(
      step: 4,
      title: 'Offers\nDetails',
      content: const DeliveryOfferDetails(),
      imagePath: Assets.svg.offer.path,
      isDisabled: !isDeliveryCreated,
    ),
    StepperItem(
      step: 5,
      title: 'Payment\nDetails',
      content: const DeliveryPaymentDetails(),
      imagePath: Assets.svg.paymentDetail.path,
      isDisabled: !isDeliveryCreated,
    ),
    StepperItem(
      step: 6,
      title: 'Delivery\nForm',
      content: const DeliveryForm(),
      imagePath: Assets.svg.delivery.path,
      isDisabled: !isDeliveryCreated,
    ),
  ];
}
