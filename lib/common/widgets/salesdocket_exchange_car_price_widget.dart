import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketExchangeCarPriceWidget
    extends SalesdocketConsumerStatefulWidget {
  final bool? isInEditMode;
  final ExchangeProduct? exchangeCar;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;

  const SalesdocketExchangeCarPriceWidget({
    super.key,
    this.exchangeCar,
    this.onChanged,
    this.isInEditMode = true,
    this.errors = const {},
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketExchangeCarPriceWidget();
}

class _SalesdocketExchangeCarPriceWidget
    extends SalesdocketConsumerState<SalesdocketExchangeCarPriceWidget> {
  final _differenceTextController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDifference(
        widget.exchangeCar?.expectedPrice,
        widget.exchangeCar?.quotedPrice,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _differenceTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.w,
      children: [
        Expanded(flex: 9, child: _expectedPriceWidget),
        Expanded(flex: 8,
            child: _quotedPriceWidget),
        Expanded(flex: 7,child: _differenceWidget),
      ],
    );
  }

  Widget get _expectedPriceWidget {
    return SalesDocketInputWidget(
      enable: widget.isInEditMode ?? true,
      label: LocaleKeys.expectedPrice.tr(),
      hint: LocaleKeys.expectedPrice.tr(),
      initialValue: (widget.exchangeCar?.expectedPrice ?? "").toString(),
      inputType: TextInputType.number,
      isRequired: false,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          final price = int.tryParse(newValue.trim());
          widget.onChanged!(LeadFormFields.expectedPrice, price, null);
          _setDifference(price, widget.exchangeCar?.quotedPrice);
        }
      },
      errorMsg: widget.errors[LeadFormFields.expectedPrice]?.message,
    );
  }

  Widget get _quotedPriceWidget {
    return SalesDocketInputWidget(
      enable: widget.isInEditMode ?? true,
      label: LocaleKeys.quotedPrice.tr(),
      hint: LocaleKeys.quotedPrice.tr(),
      initialValue: (widget.exchangeCar?.quotedPrice ?? "").toString(),
      inputType: TextInputType.number,
      isRequired: false,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          final price = int.tryParse(newValue.trim());
          widget.onChanged!(LeadFormFields.quotedPrice, price, null);
          _setDifference(widget.exchangeCar?.expectedPrice, price);
        }
      },
      errorMsg: widget.errors[LeadFormFields.quotedPrice]?.message,
    );
  }

  Widget get _differenceWidget {
    final expected = widget.exchangeCar?.expectedPrice;
    final quoted = widget.exchangeCar?.quotedPrice;

    return SalesDocketInputWidget(
      label: LocaleKeys.difference.tr(),
      hint: LocaleKeys.difference.tr(),
      controller: _differenceTextController,
      inputType: TextInputType.number,
      textFieldColor:
          (expected ?? 0) <= (quoted ?? 0)
              ? appColors.success
              : appColors.redDark,
      enable: false,
      viewOnly: true,
    );
  }

  void _setDifference(int? expected, int? quoted) {
    _differenceTextController.text =
        ((expected ?? 0) - (quoted ?? 0)).abs().toString();
  }
}
