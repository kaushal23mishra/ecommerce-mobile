import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/action_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/amount_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/date_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/mode_of_payment_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/name_no_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/pending_amount_type_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/presentation/add_edit_receipt/type_widget.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "AddEditReceiptRoute")
class AddEditReceiptScreen extends SalesdocketConsumerStatefulWidget {
  const AddEditReceiptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEditReceiptState();
}

class _AddEditReceiptState
    extends SalesdocketConsumerState<AddEditReceiptScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);
    final request = ref.watch(sendReceiptRequestProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText:
              request?.id != null
                  ? LocaleKeys.editReceipt.tr()
                  : LocaleKeys.addReceipt.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    verticalSpacing(3.h),
                    const NameNoWidget(),
                    verticalSpacing(2.h),
                    const DateWidget(),
                    verticalSpacing(3.h),
                    const AmountWidget(),
                    verticalSpacing(2.5.h),
                    const ModeOfPaymentWidget(),
                    const PendingAmountTypeWidget(),
                    verticalSpacing(3.h),
                    const TypeWidget(),
                    verticalSpacing(3.h),
                    const ActionWidget(),
                  ],
                ),
              ),
            ),
            SalesdocketLoadingOverlay(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  void _invalidateProviders() {
    ref.invalidate(receiptFormErrorsProvider);
  }
}
