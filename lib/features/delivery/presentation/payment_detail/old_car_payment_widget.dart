import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/entity/old_car_payment.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class OldCarPaymentWidget extends SalesdocketConsumerStatefulWidget {
  const OldCarPaymentWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OldCarPaymentWidgetState();
}

class _OldCarPaymentWidgetState
    extends SalesdocketConsumerState<OldCarPaymentWidget> {
  late TextEditingController _amountPendingController;
  late TextEditingController _agentNameController;
  late TextEditingController _agentNumberController;

  @override
  void initState() {
    super.initState();
    _amountPendingController = TextEditingController();
    _agentNameController = TextEditingController();
    _agentNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _amountPendingController.dispose();
    _agentNameController.dispose();
    _agentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oldCarPayment = ref.watch(oldCarPaymentProvider);
    final canEdit = ref.watch(canEditDeliveryProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    errors[LeadFormFields.oldCarPayment] =
        ref.watch(deliveryFormErrorsProvider).get(LeadFormFields.oldCarPayment);
    errors[LeadFormFields.amountPending] =
        ref.watch(deliveryFormErrorsProvider).get(LeadFormFields.amountPending);

    // Handle initial values and updates
    ref.listen(oldCarPaymentProvider, (previous, next) {
      final nextAmount = next?.amountPending;
      final currentAmount = int.tryParse(_amountPendingController.text);
      
      if (nextAmount != currentAmount) {
         _amountPendingController.text = "${nextAmount ?? ""}";
      }
      if (next?.agentName != _agentNameController.text) {
        _agentNameController.text = next?.agentName ?? "";
      }
      if (next?.agentNumber != _agentNumberController.text) {
        _agentNumberController.text = next?.agentNumber ?? "";
      }
    });

    // Handle initial values
    if (oldCarPayment != null) {
      if (_amountPendingController.text.isEmpty &&
          oldCarPayment.amountPending != null) {
        _amountPendingController.text = "${oldCarPayment.amountPending}";
      }
      if (_agentNameController.text.isEmpty &&
          (oldCarPayment.agentName ?? "").isNotEmpty) {
        _agentNameController.text = oldCarPayment.agentName ?? "";
      }
      if (_agentNumberController.text.isEmpty &&
          (oldCarPayment.agentNumber ?? "").isNotEmpty) {
        _agentNumberController.text = oldCarPayment.agentNumber ?? "";
      }
    }

    return IgnorePointer(
      ignoring: !canEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalesdocketSwitchWidget(
            value: oldCarPayment?.isGiven ?? false,
            label: LocaleKeys.oldCarPaymentPendingFromAgent.tr(),
            onChanged: (value) {
              ref.read(oldCarPaymentProvider.notifier).update(
                    (state) => state?.copyWith(isGiven: value) ??
                        OldCarPayment(isGiven: value),
                  );
            },
            hasSpace: true,
            errorText: errors[LeadFormFields.oldCarPayment]?.message,
          ),
          if (oldCarPayment?.isGiven ?? false) _buildForm(errors),
        ],
      ),
    );
  }

  Widget _buildForm(Map<LeadFormFields, FormFieldError?> errors) {
    final oldCarPayment = ref.read(oldCarPaymentProvider);
    
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalesDocketInputWidget(
            label: LocaleKeys.amountPending.tr(),
            hint: LocaleKeys.amountPending.tr(),
            controller: _amountPendingController,
            inputType: TextInputType.number,
            inputFormatters: InputFormatters.digitsOnly,
            errorMsg: errors[LeadFormFields.amountPending]?.message,
            onChanged: (val) {
              final amount = int.tryParse(val.trim());
              ref.read(oldCarPaymentProvider.notifier).update(
                    (state) => OldCarPayment(
                      isGiven: state?.isGiven,
                      amountPending: amount,
                      agentName: state?.agentName,
                      agentNumber: state?.agentNumber,
                      expectedDateOfPayment: state?.expectedDateOfPayment,
                      remarks: state?.remarks,
                    ),
                  );
            },
          ),
          SizedBox(height: 2.h),
          SalesDocketInputWidget(
            label: LocaleKeys.agentName.tr(),
            hint: LocaleKeys.agentName.tr(),
            controller: _agentNameController,
            onChanged: (val) {
              ref.read(oldCarPaymentProvider.notifier).update(
                    (state) => state?.copyWith(agentName: val),
                  );
            },
          ),
          SizedBox(height: 2.h),
          SalesDocketInputWidget(
            label: LocaleKeys.agentNumber.tr(),
            hint: LocaleKeys.agentNumber.tr(),
            controller: _agentNumberController,
            inputType: TextInputType.phone,
            inputFormatters: InputFormatters.digitsOnly,
            onChanged: (val) {
              ref.read(oldCarPaymentProvider.notifier).update(
                    (state) => state?.copyWith(agentNumber: val),
                  );
            },
          ),
          SizedBox(height: 2.h),
          SalesdocketTimePickerSpinnerPopUp(
            label: LocaleKeys.expectedDateOfPayment.tr(),
            mode: CupertinoDatePickerMode.date,
            initTime:
                (oldCarPayment?.expectedDateOfPayment == null ||
                        oldCarPayment?.expectedDateOfPayment ==
                            "0000-00-00 00:00:00")
                    ? null
                    : DateTime.tryParse(
                        oldCarPayment?.expectedDateOfPayment ?? ""),
            onChange: (newDateTime) {
              ref.read(oldCarPaymentProvider.notifier).update(
                    (state) => state?.copyWith(
                      expectedDateOfPayment: newDateTime.formatDateTime(),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
