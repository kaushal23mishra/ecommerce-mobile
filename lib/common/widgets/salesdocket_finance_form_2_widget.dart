import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketFinanceForm2Widget extends SalesdocketConsumerStatefulWidget {
  final Booking? booking;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;

  const SalesdocketFinanceForm2Widget({
    super.key,
    this.booking,
    this.errors = const {},
    this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketFinanceFrom2State();
}

class _SalesdocketFinanceFrom2State
    extends SalesdocketConsumerState<SalesdocketFinanceForm2Widget>
    with LeadEvents {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFinanceType = widget.booking?.financeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketChipWidget(
          label: "",
          chips: financeFormList.map((source) => source.value).toList(),
          selectedChips:
              selectedFinanceType == null ? [] : [selectedFinanceType],
          onSelected: (selected) {
            final newValue = selected?.firstOrNull;
            if (widget.onChanged != null) {
              widget.onChanged!(LeadFormFields.financeType, newValue, null);
            }
          },
          errorText: widget.errors[LeadFormFields.financeType]?.message,
        ),
        verticalSpacing(1.h),
        if (selectedFinanceType != null) ...[
          _disbursalAmountWidget,
        ]
      ],
    );
  }

  Widget get _disbursalAmountWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.disbursalAmount.tr(),
      hint: LocaleKeys.disbursalAmount.tr(),
      initialValue: "${widget.booking?.disbursalAmount ?? ""}",
      inputType: TextInputType.number,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(
            LeadFormFields.disbursalAmount,
            int.tryParse(value.trim()),
            null,
          );
        }
      },
      errorMsg: widget.errors[LeadFormFields.disbursalAmount]?.message,
    );
  }

  @override
  WidgetRef get eventRef => ref;
}
