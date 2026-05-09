import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/add_images_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/house_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/insurance_validity_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/interested_in_exchange_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/make_year_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/other_details_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/ownership_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/price_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/tyre_replacement_widget.dart';
import 'package:salesdocket_mobile/features/booking/presentation/exchange_details/vehicle_details_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import 'booking_date_of_evaluation_widget.dart';

class EditExchangeDetailsWidget extends SalesdocketConsumerWidget {
  const EditExchangeDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestedInExchange =
        ref.watch(bookingLeadRequestProvider)?.isExchange;

    final dateOfEvaluation = ref.watch(
      selectedExchangeProductProvider.select((p) => p?.dateOfEvaluation),
    );

    final exchangeType = ref.watch(
      selectedExchangeHouseProvider.select((p) => p?.exchangeType),
    );

    final user = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (interestedInExchange == 1)
          Padding(
            padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
            child: const HouseWidget(),
          ),
        const InterestedInExchangeWidget(),
        if (interestedInExchange == 1)
          _buildExchangeDetailsWidget(dateOfEvaluation, user, exchangeType),
      ],
    );
  }

  Widget _buildExchangeDetailsWidget(
    String? dateOfEvaluation,
    User? user,
    String? exchangeType,
  ) {
    final shouldShowDate =
        (dateOfEvaluation != null && !(user?.isEvaluator ?? false)) ||
        (user?.isEvaluator ?? false);

    final isInHouse = exchangeType == ExchangeType.inHouse.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(1.h),
        const VehicleDetailsWidget(),
        verticalSpacing(2.h),
        Row(
          spacing: 4.w,
          children: const [
            Expanded(child: MakeYearWidget()),
            Expanded(child: OwnershipWidget()),
          ],
        ),
        if (!isInHouse) ...[
          verticalSpacing(2.h),
          const InsuranceValidityWidget(),
          verticalSpacing(2.h),
          const TyreReplacementWidget(),
        ],
        verticalSpacing(2.h),
        const OtherDetailsWidget(),
        verticalSpacing(3.h),
        const PriceWidget(),
        verticalSpacing(2.h),
        if (shouldShowDate) const BookingDateOfEvaluationWidget(),
        verticalSpacing(2.h),
        const AddImagesWidget(),
      ],
    );
  }
}
