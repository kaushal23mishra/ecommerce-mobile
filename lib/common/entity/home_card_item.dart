import 'package:flutter/material.dart';

class HomeCardItem {
  final String title;
  final String? imagePath;
  final IconData? icon;
  final int primaryText;
  final double progressValue;
  final String? secondaryText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? progressBgColor;
  final Function(BuildContext context)? onClick;

  const HomeCardItem({
    required this.title,
    this.imagePath,
    this.icon,
    required this.primaryText,
    required this.progressValue,
    this.secondaryText,
    this.backgroundColor,
    this.borderColor,
    this.progressBgColor,
    this.onClick,
  });
}
