import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_mobile/common/events/contact_events.dart';
import 'package:salesdocket_mobile/common/providers/app_theme_provider.dart';
import 'package:salesdocket_mobile/common/providers/notification_navigation_provider.dart';
import 'package:salesdocket_mobile/common/services/snackbar_service.dart';
import 'package:salesdocket_mobile/core/theme/app_theme.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/routing/keyboard_dismissal_observer.dart';
import 'package:salesdocket_mobile/service/notification_service.dart';
import 'package:salesdocket_ui_component/core/sizer/sizer.dart';

/// Global key for ScaffoldMessenger - used to show snackbars from anywhere
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with UiLoggy, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize global snackbar service with the key (lazily resolved when needed)
    SnackbarService.instance.init(rootScaffoldMessengerKey);

    // Initialize notification service after widget is built and providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotificationService.onNavigate = (data) {
        ref.read(notificationNavigationProvider)(data);
      };
      loggy.info("Notification service initialized");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Dismiss keyboard when app comes to foreground
      FocusManager.instance.primaryFocus?.unfocus();
      loggy.info("App resumed - keyboard dismissed");

      // Handle iOS call resume to track duration
      handleIOSCallResume(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    loggy.info("App build 🚀🚀🚀");

    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          routerConfig: appRouter.config(
            navigatorObservers: () => [KeyboardDismissalObserver()],
          ),
          theme: getAppTheme(context, ref.watch(appThemeProvider)),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
