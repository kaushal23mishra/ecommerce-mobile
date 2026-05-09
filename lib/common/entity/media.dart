import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';

part 'media.freezed.dart';

@freezed
class Media with _$Media {
  const factory Media({
    String? name,
    String? url,
    String? path,
    required int gridSize,
    required DocumentType documentType,
  }) = _Media;
}
