import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

extension SnackbarExtensions on BuildContext {
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.error,
    String? title,
  }) {
    final appColors = UiComponentManager().appColors;
    var backgroundColor = appColors.textPrimary;

    switch (type) {
      case SnackBarType.error:
        backgroundColor = appColors.error;
        break;
      case SnackBarType.success:
        backgroundColor = appColors.success;
        break;
      case SnackBarType.warning:
        backgroundColor = appColors.warning;
        break;
      default:
        break;
    }

    final snackBar = SnackBar(
      content: Text(message.tr()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.w)),
      backgroundColor: backgroundColor,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 4.w),
    );

    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  AutoRoutePage? get prevRouterPage {
    final stack = router.stack;
    if (stack.length >= 2) {
      return stack[stack.length - 2];
    }

    return null;
  }
}
