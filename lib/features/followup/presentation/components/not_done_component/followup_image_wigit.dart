import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/entity/media.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_images_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../../common/classes/salesdocket_consumer_state.dart';

class SalesdocketFollowupImageWidget extends SalesdocketStatelessWidget {
  final FollowupImages? followupImages;
  final Function(FollowupImages)? onIdentityImagesChanged;

  const SalesdocketFollowupImageWidget({
    super.key,
    this.followupImages,
    this.onIdentityImagesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mediaList = _mediaList;

    return SalesdocketImagesWidget(
      images: mediaList,
      onImageChanged: (index, file) {
        if (onIdentityImagesChanged != null) {
          FollowupImages newData = followupImages ?? FollowupImages();

          switch (mediaList[index].documentType) {
            case DocumentType.imageOne:
              newData = newData.copyWith(imagesOne: file?.path);
              break;
            case DocumentType.imageTwo:
              newData = newData.copyWith(imagesTwo: file?.path);
              break;
          }

          onIdentityImagesChanged!(newData);
        }
      },
    );
  }

  List<Media> get _mediaList => [
    Media(
      name: LocaleKeys.lblPicture.tr(args: ['1']),
      gridSize: 6,
      documentType: DocumentType.imageOne,
      path: followupImages?.imagesOne,
    ),
    Media(
      name: LocaleKeys.lblPicture.tr(args: ['2']),
      gridSize: 6,
      documentType: DocumentType.imageTwo,
      path: followupImages?.imagesTwo,
    ),
  ];
}
