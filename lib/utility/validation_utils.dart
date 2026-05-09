import 'dart:io';

import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/regex.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field cannot be empty';
  }

  if (!RegExp(Regex.email).hasMatch(value)) {
    return 'Please enter a valid email address';
  }

  return null;
}

String? validateForgotPasswordEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your registered email address';
  }

  if (!RegExp(Regex.email).hasMatch(value)) {
    return 'Please enter your registered email address';
  }

  return null;
}

String? validateMobile(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field cannot be empty';
  }

  if (value.length != 10) {
    return 'Please enter a valid mobile';
  }

  return null;
}

String? validateEmptyInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field cannot be empty';
  }

  return null;
}

bool isUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  return uri != null && uri.hasScheme && uri.hasAuthority;
}

bool isLocalFile(String path) =>
    path.startsWith('/') && File(path).existsSync();

String resolveImageUrl(String path) {
  if (path.startsWith('http')) return path;
  return '${AppConfigs.http}${AppConfigs.domain}/${AppConfigs.fileLoc}=$path';
}

Map<String, String> get imageAuthHeaders => {
  headerTokenKey: CacheManager.getString(keyToken) ?? '',
  headerDeviceId: CacheManager.getString(keyDevice) ?? '',
};
