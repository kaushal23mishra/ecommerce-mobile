import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_details_images.freezed.dart';

@freezed
class PanImages with _$PanImages {
  const factory PanImages({
    String? valueType,
    String? value,
    String? userImage,
  }) = _PanImages;
}

@freezed
class FollowupImages with _$FollowupImages {
  const factory FollowupImages({String? imagesOne, String? imagesTwo}) =
      _FollowupImages;
}
