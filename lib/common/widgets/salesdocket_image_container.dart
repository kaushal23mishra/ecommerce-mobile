import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/media_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_upload_file_widget.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';

class SalesdocketImageContainer extends SalesdocketStatefulWidget {
  final String title;
  final Function(XFile?) onImageChanged;
  final double? height;
  final String? path;
  final bool isDisabled;
  final bool isRequired;

  const SalesdocketImageContainer({
    super.key,
    required this.title,
    required this.onImageChanged,
    required this.path,
    this.height,
    this.isDisabled = false,
    this.isRequired = false,
  });

  @override
  State<StatefulWidget> createState() => _SalesdocketImageContainerState();
}

class _SalesdocketImageContainerState
    extends SalesdocketState<SalesdocketImageContainer>
    with MediaEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketUploadFileWidget(
      title: widget.title,
      height: widget.height,
      path: widget.path,
      isRequired: widget.isRequired,
      onClicked: () {
        if (widget.isDisabled) return;

        showMediaBottomSheet(hasPreview: (widget.path ?? "").isNotEmpty);
      },
    );
  }

  @override
  void onPreviewClicked() {
    context.router.push(FullScreenMediaPageRoute(mediaPath: widget.path));
  }

  @override
  void onRemoveClicked() {
    widget.onImageChanged(null);
  }

  @override
  void onImageCaptured(XFile? imageFile) {
    widget.onImageChanged(imageFile);
  }

  @override
  Future showBottomSheet({required WidgetBuilder builder}) {
    return showSalesdocketBottomSheet(context: context, builder: builder);
  }

  @override
  void onPermissionDenied(String message) {
    context.showSnackBar(message, type: SnackBarType.warning);
  }

  @override
  void onPermissionPermanentlyDenied(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Open Settings"),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}
