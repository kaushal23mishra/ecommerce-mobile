import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_searchable_dropdown_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class MakeYearWidget extends SalesdocketConsumerWidget {
  const MakeYearWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelYear = ref.watch(
      selectedExchangeProductProvider.select((state) => state?.modelYear),
    );
    final itemList = List.generate(
      DateTime.now().year - 1900 + 1,
      (index) => (1900 + index).toString(),
    ).reversed.toList();

    final isECEditMode = ref.watch(isECEditModeProvider);
    final user = ref.watch(profileProvider);
    final isSC = user?.isSalesConsultant ?? false;
    final isEditable = isSC ? isECEditMode : true;

    return SalesdocketSearchableDropdownWidget<String>(
      label: LocaleKeys.modelYear.tr(),
      enabled: isEditable,
      selectedItem: modelYear?.toString(),
      items: itemList,
      itemAsString: (item) => item,
      compareFn: (a, b) => a == b,
      onChanged: (selected) {
        if (selected == null) return;
        final selectedYear = int.tryParse(selected);
        if (selectedYear != null) {
          ref
              .read(selectedExchangeProductProvider.notifier)
              .update(
                (state) => state = state?.copyWith(modelYear: selectedYear),
              );
        }
      },
    );
  }
}
