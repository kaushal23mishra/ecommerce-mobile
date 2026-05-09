import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'FullScreenMediaPageRoute')
class FullScreenMediaPage extends SalesdocketConsumerStatefulWidget {
  final String? mediaPath;

  const FullScreenMediaPage({super.key, required this.mediaPath});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FullScreenMediaPageState();
}

class _FullScreenMediaPageState
    extends SalesdocketConsumerState<FullScreenMediaPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.mediaPath ?? "";

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.media.tr(),
          isLight: false,
          onHomeClicked: () => onHomeClicked(),
        ),
        backgroundColor: appColors.textDisabled,
        body: Center(
          child:
              url.isEmpty
                  ? SalesDocketShimmerWidget.rectangular(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    shapeBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  )
                  : isLocalFile(url)
                      ? Image.file(
                          File(url),
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 64, color: Colors.white54),
                        )
                      : CachedNetworkImage(
                          imageUrl: resolveImageUrl(url),
                          httpHeaders: imageAuthHeaders,
                          errorWidget: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 64, color: Colors.white54),
                          placeholder: (context, url) => SalesDocketShimmerWidget.rectangular(
                            height: 200,
                            shapeBorder: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
        ),
      ),
    );
  }
}
