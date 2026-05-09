import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_ui_component/core/sizer/sizer.dart';
import 'package:salesdocket_ui_component/widget/salesdocket_button_widget.dart';
import '../../generated/locale_keys.g.dart';

class SalesDocketApproveButtonWidget extends StatelessWidget {
  final VoidCallback onYes;

  const SalesDocketApproveButtonWidget({super.key, required this.onYes});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SalesDocketButtonWidget(
            text: LocaleKeys.lblCancel.tr(),
            onPressed: () => context.router.maybePop(),
            isOutlined: true,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: SalesDocketButtonWidget(
            text: LocaleKeys.lblYes.tr(),
            onPressed: onYes,
          ),
        ),
      ],
    );
  }
}
