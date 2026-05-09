import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BuyingDetailsWidget extends SalesdocketConsumerWidget {
  const BuyingDetailsWidget({
    super.key,
    required this.leadProvider,
    required this.testDriveProvider,
    required this.buildDetailItems,
  });

  final StateProvider<Lead?> leadProvider;
  final StateProvider<TestDriveGiven?> testDriveProvider;
  final List<MenuItem> Function(
    Lead? lead,
    TestDriveGiven? testDriveGiven,
    InterestedInComp? interestedInComp,
    FirstTimeBuyer? firstTimeBuyer,
  ) buildDetailItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(leadProvider);
    final testDriveGiven = ref.watch(testDriveProvider);

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

    return SalesdocketDetailsCardWidget(
      items: buildDetailItems(
        lead,
        testDriveGiven,
        interestedInComp,
        firstTimeBuyer,
      ),
    );
  }
}
