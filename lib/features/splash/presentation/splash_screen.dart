import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:salesdocket_core/src/network/models/app/check_updates_response.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/strings.dart';
import 'package:salesdocket_mobile/common/events/app_events.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/app_logo.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_upgrade_dialog.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage(name: 'SplashRoute')
class SplashScreen extends SalesdocketConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SalesdocketConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends SalesdocketConsumerState<SplashScreen>
    with WidgetsBindingObserver, AppEvents {
  @override
  WidgetRef get eventRef => ref;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
      ref.read(profileViewModelProvider.notifier).fetchProfileFromLocale();
      ref.read(profileViewModelProvider.notifier).fetchProfileFromRemote();
      _checkForUpdates();
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColors.primary,
        body: const Center(child: AppLogo()),
      ),
    );
  }

  Future<void> _checkForUpdates() async {
    final platform = Platform.isIOS ? platformApple : platformAndroid;
    final packageInfo = await PackageInfo.fromPlatform();
    await checkForUpdates(platform: platform, version: packageInfo.version);
  }

  @override
  void onUpdateChecked(CheckUpdatesResponse? upgrade) {
    if (upgrade == null || upgrade.status != '1') {
      _navigatePage();
      return;
    }

    final isCritical = upgrade.criticality == criticalityHigh;
    showSalesdocketDialog(
      context: context,
      builder: (_) => SalesdocketUpgradeDialog(
        message: upgrade.upgradeMessage!,
        isCritical: isCritical,
        onUpdate: _launchStore,
        onCancel: isCritical
            ? null
            : () {
                Navigator.of(context, rootNavigator: true).pop();
                _navigatePage();
              },
      ),
    );
  }

  void _navigatePage() {
    final profile = ref.read(profileProvider);
    final router = context.router;
    if (profile.isNull) {
      router.replace(const AuthRoute());
    } else {
      router.replace(const HomeRoute());
    }
  }

  Future<void> _launchStore() async {
    final url = Platform.isIOS ? appStoreUrl : playStoreUrl;
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
