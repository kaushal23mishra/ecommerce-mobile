import 'dart:ui';

class ChartData {
  ChartData(this.title, this.value, {this.subtitle, this.color}); // NOSONAR

  final String title;
  final double value;
  final String? subtitle;
  final Color? color;
}
