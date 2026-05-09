import 'package:flutter/widgets.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/widgets/buying_details_widget.dart';
import 'package:salesdocket_mobile/common/extensions/delivery_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BuyingDetailsWidget(
      leadProvider: prevDeliveryLeadRequestProvider,
      testDriveProvider: prevTestDriveGivenProvider,
      buildDetailItems: (lead, testDriveGiven, interestedInComp, firstTimeBuyer) {
        final customerQuote = lead?.delivery?.customerQuoteDetails;
        return (lead?.delivery ?? const Delivery())
            .initDelivery(lead)
            .deliveryBuyingDetailItems(
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
