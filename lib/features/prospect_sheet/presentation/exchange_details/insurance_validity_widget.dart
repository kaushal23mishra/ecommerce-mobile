import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class InsuranceValidityWidget extends SalesdocketConsumerWidget {
  const InsuranceValidityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insuranceValidity = ref.watch(
      selectedExchangeProductProvider.select(
        (product) => product?.insuranceValidity,
      ),
    );
    final error = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.insuranceValidity);
    return Column(
      spacing: 1.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.insuranceValidity.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SalesdocketTimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.date,
          enable: true,
          initTime:
              insuranceValidity == null ||
                      insuranceValidity == "0000-00-00 00:00:00"
                  ? null
                  : DateTime.parse(insuranceValidity),
          onChange: (newDate) {
            ref
                .read(selectedExchangeProductProvider.notifier)
                .update(
                  (state) =>
                      state = state?.copyWith(
                        insuranceValidity: newDate.formatDateTime(),
                      ),
                );
            ref
                .read(prospectFormErrorsProvider.notifier)
                .remove(LeadFormFields.insuranceValidity);
          },
          errorText: error?.message,
        ),
      ],
    );
  }
}
