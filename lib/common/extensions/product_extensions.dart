import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';

extension ProductExtension on Product {
  String carName(List<Product>? models) {
    if (productId == null ||
        variant.isNullOrEmpty ||
        models == null ||
        models.isEmpty) {
      return "N/A";
    }

    final modelName =
        models
            .firstWhereOrNull((element) => element.productId == productId)
            ?.productName;
    if (modelName.isNullOrEmpty) return "N/A";

    return "$modelName $variant";
  }
}

extension ExchangeProductImagesExtension on ExchangeProductImages {
  bool get hasImages {
    return !insuranceImage.isNullOrEmpty ||
        !rcBackImage.isNullOrEmpty ||
        !rcBackImage.isNullOrEmpty ||
        (carImages != null &&
                (!carImages![1].isNullOrEmpty ||
                    !carImages![2].isNullOrEmpty) ||
            hasExtraCarImages);
  }

  bool get hasExtraCarImages {
    return (carImages != null &&
        (!carImages![3].isNullOrEmpty ||
            !carImages![4].isNullOrEmpty ||
            !carImages![5].isNullOrEmpty));
  }
}
