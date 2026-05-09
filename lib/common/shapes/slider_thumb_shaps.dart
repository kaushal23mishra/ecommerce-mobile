import 'package:flutter/material.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';
import 'package:salesdocket_ui_component/core/sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SliderThumbShape extends SfThumbShape with UiComponentWidget {
  final String value;
  TextSpan _textSpan;
  final TextPainter _textPainter;
  final BuildContext buildContext;

  SliderThumbShape({required this.buildContext, this.value = ""})
    : _textSpan = const TextSpan(),
      _textPainter = TextPainter();

  @override
  bool get isMounted => true; // Shape helper doesn't have disposal lifecycle

  @override
  Size getPreferredSize(SfSliderThemeData themeData) {
    _textSpan = TextSpan(text: value);
    _textPainter
      ..text = _textSpan
      ..textDirection = TextDirection.ltr
      ..layout();
    return Size(4.w, 4.h);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    _textSpan = TextSpan(
      text: value,
      style: Theme.of(
        buildContext,
      ).textTheme.headlineLarge?.copyWith(color: appColors.primary),
    );

    _textPainter
      ..text = _textSpan
      ..textDirection = textDirection
      ..textScaler = TextScaler.noScaling
      ..layout()
      ..paint(
        context.canvas,
        Offset(
          center.dx - _textPainter.width / 2,
          center.dy - themeData.thumbRadius - 4.h,
        ),
      );

    final Path path = Path();

    final x = center.dx;
    final y = center.dy - 1.h;
    path.moveTo(x, y);
    path.lineTo(x + 1.5.w, y - 2.5.w);
    path.lineTo(x - 1.5.w, y - 2.5.w);
    path.close();
    context.canvas.drawPath(
      path,
      Paint()
        ..color = themeData.activeTrackColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4.w,
    );
  }
}
