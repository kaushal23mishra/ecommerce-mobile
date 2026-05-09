import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_mobile/core/theme/app_theme.dart';
import 'package:salesdocket_mobile/core/theme/app_colors.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

/// Extension to simplify pumping widgets in tests
extension PumpApp on WidgetTester {
  /// Pump a widget wrapped with all necessary providers
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    ThemeData? theme,
  }) async {
    // Initialize UiComponentManager if not already initialized
    try {
      await UiComponentManager().init(colors: AppColors.light);
    } catch (e) {
      // Already initialized, ignore
    }

    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: Sizer(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              theme: theme ?? getAppTheme(context, false),
              home: widget,
            );
          },
        ),
      ),
    );
  }

  /// Pump a widget with Material scaffold
  Future<void> pumpScaffold(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await pumpApp(Scaffold(body: widget), overrides: overrides);
  }
}
