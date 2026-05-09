import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketActionWidget extends SalesdocketStatelessWidget {
  final String? positiveText;
  final Function()? onPositiveClicked;
  final String? negativeText;
  final Function()? onNegativeClicked;
  final Color? buttonColor;
  final bool isEvaluator;
  final String? evaluatorButtonText;

  const SalesdocketActionWidget({
    super.key,
    this.positiveText,
    this.negativeText,
    this.isEvaluator = false,
    this.onNegativeClicked,
    this.onPositiveClicked,
    this.buttonColor,
    this.evaluatorButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child:
          isEvaluator
              ? SalesDocketButtonWidget(
                text:
                    evaluatorButtonText ??
                    LocaleKeys.lblCompleteEvaluation.tr(),
                isOutlined: true,
                onPressed: () {
                  onNegativeClicked!();
                },
                backgroundColor: buttonColor,
              )
              : Row(
                spacing: 4.w,
                children: [
                  if (onNegativeClicked != null)
                    Expanded(
                      child: SalesDocketButtonWidget(
                        text: negativeText ?? LocaleKeys.lblSaveAndExit.tr(),
                        isOutlined: true,
                        onPressed: () {
                          onNegativeClicked!();
                        },
                        backgroundColor: buttonColor,
                      ),
                    ),
                  if (onPositiveClicked != null)
                    Expanded(
                      child: SalesDocketButtonWidget(
                        text: positiveText ?? LocaleKeys.lblNext.tr(),
                        onPressed: () {
                          onPositiveClicked!();
                        },
                        backgroundColor: buttonColor,
                      ),
                    ),
                ],
              ),
    );
  }
}
