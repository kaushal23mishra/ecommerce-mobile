import 'package:flutter/widgets.dart';

class MenuItem {
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final String? icon;
  final Widget? content;
  final void Function(BuildContext context)? action;
  final void Function(BuildContext context)? onFabClicked;
  final bool shouldShowFab;
  final IconData? fabIcon;
  final Color? color;
  final bool show;
  final int flex;

  MenuItem({
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.icon,
    this.content,
    this.action,
    this.onFabClicked,
    this.fabIcon,
    this.shouldShowFab = false,
    this.color,
    this.show = true,
    this.flex = 1,
  });
}
