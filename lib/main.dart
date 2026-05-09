import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:salesdocket_core/core_manager.dart';
import 'package:salesdocket_mobile/analytics/mixpanel_provider.dart';
import 'package:salesdocket_mobile/common/constants/salesdocket_locale.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';
import 'package:salesdocket_mobile/core/theme/app_colors.dart';
import 'package:salesdocket_mobile/features/app.dart';
import 'package:salesdocket_mobile/firebase_options.dart';
import 'package:salesdocket_mobile/generated/codegen_loader.g.dart';
import 'package:salesdocket_mobile/service/notification_service.dart';
import 'package:salesdocket_mobile/service/remote_config_service.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kDebugMode) {
    Loggy.initLoggy(
      logPrinter: const PrettyPrinter(showColors: true),
      logOptions: const LogOptions(LogLevel.all, stackTraceLevel: LogLevel.off),
    );
  }
  await CoreManager().init();
  await UiComponentManager().init(colors: AppColors.light);
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // Firebase already initialized
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await RemoteConfigService.initialize();
  CoreManager().setBaseUrl("${AppConfigs.http}${AppConfigs.domain}/");

  // Set up background message handler (must be top-level function)
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
  // final mixpanel = await Mixpanel.init(
  //   AppConfigs.mixpanelToken,
  //   trackAutomaticEvents: true,
  // );

  runApp(
    EasyLocalization(
      supportedLocales: [
        SalesdocketLocale.english.locale,
        SalesdocketLocale.nepali.locale,
      ],
      path: 'assets/langs',
      assetLoader: const CodegenLoader(),
      fallbackLocale: SalesdocketLocale.english.locale,
      child: ProviderScope(
        overrides: [],
        child: App(),
      ),
    ),
  );
}
