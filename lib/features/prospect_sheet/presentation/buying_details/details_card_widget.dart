import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/prospect_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DetailsCardWidget extends SalesdocketConsumerWidget {
  const DetailsCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(prevProspectLeadRequestProvider);
    final testDriveGiven = ref.watch(selectedTestDriveGivenProvider);
    final selectedLeadSource = ref.watch(selectedLeadSourceProvider);

    final interestedInCompBrands = ref
        .watch(competitionProductsProvider)
        .map((brand) => brand.brand);
    final interestedInCompModels = ref.watch(competitionModelsProvider).toSet();
    var interestedInComp = lead?.interestedInCompDetails;
    interestedInComp = interestedInComp?.copyWith(
      brandName:
          interestedInCompBrands
              .firstWhereOrNull((brand) => brand?.id == interestedInComp?.brand)
              ?.name,
      modelName:
          interestedInCompModels
              .firstWhereOrNull((model) => model.id == interestedInComp?.model)
              ?.name,
    );

    final firstTimeBuyerBrands = ref.watch(brandsProvider);
    final firstTimeBuyerModels = ref.watch(brandModelsProvider);
    var firstTimeBuyer = lead?.oldVehicleDetails;
    firstTimeBuyer = firstTimeBuyer?.copyWith(
      oldVehicleName:
          firstTimeBuyerBrands
              .firstWhereOrNull(
                (brand) => brand.brandId == firstTimeBuyer?.oldVehicleId,
              )
              ?.brandName,
      oldVehicleVariantName:
          firstTimeBuyerModels
              .firstWhereOrNull(
                (model) =>
                    model.productId == firstTimeBuyer?.oldVehicleVariantId,
              )
              ?.productName,
    );

    final customerQuote = lead?.customerQuoteDetails;

    final detailItems =
        lead?.prospectBuyingDetailsItems(
          testDriveGiven: testDriveGiven,
          firstTimeBuyer: firstTimeBuyer,
          interestedInComp: interestedInComp,
          customerQuote: customerQuote,
          selectedLeadSource: selectedLeadSource,
        ) ??
        [];

    return SalesdocketDetailsCardWidget(items: detailItems);
  }
}
