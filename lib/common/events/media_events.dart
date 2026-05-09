import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_media_menu_widget.dart';

mixin MediaEvents {
  final ImagePicker _picker = ImagePicker();

  Future showMediaBottomSheet({bool hasPreview = true}) async {
    final actionItem = await showBottomSheet(
      builder: (context) {
        return SalesdocketMediaMenuWidget(hasPreview: hasPreview);
      },
    );
    if (actionItem != null) {
      _onMediaMenuActionClicked(actionItem);
    }
  }

  void _onMediaMenuActionClicked(MediaItemMenuAction action) {
    switch (action) {
      case MediaItemMenuAction.camera:
        _captureImage();
        break;
      case MediaItemMenuAction.gallery:
        _pickImage();
        break;
      case MediaItemMenuAction.preview:
        onPreviewClicked();
        break;
      case MediaItemMenuAction.remove:
        onRemoveClicked();
        break;
    }
  }

  /// Handles camera image capture and permission flow
  Future _captureImage() async {
    if (Platform.isIOS) {
      // On iOS, UIImagePickerController handles the permission dialog natively.
      // Only block if already permanently denied — otherwise open directly.
      final status = await Permission.camera.status;
      if (status.isPermanentlyDenied || status.isRestricted) {
        onPermissionPermanentlyDenied(
          "Camera permission is required. Please enable it in Settings.",
        );
        return;
      }
      final imageFile = await _picker.pickImage(source: ImageSource.camera);
      onImageCaptured(imageFile);
      return;
    }

    // Android permission flow
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      final imageFile = await _picker.pickImage(source: ImageSource.camera);
      onImageCaptured(imageFile);
    } else if (status.isDenied) {
      onPermissionDenied("Camera permission is required to take photos.");
    } else if (status.isPermanentlyDenied) {
      onPermissionPermanentlyDenied(
        "Camera permission is permanently denied. Please enable it in Settings.",
      );
    }
  }

  /// Handles gallery image selection and permission flow
  Future _pickImage() async {
    if (Platform.isIOS) {
      // image_picker uses PHPickerViewController on iOS 14+ which does not
      // require NSPhotoLibraryUsageDescription — open the picker directly.
      final imageFile = await _picker.pickImage(source: ImageSource.gallery);
      onImageCaptured(imageFile);
      return;
    }

    PermissionStatus status;

    // Android: Check both Permission.photos (API 33+) and Permission.storage (API < 33)
    final photosStatus = await Permission.photos.status;
    final storageStatus = await Permission.storage.status;

    if (photosStatus.isGranted ||
        photosStatus.isLimited ||
        storageStatus.isGranted) {
      status = PermissionStatus.granted;
    } else {
      // If neither is granted, request appropriate permissions
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();

      if (statuses[Permission.photos]!.isGranted ||
          statuses[Permission.photos]!.isLimited ||
          statuses[Permission.storage]!.isGranted) {
        status = PermissionStatus.granted;
      } else if (statuses[Permission.photos]!.isPermanentlyDenied ||
          statuses[Permission.storage]!.isPermanentlyDenied) {
        status = PermissionStatus.permanentlyDenied;
      } else {
        status = PermissionStatus.denied;
      }
    }

    if (status.isGranted || status.isLimited) {
      // Permission granted → open gallery
      final imageFile = await _picker.pickImage(source: ImageSource.gallery);
      onImageCaptured(imageFile);
    } else if (status.isPermanentlyDenied) {
      onPermissionPermanentlyDenied(
        "Gallery permission is permanently denied. Please enable it in Settings.",
      );
    } else {
      onPermissionDenied("Gallery permission is required to access photos.");
    }
  }

  /// Callbacks to override in the implementing widget/class
  void onImageCaptured(XFile? imageFile) {}
  void onPreviewClicked() {}
  void onRemoveClicked() {}
  void onPermissionDenied(String message) {}
  void onPermissionPermanentlyDenied(String message) {}

  Future showBottomSheet({required WidgetBuilder builder}) async {}
}