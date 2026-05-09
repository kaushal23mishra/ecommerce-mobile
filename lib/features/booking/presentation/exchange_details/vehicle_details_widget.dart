import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_exchange_car_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class VehicleDetailsWidget extends SalesdocketConsumerWidget {
  const VehicleDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEditDetails = ref.watch(editExistingVehicleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.exchangeDetails.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SalesdocketSwitchWidget(
              value: canEditDetails,
              label: LocaleKeys.edit.tr(),
              onChanged: (value) {
                ref
                    .read(editExistingVehicleProvider.notifier)
                    .update((state) => state = value);
              },
            ),
          ],
        ),
        verticalSpacing(1.h),
        canEditDetails
            ? _editDetailsWidget(context, ref)
            : _detailsWidget(context, ref),
      ],
    );
  }

  Widget _detailsWidget(BuildContext context, WidgetRef ref) {
    final car = ref.watch(selectedExchangeCarProvider);
    final carName =
        "${car?.oldVehicleName ?? ""} ${car?.oldVehicleVariantName ?? ""}";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 4.w, bottom: 4.w, left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: appColors.primaryLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.3.w),
      ),
      child: Text(
        carName.isEmpty ? LocaleKeys.selectVehicle.tr() : carName,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
      ),
    );
  }

  Widget _editDetailsWidget(BuildContext context, WidgetRef ref) {
    final exchangeCar = ref.watch(selectedExchangeCarProvider);
    final user = ref.watch(profileProvider);
    final lead = ref.watch(bookingLeadRequestProvider);
    return SalesdocketExchangeCarWidget(
      isExchangeStatus: (!user!.isEvaluator && !lead!.isEC) || user.isEvaluator,
      exchangeCar: exchangeCar,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
      errors: _errors(ref),
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(bookingFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.selectBrand:
        ref
            .read(selectedExchangeCarProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    oldVehicleId: key,
                    oldVehicleName: value,
                    oldVehicleVariantId: null,
                    oldVehicleVariantName: null,
                  ),
            );
        break;
      case LeadFormFields.selectBrandModel:
        ref
            .read(selectedExchangeCarProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    oldVehicleVariantId: key,
                    oldVehicleVariantName: value,
                  ),
            );
        break;
      default:
        break;
    }
  }

  Map<LeadFormFields, FormFieldError?> _errors(WidgetRef ref) {
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(bookingFormErrorsProvider).get(field);
    }

    return errors;
  }

  get _formFields => [
    LeadFormFields.selectBrand,
    LeadFormFields.selectBrandModel,
  ];
}
