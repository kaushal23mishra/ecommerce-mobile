import 'package:flutter/widgets.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/widgets/buying_details_widget.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BuyingDetailsWidget(
      leadProvider: prevBookingLeadRequestProvider,
      testDriveProvider: prevSelectedTestDriveGivenProvider,
      buildDetailItems: (lead, testDriveGiven, interestedInComp, firstTimeBuyer) {
        final customerQuote = lead?.booking?.customerQuoteDetails;
        return (lead?.booking ?? const Booking())
            .initBooking(lead)
            .bookingBuyingDetailItems(
              lead,
              testDriveGiven,
              interestedInComp,
              firstTimeBuyer,
              customerQuote,
            );
      },
    );
  }
}
