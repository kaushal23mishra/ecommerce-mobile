import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketUserSelectionListWidget extends SalesdocketStatelessWidget {
  final bool isLoading;
  final List<User> users;
  final Function(User) item;
  final bool canScroll;
  final String? label;
  final bool isRequired;

  const SalesdocketUserSelectionListWidget({
    super.key,
    this.users = const [],
    this.isLoading = false,
    required this.item,
    this.canScroll = false,
    this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: _buildLabel(context),
          ),
        isLoading ? _shimmerWidget : _listWidget,
      ],
    );
  }

  Widget get _shimmerWidget {
    return ListView.separated(
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: !canScroll,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            children: [
              horizontalSpacing(2.w),
              Expanded(
                child: SalesDocketShimmerWidget.rectangular(
                  height: 4.h,
                  width: 30.w,
                ),
              ),
              SalesDocketShimmerWidget.rectangular(height: 4.h, width: 20.w),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: 8,
    );
  }

  Widget get _listWidget {
    return ListView.separated(
      itemBuilder: (context, index) {
        return item(users[index]);
      },
      physics: canScroll ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: !canScroll,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: users.length,
    );
  }

  Widget _buildLabel(BuildContext context) {
    final labelText = label ?? "";
    final defaultStyle = Theme.of(context).textTheme.titleMedium;

    if (isRequired) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: labelText, style: defaultStyle),
            TextSpan(
              text: ' *',
              style: defaultStyle?.copyWith(color: appColors.accent),
            ),
          ],
        ),
      );
    }

    return Text(labelText, style: defaultStyle);
  }
}
