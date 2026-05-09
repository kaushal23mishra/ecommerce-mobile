import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin NavigationEvents on UiComponentWidget {
  void leadActionBackToPrevScreen(
    BuildContext context, {
    bool shouldBackToPrev = false,
  }) {
    if (shouldBackToPrev) {
      context.router.popTop();
      return;
    }

    switch (context.prevRouterPage?.name) {
      case NotificationRoute.name:
        while (context.router.pageCount != 1) {
          context.router.back();
        }
        break;
      default:
        context.router.popTop();
        break;
    }
  }
}
