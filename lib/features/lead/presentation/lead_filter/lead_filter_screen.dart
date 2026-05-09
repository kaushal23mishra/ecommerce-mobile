import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'LeadFilterRoute')
class LeadFilterScreen extends SalesdocketConsumerStatefulWidget {
  final Function() onFilterApplied;

  const LeadFilterScreen({super.key, required this.onFilterApplied});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadFilterState();
}

class _LeadFilterState extends SalesdocketConsumerState<LeadFilterScreen>
    with LeadEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SalesDocketAppBarWidget(
        titleText: LocaleKeys.lblFilterBy.tr(),
        onHomeClicked: () => onHomeClicked(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 6, child: _buildFilterOptionsList),
                Expanded(flex: 11, child: _buildFilterDetailsSection),
              ],
            ),
          ),
          _actionWidget,
        ],
      ),
    );
  }

  Widget get _buildFilterOptionsList {
    final items = _filters;
    final selectedMenuItemIndex = ref.watch(leadSelectedFilterMenuItemIndex);

    return Container(
      color: appColors.grayLight,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final option = items[index];
          return GestureDetector(
            onTap: () {
              ref
                  .read(leadSelectedFilterMenuItemIndex.notifier)
                  .update((toUpdate) => toUpdate = index);
            },
            child: _buildFilterOption(
              option,
              isSelected: selectedMenuItemIndex == index,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterOption(MenuItem option, {bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? appColors.background : appColors.grayLight,
        border: Border(
          bottom: BorderSide(color: appColors.grayDark, width: 0.1.w),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 2.25.h, horizontal: 3.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              option.title ?? "",
              style:
                  isSelected
                      ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: appColors.primary,
                        fontSize: 15.sp,
                      )
                      : Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 15.sp),
            ),
          ),
          horizontalSpacing(2.w),
          _filterSelectedNotificationWidget(option),
        ],
      ),
    );
  }

  Widget _filterSelectedNotificationWidget(MenuItem option) {
    final isFilterSelected =
        ref.watch(leadFilterRequestProvider)?.isFilterSelected(option) ?? false;

    return isFilterSelected
        ? Container(
          width: 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: appColors.redLight,
            borderRadius: BorderRadius.circular(100),
          ),
        )
        : const SizedBox.shrink();
  }

  Widget get _buildFilterDetailsSection {
    final selectedMenuItemIndex = ref.watch(leadSelectedFilterMenuItemIndex);

    return _filters.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child:
              _filters[selectedMenuItemIndex].content ??
              const SizedBox.shrink(),
        );
  }

  Widget get _actionWidget {
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _clearFilters,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Center(
                  child: Text(
                    LocaleKeys.lblClear.tr().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: appColors.textDisabled,
                      fontSize: 15.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          Container(color: appColors.border, width: 0.2.w, height: 3.h),
          Expanded(
            child: GestureDetector(
              onTap: _applyFilters,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Center(
                  child: Text(
                    LocaleKeys.lblApply.tr().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: appColors.primary,
                      fontSize: 15.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    ref
        .read(leadFilterRequestProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate =
                  LeadListUtils.getLeadListDetails(_screenType).defaultRequest,
        );
  }

  void _applyFilters() {
    widget.onFilterApplied();
  }

  void _invalidateProviders() {
    final providers = [leadSelectedFilterMenuItemIndex, leadCountsProviders];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    getLeadCounts();
  }

  List<MenuItem> get _filters =>
      LeadListUtils.getLeadListDetails(
        _screenType,
      ).filterItems.where((filter) => filter.show).toList();

  LeadListScreenType get _screenType => ref.read(leadListScreenTypeProvider);

  @override
  void onLeadCountsFetched(LeadCounts? data) {
    ref
        .read(leadCountsProviders.notifier)
        .update((toUpdate) => toUpdate = data);
  }

  @override
  WidgetRef get eventRef => ref;
}
