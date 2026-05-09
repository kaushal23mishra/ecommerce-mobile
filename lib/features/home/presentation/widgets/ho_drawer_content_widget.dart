import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/features/home/presentation/widgets/ho_drawer_list_widget.dart';
import 'package:salesdocket_mobile/features/home/presentation/widgets/ho_drawer_shimmer_widget.dart';
import 'package:salesdocket_mobile/features/home/view_model/ho_drawer_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

/// Drawer content widget for HO (Head Office) users.
///
/// Behavior:
/// 1. Drawer opens → shows shimmer loader while data is loading
/// 2. Data loads successfully → displays organization tree list
/// 3. No data → shows "No organization data available"
/// 4. Error → shows error UI with retry option
class HoDrawerContentWidget extends SalesdocketConsumerWidget {
  const HoDrawerContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeAsync = ref.watch(hoDrawerViewModelProvider);

    // Check if this is the initial load (data is null and we're not in error state)
    final isInitialLoad = treeAsync.isLoading ||
        (treeAsync.hasValue && treeAsync.value == null &&
            !treeAsync.hasError);

    if (isInitialLoad) {
      return const HoDrawerShimmerWidget();
    }

    return treeAsync.when(
      /// 1️⃣ DATA STATE
      data: (tree) {
        if (tree == null) {
          return _buildEmptyState(context);
        }

        final flatList = tree.getFlatList();
        if (flatList.isEmpty) {
          return _buildEmptyState(context);
        }

        return HoDrawerListWidget(items: flatList);
      },

      /// 2️⃣ ERROR STATE
      error: (error, stack) => _buildErrorState(context, ref),

      /// 3️⃣ LOADING STATE (should not reach here due to initial check)
      loading: () => const HoDrawerShimmerWidget(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Text(
          LocaleKeys.msgNoOrganizationData.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: appColors.textDisabled,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 12.w,
              color: appColors.redDark,
            ),
            verticalSpacing(2.h),
            Text(
              LocaleKeys.msgFailedToLoadOrganizationData.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: appColors.textDisabled,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(1.h),
            TextButton(
              onPressed: () {
                ref
                    .read(hoDrawerViewModelProvider.notifier)
                    .fetchOrganizationTree();
              },
              child: Text(
                LocaleKeys.btnRetry.tr(),
                style: TextStyle(color: appColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}