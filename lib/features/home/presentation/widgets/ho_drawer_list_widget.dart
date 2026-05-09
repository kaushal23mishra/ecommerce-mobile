import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/home/view_model/ho_selection_providers.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class HoDrawerListWidget extends SalesdocketConsumerWidget {
  final List<HoDrawerItemEntity> items;

  const HoDrawerListWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Text(
            'No data available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: appColors.textDisabled,
                ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildListItem(context, ref, item);
      },
    );
  }

  Widget _buildListItem(
    BuildContext context,
    WidgetRef ref,
    HoDrawerItemEntity item,
  ) {
    final bool isSelected = _isItemSelected(ref, item);
    final bool isDesignation = item.type == HoDrawerItemType.designation;

    return GestureDetector(
      onTap: () {
        _handleItemTap(ref, item);
      },
      child: Container(
        color: isSelected
            ? appColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        child: Row(
          children: [
            Icon(
              isDesignation ? Icons.people : Icons.store,
              size: 5.w,
              color: isSelected ? appColors.primary : appColors.grayDark,
            ),
            horizontalSpacing(3.w),
            Expanded(
              child: Text(
                item.name.toCamelCase,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? appColors.primary
                          : appColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isItemSelected(WidgetRef ref, HoDrawerItemEntity item) {
    if (item.type == HoDrawerItemType.designation) {
      final selectedDesignationId = ref.watch(selectedDesignationIdProvider);
      return selectedDesignationId == item.id;
    } else {
      final selectedOutletId = ref.watch(selectedOutletIdProvider);
      return selectedOutletId == item.id;
    }
  }

  void _handleItemTap(WidgetRef ref, HoDrawerItemEntity item) {
    if (item.type == HoDrawerItemType.designation) {
      // Select designation, clear outlet selection
      ref.read(selectedDesignationIdProvider.notifier).state = item.id;
      ref.read(selectedDesignationNameProvider.notifier).state = item.name;
      ref.read(selectedOutletIdProvider.notifier).state = null;
      ref.read(selectedOutletNameProvider.notifier).state = null;

      // Set designation ID for HO context
      ref
          .read(hoOrganizationContextProvider.notifier)
          .setDesignationId(item.id);
    } else {
      // Select outlet, clear designation selection
      ref.read(selectedOutletIdProvider.notifier).state = item.id;
      ref.read(selectedOutletNameProvider.notifier).state = item.name;
      ref.read(selectedDesignationIdProvider.notifier).state = null;
      ref.read(selectedDesignationNameProvider.notifier).state = null;

      // Set organization/outlet ID for HO context
      ref
          .read(hoOrganizationContextProvider.notifier)
          .setOrganizationId(item.id);
    }

    // Close drawer and navigate to manager dashboard
    _navigateToManagerDashboard(ref, item);
  }

  void _navigateToManagerDashboard(WidgetRef ref, HoDrawerItemEntity item) {
    final context = ref.context;

    // Close the drawer
    if (context.mounted) {
      context.router.maybePop();
    }

    // Show feedback message
    final message = 'Viewing dashboard for: ${item.name}';

    // Show toast/snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: appColors.primary,
      ),
    );

    // Dashboard will automatically refresh and use the selected organization ID
    // from selectedDesignationIdProvider or selectedOutletIdProvider
  }
}
