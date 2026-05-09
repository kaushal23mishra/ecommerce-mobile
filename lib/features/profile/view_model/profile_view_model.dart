import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  FutureOr<void> build() {}

  Future getVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      final version = "Version ${packageInfo.version}";
      ref.read(versionProvider.notifier).state = version;
    });
  }

  Future fetchProfileFromLocale() async {
    ref.read(profileProvider.notifier).state = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
  }

  Future<Result<User?>> fetchProfileFromRemote() async {
    if (CacheManager.getString(keyToken).isEmpty) {
      return Result.success(data: null);
    }
    final result = await ref.read(userRepositoryProvider).getProfile();
    result.when(
      success: (data) {
        if (data != null) {
          ref.read(profileProvider.notifier).state = data;
          CacheManager.setModel(keyProfile, data);
        }
      },
      failure: (error) {},
    );

    return result;
  }
}

final profileProvider = StateProvider<User?>((ref) => null);
final versionProvider = StateProvider<String?>((ref) => null);
