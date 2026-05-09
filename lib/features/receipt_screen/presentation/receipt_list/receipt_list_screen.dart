import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/receipt_list/receipt_list_item.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "ReceiptListRoute")
class ReceiptListScreen extends SalesdocketConsumerStatefulWidget {
  const ReceiptListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReceiptListState();
}

class _ReceiptListState extends SalesdocketConsumerState<ReceiptListScreen>
    with ReceiptEvents {
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
    final sourceType = ref.watch(receiptSourceProvider);
    final isLoading = ref.watch(loadingReceiptsStateProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: "${sourceType.value} ${LocaleKeys.receipts.tr()}",
          onHomeClicked: () => onHomeClicked(),
        ),
        body: isLoading ? _shimmerWidget : _listWidget,
      ),
    );
  }

  Widget get _shimmerWidget {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            top: index == 0 ? 1.5.h : 0.5.h,
            bottom: index == 7 ? 1.5.h : 0.5.h,
            left: 3.w,
            right: 3.w,
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
          decoration: BoxDecoration(
            color: appColors.secondary,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(color: appColors.border, width: 0.3.w),
          ),
          child: Column(
            spacing: 1.h,
            children: List.generate(
              5,
              (index) => Row(
                spacing: 4.w,
                children: [
                  SalesDocketShimmerWidget.rectangular(
                    height: 3.h,
                    width: 30.w,
                  ),
                  SalesDocketShimmerWidget.rectangular(
                    height: 3.h,
                    width: 40.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: 8,
    );
  }

  Widget get _listWidget {
    final sourceType = ref.watch(receiptSourceProvider);
    final receipts = ref
        .watch(receiptsProvider)
        .filteredReceipts(type: sourceType);
    final canEdit = ref.watch(canEditReceiptProvider);

    return ListView.builder(
      itemBuilder: (context, index) {
        final receipt = receipts[index];

        return Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 1.h : 0,
            bottom: index == receipts.length - 1 ? 1.h : 0,
          ),
          child: ReceiptListItem(
            receipt: receipt,
            canEdit: canEdit,
            onEditClicked: () => _onEditReceiptClicked(receipt),
          ),
        );
      },
      itemCount: receipts.length,
    );
  }

  void _invalidateProviders() {
    final providers = [receiptsProvider];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [loadingReceiptsStateProvider, receiptFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _fetchData() async {
    final lead = ref.read(receiptLeadProvider);
    await fetchReceipts(leadId: lead?.id);
  }

  void _onEditReceiptClicked(Receipt receipt) {
    ref.read(sendReceiptRequestProvider.notifier).update((state) => receipt);
    context.router.push(const AddEditReceiptRoute()).then((_) {
      fetchReceipts(leadId: receipt.leadId);
    });
  }

  @override
  void onReceiptsFetched(List<Receipt> list) {
    ref.read(receiptsProvider.notifier).update((state) => state = list);
    final receiptType = ref.read(sendReceiptRequestProvider)?.type;
    if (receiptType == ReceiptType.delivery.value) {
      ref
          .read(deliveryReceiptsProvider.notifier)
          .update((state) => state = list);
    } else if (receiptType == ReceiptType.booking.value) {
      ref
          .read(bookingReceiptsProvider.notifier)
          .update((state) => state = list);
    }
  }

  @override
  WidgetRef get eventRef => ref;
}
