import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class ProspectSheetDateOfEvaluationWidget extends ConsumerWidget {
  const ProspectSheetDateOfEvaluationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeProduct = ref.watch(selectedExchangeProductProvider);
    final dateOfEvaluation = exchangeProduct?.dateOfEvaluation;

    DateTime? initDate;
    if (dateOfEvaluation != null &&
        dateOfEvaluation.isNotEmpty &&
        dateOfEvaluation != "0000-00-00 00:00:00") {
      try {
        initDate = DateTime.parse(dateOfEvaluation);
      } catch (_) {
        initDate = null;
      }
    }

    // Get the created_at date as minimum date
    DateTime? minDate;
    DateTime? maxDate = DateTimeConstants.currentMaxDateTime;

    if (exchangeProduct?.createdAt != null &&
        exchangeProduct!.createdAt!.isNotEmpty) {
      try {
        final createdAtDate = DateTime.parse(exchangeProduct.createdAt!);

        // Check if lead is in EPE status and was created within 1 hour
        final isWithinOneHour =
            DateTime.now().difference(createdAtDate).inHours < 1;

        if (isWithinOneHour) {
          // Only allow current day selection
          final today = DateTime.now();
          minDate = DateTime(today.year, today.month, today.day);
          maxDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
        } else {
          minDate = createdAtDate;
        }
      } catch (_) {
        minDate = DateTime.now();
      }
    } else {
      minDate = DateTime.now();
    }

    final error = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.dateOfEvaluation);

    final isECEditMode = ref.watch(isECEditModeProvider);
    final user = ref.watch(profileProvider);
    final isSC = user?.isSalesConsultant ?? false;
    final isEditable = isSC ? isECEditMode : true;

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.lblDateOfEvaluation.tr(),
      enable: isEditable,
      mode: CupertinoDatePickerMode.date,
      initTime: initDate,
      minTime: minDate,
      maxTime: maxDate,
      onChange: (newDate) {
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update(
              (state) =>
                  state?.copyWith(dateOfEvaluation: newDate.formatDateTime()),
            );

        ref
            .read(prospectFormErrorsProvider.notifier)
            .remove(LeadFormFields.dateOfEvaluation);
      },
      errorText: error?.message,
    );
  }
}
