import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketForm extends SalesdocketConsumerStatefulWidget {
  final List<Widget> formWidget;
  final Widget actionWidget;
  final EdgeInsetsGeometry? padding;
  final bool ignoring;

  const SalesdocketForm({
    super.key,
    required this.formWidget,
    required this.actionWidget,
    this.padding,
    this.ignoring = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketFormState();
}

class _SalesdocketFormState extends SalesdocketConsumerState<SalesdocketForm> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 4.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                IgnorePointer(
                  ignoring: widget.ignoring,
                  child: Column(children: widget.formWidget),
                ),
                widget.actionWidget,
                verticalSpacing(4.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
