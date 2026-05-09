import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingFormDetailsWidget extends SalesdocketConsumerWidget {
  const BookingFormDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(bookingLeadRequestProvider);
    final detailItems = lead?.bookingForm ?? [];

    if (detailItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: SalesdocketDetailsCardWidget(
        label: LocaleKeys.bookingDetails.tr(),
        items: detailItems,
      ),
    );
  }
}
