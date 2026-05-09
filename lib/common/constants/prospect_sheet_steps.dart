import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/stepper_item.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/buying_details/prospect_sheet_buying_details.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/exchange_details/prospect_sheet_exchange_details.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/offer_details/prospect_sheet_offer_details.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/prospect_sheet_personal_details.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/prospect_sheet_plan_followup.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';

List<StepperItem> prospectStepItems(Lead? lead, bool isEvaluator) {
  final isFirstTimeBuyer = lead?.isFirstTimeBuyer ?? false;

  return [
    StepperItem(
      step: 1,
      title: 'Personal\nDetails',
      content: const ProspectSheetPersonalDetails(),
      imagePath: Assets.svg.person.path,
      isDisabled: isEvaluator,
    ),
    StepperItem(
      step: 2,
      title: 'Buying\nDetails',
      content: const ProspectSheetBuyingDetails(),
      imagePath: Assets.svg.cart.path,
      isDisabled: isEvaluator,
    ),
    StepperItem(
      step: 3,
      title: 'Exchange\nDetails',
      content: const ProspectSheetExchangeDetails(),
      imagePath: Assets.svg.carExchange.path,
      isDisabled: isFirstTimeBuyer,
    ),
    StepperItem(
      step: 4,
      title: 'Offers\nDetails',
      content: const ProspectSheetOfferDetails(),
      imagePath: Assets.svg.offer.path,
      isDisabled: isEvaluator,
    ),
    StepperItem(
      step: 5,
      title: 'Plan\nFollow-up',
      content: const ProspectSheetPlanFollowup(),
      imagePath: Assets.svg.registration.path,
      isDisabled: isEvaluator,
    ),
  ];
}

List<StepperItem> prospectStepItems1(Lead? lead) {
  final isFirstTimeBuyer = lead?.isFirstTimeBuyer ?? false;

  return [
    StepperItem(
      step: 1,
      title: 'Exchange\nDetails',
      content: const ProspectSheetExchangeDetails(),
      imagePath: Assets.svg.carExchange.path,
      isDisabled: isFirstTimeBuyer,
    ),
  ];
}
