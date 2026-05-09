import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_mobile/common/constants/theme.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

abstract class SalesdocketConsumerStatefulWidget
    extends ConsumerStatefulWidget {
  const SalesdocketConsumerStatefulWidget({super.key});
}

abstract class SalesdocketConsumerState<
  T extends SalesdocketConsumerStatefulWidget
>
    extends ConsumerState<T>
    with SalesdocketTheme, UiComponentWidget, SalesdocketAction, UiLoggy {
  @override
  bool get isMounted => mounted;

  void onHomeClicked() {
    while (context.router.pageCount != 1) {
      context.router.pop();
    }
  }
}

abstract class SalesdocketConsumerWidget<T> extends ConsumerWidget
    with UiComponentWidget, SalesdocketTheme, SalesdocketAction, UiLoggy {
  const SalesdocketConsumerWidget({super.key});

  @override
  bool get isMounted => true; // ConsumerWidget doesn't have disposal lifecycle
}

abstract class SalesdocketStatefulWidget extends StatefulWidget {
  const SalesdocketStatefulWidget({super.key});
}

abstract class SalesdocketState<T extends SalesdocketStatefulWidget>
    extends State<T>
    with UiComponentWidget, SalesdocketTheme, SalesdocketAction, UiLoggy {
  @override
  bool get isMounted => mounted;
}

abstract class SalesdocketStatelessWidget<T> extends StatelessWidget
    with UiComponentWidget, SalesdocketTheme, SalesdocketAction, UiLoggy {
  const SalesdocketStatelessWidget({super.key});

  @override
  bool get isMounted => true; // StatelessWidget doesn't have disposal lifecycle
}

mixin SalesdocketTheme {
  void setupStatusBar({StatusBarTheme? theme}) {
    switch (theme) {
      case StatusBarTheme.dark:
        _setupDarkTheme();
        break;
      case StatusBarTheme.light:
      default:
        _setupLightTheme();
        break;
    }
  }

  Future<T?> showSalesdocketBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    StatusBarTheme? prevTheme = StatusBarTheme.light,
    bool keepTheme = false,
    bool isDismissible = true,
  }) async {
    final appColors = UiComponentManager().appColors;
    setupBottomSheetTheme(theme: prevTheme);
    final result = await showModalBottomSheet<T>(
      context: context,
      builder: builder,
      constraints: const BoxConstraints(minHeight: 50),
      backgroundColor: Colors.transparent,
      barrierColor: appColors.shadow,
      isScrollControlled: true,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: true,
    );
    if (!keepTheme) {
      setupStatusBar(theme: prevTheme);
    }

    return result;
  }

  Future<T?> showSalesdocketDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    StatusBarTheme? prevTheme = StatusBarTheme.light,
    bool keepTheme = false,
  }) async {
    final appColors = UiComponentManager().appColors;
    setupBottomSheetTheme(theme: prevTheme);
    final result = await showDialog<T>(
      context: context,
      builder: builder,
      barrierColor: appColors.shadow,
      useRootNavigator: true,
    );
    if (!keepTheme) {
      setupStatusBar(theme: prevTheme);
    }

    return result;
  }

  void setupBottomSheetTheme({StatusBarTheme? theme}) {
    final appColors = UiComponentManager().appColors;

    if (theme == StatusBarTheme.light) {
      _setupLightTheme(
        color: Color.alphaBlend(
          appColors.shadow,
          appColors.appBarBackground,
        ),
      );
    } else {
      _setupDarkTheme(
        color: Color.alphaBlend(
          appColors.shadow,
          appColors.appBarBackground,
        ),
      );
    }
  }

  void _setupDarkTheme({Color? color}) {
    final appColors = UiComponentManager().appColors;

    Future.delayed(const Duration(milliseconds: 1)).then(
      (_) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: color ?? appColors.appBarBackground,
          systemNavigationBarColor: appColors.appBarBackground,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
    );
  }

  void _setupLightTheme({Color? color}) {
    final appColors = UiComponentManager().appColors;
    Future.delayed(const Duration(milliseconds: 1)).then(
      (_) => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: color ?? appColors.appBarBackground,
          systemNavigationBarColor: appColors.appBarBackground,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
    );
  }
}

mixin SalesdocketAction {
  dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
