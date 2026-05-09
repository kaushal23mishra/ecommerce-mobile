import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/stepper_item.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/booking/presentation/booking_form/booking_form.dart';
import 'package:salesdocket_mobile/features/booking/presentation/buying_details/booking_buying_details.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/booking_exchange_details.dart';
import 'package:salesdocket_mobile/features/booking/presentation/offer_details/booking_offer_details.dart';
import 'package:salesdocket_mobile/features/booking/presentation/personal_details/booking_personal_details.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';

List<StepperItem> bookingStepItems(Lead? lead) {
  final isFirstTimeBuyer = lead?.isFirstTimeBuyer ?? false;
  final booking = lead?.booking;
  final isBookingCreated =
      booking != null && booking.id != null && booking.addressId != null;

  return [
    StepperItem(
      step: 1,
      title: 'Personal\nDetails',
      content: const BookingPersonalDetails(),
      imagePath: Assets.svg.person.path,
    ),
    StepperItem(
      step: 2,
      title: 'Buying\nDetails',
      content: const BookingBuyingDetails(),
      imagePath: Assets.svg.cart.path,
      isDisabled: !isBookingCreated,
    ),
    StepperItem(
      step: 3,
      title: 'Exchange\nDetails',
      content: const BookingExchangeDetails(),
      imagePath: Assets.svg.carExchange.path,
      isDisabled: !isBookingCreated || isFirstTimeBuyer,
    ),
    StepperItem(
      step: 4,
      title: 'Offers\nDetails',
      content: const BookingOfferDetails(),
      imagePath: Assets.svg.offer.path,
      isDisabled: !isBookingCreated,
    ),
    StepperItem(
      step: 5,
      title: 'Booking\nForm',
      content: const BookingForm(),
      imagePath: Assets.svg.booking.path,
      isDisabled: !isBookingCreated,
    ),
  ];
}
