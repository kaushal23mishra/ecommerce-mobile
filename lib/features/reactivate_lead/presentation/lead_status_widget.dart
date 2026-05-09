import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/lead_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadStatusWidget extends SalesdocketConsumerWidget {
  const LeadStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeadStatus = ref.watch(
      createLeadHistoryRequestProvider.select((lead) => lead?.leadStatus),
    );
    final leadStatusError = ref
        .watch(reactivateLeadFormErrorsProvider)
        .get(LeadFormFields.leadStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketChipWidget(
          label: LocaleKeys.lblLeadStatusQuestion.tr(),
          isRequired: true,
          chips:
              LeadState.values.map((state) => state.value.toCamelCase).toList(),
          selectedChips: [selectedLeadStatus?.toCamelCase ?? ""],
          onSelected: (selected) {
            ref
                .read(createLeadHistoryRequestProvider.notifier)
                .update(
                  (toUpdate) =>
                      toUpdate = toUpdate?.copyWith(
                        leadStatus: selected?.firstOrNull?.toUpperCase(),
                      ),
                );
            ref
                .read(reactivateLeadFormErrorsProvider.notifier)
                .remove(LeadFormFields.leadStatus);
          },
          errorText: leadStatusError?.message,
        ),
      ],
    );
  }
}
