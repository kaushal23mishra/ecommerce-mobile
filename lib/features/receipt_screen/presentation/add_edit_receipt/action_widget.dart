import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerStatefulWidget {
  const ActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionState();
}

class _ActionState extends SalesdocketConsumerState<ActionWidget>
    with ReceiptEvents {
  bool _isAddMoreClicked = false;

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(sendReceiptRequestProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child:
          request?.id != null
              ? SalesDocketButtonWidget(
                text: "Edit Receipt",
                onPressed: () {
                  _validateFormAndSubmitRequest();
                },
              )
              : Row(
                spacing: 4.w,
                children: [
                  Expanded(
                    child: SalesDocketButtonWidget(
                      text: LocaleKeys.lblCancel.tr(),
                      isOutlined: true,
                      onPressed: () {
                        context.router.back();
                      },
                    ),
                  ),
                  Expanded(
                    child: SalesDocketButtonWidget(
                      text: LocaleKeys.lblSave.tr(),
                      onPressed: () {
                        _isAddMoreClicked = false;
                        _validateFormAndSubmitRequest();
                      },
                    ),
                  ),
                  Expanded(
                    child: SalesDocketButtonWidget(
                      text: LocaleKeys.addMore.tr(),
                      onPressed: () {
                        _isAddMoreClicked = true;
                        _validateFormAndSubmitRequest();
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  void _validateFormAndSubmitRequest() {
    if (_isValidForm()) {
      final request = ref.read(sendReceiptRequestProvider);
      if (request?.id != null) {
        updateReceipt(receiptId: request?.id, request: request);
      } else {
        addReceipt(request: request);
      }
    }
  }

  bool _isValidForm() {
    final request = ref.read(sendReceiptRequestProvider);
    final errors = request?.addReceiptValidationErrors() ?? [];

    final amountCapError =
        ref.read(receiptViewModelProvider.notifier).validateAmountCap();
    if (amountCapError != null) errors.add(amountCapError);

    if (errors.isNotEmpty) {
      ref.read(receiptFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _invalidateProviders() {
    ref
        .read(sendReceiptRequestProvider.notifier)
        .update(
          (state) => state = Receipt(leadId: state?.leadId, type: state?.type),
        );

    final notifiers = [receiptFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  @override
  void onReceiptAdded() {
    if (_isAddMoreClicked) {
      _invalidateProviders();
      return;
    }

    context.router.back();
  }

  @override
  void onReceiptUpdated() {
    context.router.back();
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }
}
