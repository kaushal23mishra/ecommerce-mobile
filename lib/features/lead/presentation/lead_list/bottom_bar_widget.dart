import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/sort_by.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_search_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_sort_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BottomBarWidget extends SalesdocketConsumerStatefulWidget {
  const BottomBarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends SalesdocketConsumerState<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Container(
      decoration: BoxDecoration(
        color: appColors.secondary,
        boxShadow: [
          BoxShadow(
            color: appColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: items.length,
          mainAxisExtent: 6.h,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Row(
            children: [
              Expanded(
                child: HeaderItem(
                  item: item,
                  onTap: () {
                    if (item.action != null) {
                      item.action!(context);
                    }
                  },
                ),
              ),
              if (index < items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: VerticalDivider(
                    color: appColors.border,
                    thickness: 0.2.w,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<MenuItem> get _items {
    final screenType = ref.watch(leadListScreenTypeProvider);
    final defaultFilter =
        LeadListUtils.getLeadListDetails(
          screenType,
        ).defaultRequest.toJson().filteredJsonRequest;
    final appliedFilter =
        ref.watch(getLeadRequestProvider)?.toJson().filteredJsonRequest;

    final isSearchApplied =
        appliedFilter?.containsKey('searchby') == true &&
        appliedFilter?.containsKey('search') == true;
    appliedFilter?.remove('search');
    appliedFilter?.remove('searchby');

    final isSortApplied =
        appliedFilter != null &&
        (appliedFilter['order_by'] != SortBy.date.value.toLowerCase() ||
            appliedFilter['order'] != null);
    appliedFilter?.remove('order_by');
    appliedFilter?.remove('order');
    defaultFilter.remove('order_by');
    defaultFilter.remove('order');

    final isFilterApplied =
        json.encode(defaultFilter) != json.encode(appliedFilter);

    return [
      MenuItem(
        title: LocaleKeys.lblSearch.tr(),
        fabIcon: Icons.search,
        action: _onSearchClicked,
        shouldShowFab: isSearchApplied,
      ),
      MenuItem(
        title: LocaleKeys.lblFilter.tr(),
        fabIcon: Icons.filter_alt_outlined,
        action: _onFilterClicked,
        show:
            LeadListUtils.getLeadListDetails(
              ref.watch(leadListScreenTypeProvider),
            ).filterItems.where((filter) => filter.show).isNotEmpty,
        shouldShowFab: isFilterApplied,
      ),
      MenuItem(
        title: LocaleKeys.lblSort.tr(),
        fabIcon: Icons.sort,
        action: _onSortClicked,
        shouldShowFab: isSortApplied,
      ),
    ].where((item) => item.show).toList();
  }

  void _onSearchClicked(BuildContext context) {
    showSalesdocketBottomSheet(
      context: context,
      builder:
          (context) => SalesdocketBottomSheet(
            title: LocaleKeys.lblSearchLeads.tr(),
            widget: const LeadSearchWidget(),
          ),
    );
  }

  void _onFilterClicked(BuildContext context) {
    final getLeadRequest = ref.read(getLeadRequestProvider);
    ref
        .read(leadFilterRequestProvider.notifier)
        .update((toUpdate) => toUpdate = getLeadRequest?.createFilterRequest);

    context.router.push(
      LeadFilterRoute(
        onFilterApplied: () {
          final leadFilterRequest = ref.read(leadFilterRequestProvider);
          ref
              .read(getLeadRequestProvider.notifier)
              .update(
                (toUpdate) => toUpdate = leadFilterRequest?.formattedFilters,
              );
          _fetchLeads();
          context.router.back();
        },
      ),
    );
  }

  void _onSortClicked(BuildContext context) {
    showSalesdocketBottomSheet(
      context: context,
      builder:
          (context) => SalesdocketBottomSheet(
            title: LocaleKeys.lblSortLeads.tr(),
            widget: const LeadSortWidget(),
          ),
    );
  }

  void _fetchLeads({int page = 1}) async {
    ref.invalidate(leadsProvider);
    ref.invalidate(selectedLeadsProvider);
    ref.read(leadsProvider(page: page));
  }
}

class HeaderItem extends SalesdocketStatelessWidget {
  final MenuItem item;
  final Function() onTap;

  const HeaderItem({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.show) {
          onTap();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            item.fabIcon ?? Icons.menu,
            color: appColors.grayDark,
            size: 5.w,
          ),
          horizontalSpacing(1.w),
          Text(
            item.title?.tr().toUpperCase() ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          _filterSelectedNotificationWidget(item.shouldShowFab),
        ],
      ),
    );
  }

  Widget _filterSelectedNotificationWidget(bool isApplied) {
    return isApplied
        ? Container(
          width: 1.5.w,
          height: 1.5.w,
          margin: EdgeInsets.only(left: 1.w),
          decoration: BoxDecoration(
            color: appColors.redLight,
            borderRadius: BorderRadius.circular(100),
          ),
        )
        : const SizedBox.shrink();
  }
}
