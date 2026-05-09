import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';

class SalesdocketProfileImageWidget extends SalesdocketStatelessWidget {
  final String? imageUrl;
  final String? name;
  final Color? bgColor;
  final Color? textColor;
  final double size;

  const SalesdocketProfileImageWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.bgColor,
    this.textColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl!.isNotEmpty
        ? Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColors.grayMedium,
          ),
          child: _imageWidget(context),
        )
        : Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? appColors.primary, // Black background
          ),
          child: _nameWidget(context),
        );
  }

  Widget _nameWidget(BuildContext context) {
    return CircleAvatar(
      radius: size * 0.5,
      backgroundColor: bgColor ?? appColors.primary, // Using black background
      child: Text(
        (name ?? "").initials.toUpperCase(),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: textColor ?? (bgColor == null ? appColors.secondary : appColors.primary),
          fontSize: size * (9 / 16),
        ),
      ),
    );
  }

  Widget _imageWidget(BuildContext context) => ClipOval(
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl!,
      httpHeaders: imageAuthHeaders,
      errorWidget: (context, url, error) {
        return _nameWidget(context);
      },
      placeholder: (context, url) {
        return _nameWidget(context);
      },
    ),
  );
}
