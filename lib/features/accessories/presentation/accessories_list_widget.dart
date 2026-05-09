import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/accessories/presentation/accessories_list_item.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AccessoriesListWidget extends SalesdocketConsumerWidget {
  const AccessoriesListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingStateProvider);
    return isLoading ? _shimmerWidget : _listWidget(ref);
  }

  Widget get _shimmerWidget {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            children: [
              horizontalSpacing(2.w),
              Expanded(
                child: SalesDocketShimmerWidget.rectangular(
                  height: 4.h,
                  width: 30.w,
                ),
              ),
              SalesDocketShimmerWidget.rectangular(height: 4.h, width: 20.w),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: 8,
    );
  }

  Widget _listWidget(WidgetRef ref) {
    final accessories = ref.watch(accessoriesProvider);
    final selectedAccessories = ref.watch(selectedAccessoriesProvider);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final accessory = accessories[index];
        return AccessoriesListItem(
          accessory: accessory,
          onRemoved: () {
            // This will be triggered if the accessory is removed from the offer summary
            selectedAccessories.remove(accessory);
            ref.read(selectedAccessoriesProvider.notifier).state =
                selectedAccessories;
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: accessories.length,
    );
  }
}
