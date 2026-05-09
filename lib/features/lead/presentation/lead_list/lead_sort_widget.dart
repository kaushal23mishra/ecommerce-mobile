import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/sort_by.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadSortWidget extends SalesdocketConsumerStatefulWidget {
  const LeadSortWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadSortState();
}

class _LeadSortState extends SalesdocketConsumerState<LeadSortWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [_sortByWidget, _sortOrderWidget, _actionWidget],
    );
  }

  Widget get _sortByWidget {
    final selectedSortBy = ref.watch(
      getLeadRequestProvider.select((req) => req?.orderBy),
    );

    return SalesDocketDropDownWidget(
      text: LocaleKeys.lblSortBy.tr(),
      itemList: sortByList.map((item) => item.value).toList(),
      itemValue: selectedSortBy?.toCamelCase,
      imagePath: Assets.svg.arrowDown.path,
      onChanged: (selected) {
        ref
            .read(getLeadRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    orderBy: selected?.toLowerCase(),
                  ),
            );
      },
    );
  }

  Widget get _sortOrderWidget {
    final selectedOrder = ref.watch(
      getLeadRequestProvider.select((req) => req?.order),
    );

    // Convert API values (asc/desc) to display values (Ascending/Descending)
    String? displayOrder;
    if (selectedOrder == 'asc') {
      displayOrder = SortOrder.ascending.value;
    } else if (selectedOrder == 'desc') {
      displayOrder = SortOrder.descending.value;
    }

    return SalesDocketDropDownWidget(
      text: LocaleKeys.lblSortOrder.tr(),
      itemList: sortOrderList.map((item) => item.value).toList(),
      itemValue: displayOrder,
      imagePath: Assets.svg.arrowDown.path,
      onChanged: (selected) {
        // Convert display values to API values
        String? apiOrder;
        if (selected == SortOrder.ascending.value) {
          apiOrder = 'asc';
        } else if (selected == SortOrder.descending.value) {
          apiOrder = 'desc';
        }

        ref
            .read(getLeadRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    order: apiOrder,
                  ),
            );
      },
    );
  }

  Widget get _actionWidget {
    return Row(
      spacing: 4.w,
      children: [
        Expanded(
          child: SalesDocketButtonWidget(
            text: LocaleKeys.lblClear.tr(),
            isOutlined: true,
            onPressed: () {
              final request = ref.read(getLeadRequestProvider);
              ref
                  .read(getLeadRequestProvider.notifier)
                  .update(
                    (toUpdate) =>
                        toUpdate = toUpdate?.copyWith(
                          orderBy: 'date',
                          order: null,
                        ),
                  );
              if (request?.isSortApplied == true) {
                _fetchLeads();
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        Expanded(
          child: SalesDocketButtonWidget(
            text: LocaleKeys.lblSort.tr(),
            onPressed: () {
              _fetchLeads();
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  _fetchLeads({int page = 1}) async {
    ref.invalidate(leadsProvider);
    ref.invalidate(selectedLeadsProvider);
    ref.read(leadsProvider(page: page));
  }
}
