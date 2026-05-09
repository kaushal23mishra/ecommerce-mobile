import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingPersonalDetails extends SalesdocketConsumerWidget {
  const BookingPersonalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(bookingLeadRequestProvider);
    final detailItems = (lead?.booking ?? const Booking())
        .bookingPersonalDetailItems(lead);

    if (detailItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: SalesdocketDetailsCardWidget(
        label: LocaleKeys.personalDetails.tr(),
        items: detailItems,
      ),
    );
  }
}
