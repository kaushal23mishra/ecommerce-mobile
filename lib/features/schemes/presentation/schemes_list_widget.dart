import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/schemes/presentation/brokerage_list_item.dart';
import 'package:salesdocket_mobile/features/schemes/presentation/scheme_list_item.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SchemesListWidget extends SalesdocketConsumerStatefulWidget {
  const SchemesListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchemesListState();
}

class _SchemesListState extends SalesdocketConsumerState<SchemesListWidget> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);
    return isLoading ? _shimmerWidget : _listWidget;
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

  Widget get _listWidget {
    final schemes = ref.watch(schemesProvider);
    final selectedSchemes = ref.watch(selectedSchemesProvider);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return index == schemes.length
            ? const BrokerageListItem()
            : SchemeListItem(
              scheme: schemes[index],
              onRemoved: () {
                // This will be triggered if the scheme is removed from the offer summary
                selectedSchemes.removeWhere((s) => s.id == schemes[index].id);
                ref.read(selectedSchemesProvider.notifier).state =
                    selectedSchemes;
              },
            );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: schemes.length + 1,
    );
  }
}
