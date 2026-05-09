import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/entity/media.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_images_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketExchangeImagesWidget extends SalesdocketStatelessWidget {
  final ExchangeProductImages? images;
  final Function(ExchangeProductImages?)? onChanged;
  final Function(bool)? onAddImagesChanged;
  final Function(bool)? onAddMoreImagesChanged;
  final bool canAddImages;
  final bool canAddMoreImages;

  const SalesdocketExchangeImagesWidget({
    super.key,
    this.images,
    this.onChanged,
    this.onAddImagesChanged,
    this.onAddMoreImagesChanged,
    this.canAddImages = false,
    this.canAddMoreImages = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _addImagesWidget(context),
        if (canAddImages) _addMoreImagesWidget(context),
      ],
    );
  }

  Widget _addImagesWidget(BuildContext context) {
    final mediaList = _mediaList;

    return Column(
      spacing: 1.h,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.addImages.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: canAddImages,
                onChanged: (value) {
                  if (onAddImagesChanged != null) {
                    onAddImagesChanged!(value);
                  }
                },
                activeTrackColor: appColors.primary,
              ),
            ),
          ],
        ),
        canAddImages
            ? SalesdocketImagesWidget(
              images: mediaList,
              onImageChanged: (index, file) {
                if (onChanged != null) {
                  var newData = images;
                  switch (mediaList[index].documentType) {
                    case DocumentType.blueBook:
                      newData = newData?.copyWith(blueBookImage: file?.path);
                      onChanged!(newData);
                      break;
                    case DocumentType.lotNo:
                      newData = newData?.copyWith(lotNoImage: file?.path);
                      onChanged!(newData);
                      break;
                    case DocumentType.carImage1:
                      _updateCarImage(1, file?.path);
                      break;
                    case DocumentType.carImage2:
                      _updateCarImage(2, file?.path);
                      break;
                  }
                }
              },
            )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _addMoreImagesWidget(BuildContext context) {
    final mediaList = _extraMediaList;

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        spacing: 1.h,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.addMoreImages.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  value: canAddMoreImages,
                  onChanged: (value) {
                    if (onAddMoreImagesChanged != null) {
                      onAddMoreImagesChanged!(value);
                    }
                  },
                  activeTrackColor: appColors.primary,
                ),
              ),
            ],
          ),
          canAddMoreImages
              ? SalesdocketImagesWidget(
                images: mediaList,
                onImageChanged: (index, file) {
                  switch (mediaList[index].documentType) {
                    case DocumentType.carImage3:
                      _updateCarImage(3, file?.path);
                      break;
                    case DocumentType.carImage4:
                      _updateCarImage(4, file?.path);
                      break;
                    case DocumentType.carImage5:
                      _updateCarImage(5, file?.path);
                      break;
                  }
                },
              )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _updateCarImage(int carIndex, String? path) {
    var newData = images;
    final carImages = <int, String?>{};
    carImages.addAll(images?.carImages ?? {});
    carImages[carIndex] = path;
    newData = newData?.copyWith(carImages: carImages);
    if (onChanged != null) {
      onChanged!(newData);
    }
  }

  List<Media> get _mediaList {
    final carImages = images?.carImages ?? {};

    return [
      Media(
        name: DocumentType.blueBook.label,
        gridSize: 6,
        documentType: DocumentType.blueBook,
        path: images?.blueBookImage,
      ),
      Media(
        name: DocumentType.lotNo.label,
        gridSize: 6,
        documentType: DocumentType.lotNo,
        path: images?.lotNoImage,
      ),
      Media(
        name: LocaleKeys.carPicture.tr(args: ['1']),
        gridSize: 6,
        documentType: DocumentType.carImage1,
        path: carImages[1],
      ),
      Media(
        name: LocaleKeys.carPicture.tr(args: ['2']),
        gridSize: 6,
        documentType: DocumentType.carImage2,
        path: carImages[2],
      ),
    ];
  }

  List<Media> get _extraMediaList {
    final carImages = images?.carImages ?? {};

    return [
      Media(
        name: LocaleKeys.carPicture.tr(args: ['3']),
        gridSize: 4,
        documentType: DocumentType.carImage3,
        path: carImages[3],
      ),
      Media(
        name: LocaleKeys.carPicture.tr(args: ['4']),
        gridSize: 4,
        documentType: DocumentType.carImage4,
        path: carImages[4],
      ),
      Media(
        name: LocaleKeys.carPicture.tr(args: ['5']),
        gridSize: 4,
        documentType: DocumentType.carImage5,
        path: carImages[5],
      ),
    ];
  }
}
