import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketUploadFileWidget extends SalesdocketStatelessWidget {
  final Function onClicked;
  final String? title;
  final double? width;
  final double? height;
  final String? path;
  final bool isRequired;

  const SalesdocketUploadFileWidget({
    super.key,
    required this.onClicked,
    this.title,
    this.width,
    this.height,
    this.path,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: height,
      decoration: BoxDecoration(
        color: appColors.primaryLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.2.w),
      ),
      child: InkWell(
        onTap: () {
          onClicked();
        },
        child:
            path != null && path!.isNotEmpty
                ? isLocalFile(path!)
                    ? Image.file(
                      File(path!),
                      height: height,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              _defaultWidget(context),
                    )
                    : CachedNetworkImage(
                      imageUrl: resolveImageUrl(path!),
                      httpHeaders: imageAuthHeaders,
                      height: height,
                      errorWidget:
                          (context, url, error) => _defaultWidget(context),
                      progressIndicatorBuilder:
                          (context, url, progress) => _defaultWidget(context),
                    )
                : _defaultWidget(context),
      ),
    );
  }

  Widget _defaultWidget(BuildContext context) {
    final label = title ?? LocaleKeys.uploadFile.tr();
    final labelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: appColors.textDisabled,
      fontSize: height != null ? (height! * 0.08) : 16.sp,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.svg.icUpload.path,
          height: height != null ? (height! * 0.3) : 4.h,
          colorFilter: ColorFilter.mode(appColors.primary, BlendMode.srcIn),
        ),
        verticalSpacing(0.5.h),
        isRequired
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: label, style: labelStyle),
                    TextSpan(
                      text: ' *',
                      style: labelStyle?.copyWith(color: appColors.accent),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              )
            : Text(label, style: labelStyle, textAlign: TextAlign.center),
      ],
    );
  }
}
