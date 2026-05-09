import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_product_images.freezed.dart';

@freezed
class ExchangeProductImages with _$ExchangeProductImages {
  const factory ExchangeProductImages({
    String? insuranceImage,
    String? rcFrontImage,
    String? rcBackImage,
    String? blueBookImage,
    String? lotNoImage,
    Map<int, String?>? carImages,
  }) = _ExchangeProductImages;
}
