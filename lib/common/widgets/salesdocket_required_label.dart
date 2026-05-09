import 'package:flutter/material.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';

/// A widget that displays a label with a red asterisk (*) to indicate a required field
class SalesdocketRequiredLabel extends SalesdocketStatelessWidget {
  final String text;
  final TextStyle? style;

  const SalesdocketRequiredLabel({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? Theme.of(context).textTheme.titleMedium;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: defaultStyle,
          ),
          TextSpan(
            text: ' *',
            style: defaultStyle?.copyWith(color: appColors.accent),
          ),
        ],
      ),
    );
  }
}
