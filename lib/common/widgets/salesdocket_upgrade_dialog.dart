import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketUpgradeDialog extends SalesdocketStatelessWidget {
  final String message;
  final bool isCritical;
  final VoidCallback onUpdate;
  final VoidCallback? onCancel;

  const SalesdocketUpgradeDialog({
    super.key,
    required this.message,
    required this.isCritical,
    required this.onUpdate,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isCritical,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Text(
          LocaleKeys.lblUpdateAvailable.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actionsPadding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.h),
        actions: [
          Row(
            children: [
              if (!isCritical) ...[
                Expanded(
                  child: SalesDocketButtonWidget(
                    text: LocaleKeys.lblCancel.tr(),
                    isOutlined: true,
                    onPressed: onCancel,
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: SalesDocketButtonWidget(
                  text: LocaleKeys.lblUpdateNow.tr(),
                  onPressed: onUpdate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
