import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketAddRemarksWidget extends SalesdocketStatelessWidget {
  final String? remark;
  final Function(String?)? onChanged;
  final Function(bool)? onAddRemarksChanged;
  final bool canAddRemark;
  final CrossAxisAlignment crossAxisAlignment;

  const SalesdocketAddRemarksWidget({
    super.key,
    this.remark,
    this.onChanged,
    this.onAddRemarksChanged,
    this.canAddRemark = false,
    this.crossAxisAlignment = CrossAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          children: [
            const Spacer(),
            SalesdocketSwitchWidget(
              label: LocaleKeys.addRemarks.tr(),
              value: canAddRemark,
              onChanged: (value) {
                if (onAddRemarksChanged != null) {
                  onAddRemarksChanged!(value);
                }
              },
            ),
          ],
        ),
        if (canAddRemark)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: SalesDocketInputWidget(
              label: LocaleKeys.typeCommentHere.tr(),
              hint: LocaleKeys.typeCommentHere.tr(),
              initialValue: remark,
              inputType: TextInputType.multiline,
              maxLines: 4,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
            ),
          ),
      ],
    );
  }
}
