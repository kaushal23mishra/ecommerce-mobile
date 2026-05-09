import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/select_brand_reason.dart';
import 'package:salesdocket_mobile/common/entity/check_list_item.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ReasonForSelectingBrandingWidget
    extends SalesdocketConsumerStatefulWidget {
  const ReasonForSelectingBrandingWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReasonForSelectingBrandingState();
}

class _ReasonForSelectingBrandingState
    extends SalesdocketConsumerState<ReasonForSelectingBrandingWidget> {
  final _otherReasonController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final delivery = ref.watch(selectedDeliveryProvider);
      _otherReasonController.text =
          delivery?.reasonForSelectingBrandOther ?? "";
      _otherReasonController.addListener(_onOtherReasonChanged);
    });
    super.initState();
  }

  @override
  void dispose() {
    _otherReasonController.removeListener(_onOtherReasonChanged);
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reasons = SelectBrandReason.values;
    final delivery = ref.watch(selectedDeliveryProvider);
    final prevSelected = delivery?.reasonForSelectingBrand ?? [];
    final errors = ref.watch(deliveryFormErrorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketChecklistWidget(
          label: LocaleKeys.topReasonForSelectingBrand.tr(),
          selectedItems: prevSelected,
          items:
              reasons
                  .map(
                    (item) => CheckListItem(key: item.value, value: item.value),
                  )
                  .toList(),
          onChanged: (selected) {
            final iDidNotAsk = SelectBrandReason.iDidNotAsk.value;
            var newValue = selected.toList();
            if (selected.contains(iDidNotAsk)) {
              if (prevSelected.contains(iDidNotAsk)) {
                newValue.remove(iDidNotAsk);
              } else {
                newValue = [iDidNotAsk];
              }
            }
            if (!newValue.contains(SelectBrandReason.other.value)) {
              _otherReasonController.clear();
            }

            ref
                .read(selectedDeliveryProvider.notifier)
                .update(
                  (state) =>
                      state = state?.copyWith(
                        reasonForSelectingBrand: newValue,
                      ),
                );
            ref
                .read(deliveryFormErrorsProvider.notifier)
                .remove(LeadFormFields.reasonToSelectBrand);
          },
          error: errors.get(LeadFormFields.reasonToSelectBrand)?.message,
        ),
        if (prevSelected.contains(SelectBrandReason.other.value))
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: SalesDocketInputWidget(
              label: LocaleKeys.lblOther.tr(),
              hint: LocaleKeys.lblOther.tr(),
              controller: _otherReasonController,
              errorMsg:
                  errors.get(LeadFormFields.reasonToSelectBrandOther)?.message,
            ),
          ),
      ],
    );
  }

  void _onOtherReasonChanged() {
    final value = _otherReasonController.text;
    ref
        .read(selectedDeliveryProvider.notifier)
        .update(
          (state) =>
              state = state?.copyWith(
                reasonForSelectingBrandOther: value.trim(),
              ),
        );
    ref
        .read(deliveryFormErrorsProvider.notifier)
        .remove(LeadFormFields.reasonToSelectBrandOther);
  }
}
