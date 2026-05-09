import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BrokerageListItem extends SalesdocketConsumerStatefulWidget {
  const BrokerageListItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BrokerageListItemState();
}

class _BrokerageListItemState
    extends SalesdocketConsumerState<BrokerageListItem>
    with ProductEvents {
  @override
  Widget build(BuildContext context) {
    final brokerage = ref.watch(schemesBrokerProvider);
    final isChecked = brokerage != null;

    return Column(
      children: [
        Row(
          children: [
            horizontalSpacing(2.w),
            Expanded(
              child: Text(
                LocaleKeys.brokerage.tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SalesdocketSwitchWidget(
              value: isChecked,
              onChanged: (value) async {
                if (isChecked) {
                  deleteBroker(brokerId: brokerage.id);
                } else {
                  ref
                      .read(schemesBrokerProvider.notifier)
                      .update((state) => state = const Brokerage());
                }
              },
            ),
          ],
        ),
        isChecked
            ? _brokerageEditFields(context, ref)
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _brokerageEditFields(BuildContext context, WidgetRef ref) {
    final errors = ref.watch(brokerFormErrorsProvider);
    final brokerage = ref.watch(schemesBrokerProvider);

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        spacing: 2.h,
        children: [
          Row(
            spacing: 4.w,
            children: [
              Expanded(
                child: SalesDocketInputWidget(
                  label: LocaleKeys.brokerName.tr(),
                  hint: LocaleKeys.brokerName.tr(),
                  initialValue: brokerage?.brokerName,
                  inputFormatters: InputFormatters.lettersOnly,
                  onChanged:
                      (value) => _onBrokerValueChanged(
                        BrokerFormFields.name,
                        value,
                        ref,
                      ),
                  errorMsg: errors.get(BrokerFormFields.name)?.message,
                ),
              ),
              Expanded(
                child: SalesDocketInputWidget(
                  label: LocaleKeys.brokerCity.tr(),
                  hint: LocaleKeys.brokerCity.tr(),
                  initialValue: brokerage?.brokerCity,
                  inputFormatters: InputFormatters.lettersOnly,
                  onChanged:
                      (value) => _onBrokerValueChanged(
                        BrokerFormFields.city,
                        value,
                        ref,
                      ),
                  errorMsg: errors.get(BrokerFormFields.city)?.message,
                ),
              ),
            ],
          ),
          Row(
            spacing: 4.w,
            children: [
              Expanded(
                child: SalesDocketInputWidget(
                  label: LocaleKeys.brokerMobile.tr(),
                  hint: LocaleKeys.brokerMobile.tr(),
                  initialValue: brokerage?.brokerMobile,
                  inputType: TextInputType.phone,
                  inputFormatters: InputFormatters.mobile,
                  maxLength: 10,
                  onChanged:
                      (value) => _onBrokerValueChanged(
                        BrokerFormFields.mobile,
                        value,
                        ref,
                      ),
                  errorMsg: errors.get(BrokerFormFields.mobile)?.message,
                ),
              ),
              Expanded(
                child: SalesDocketInputWidget(
                  label: LocaleKeys.brokerAmount.tr(),
                  hint: LocaleKeys.brokerAmount.tr(),
                  initialValue: "${brokerage?.brokerAmount ?? ""}",
                  inputType: TextInputType.number,
                  onChanged:
                      (value) => _onBrokerValueChanged(
                        BrokerFormFields.amount,
                        value,
                        ref,
                      ),
                  errorMsg: errors.get(BrokerFormFields.amount)?.message,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onBrokerValueChanged(
    BrokerFormFields field,
    String value,
    WidgetRef ref,
  ) {
    ref.read(brokerFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case BrokerFormFields.name:
        ref
            .read(schemesBrokerProvider.notifier)
            .update((state) => state = state?.copyWith(brokerName: value));
        break;
      case BrokerFormFields.city:
        ref
            .read(schemesBrokerProvider.notifier)
            .update((state) => state = state?.copyWith(brokerCity: value));
        break;
      case BrokerFormFields.mobile:
        ref
            .read(schemesBrokerProvider.notifier)
            .update((state) => state = state?.copyWith(brokerMobile: value));
        break;
      case BrokerFormFields.amount:
        ref
            .read(schemesBrokerProvider.notifier)
            .update(
              (state) =>
                  state = state?.copyWith(brokerAmount: int.tryParse(value)),
            );
        break;
      default:
        break;
    }
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  void onBrokerDeleted() {
    ref.invalidate(schemesBrokerProvider);
    ref.invalidate(updatedBrokerProvider);
    ref.invalidate(brokerFormErrorsProvider);
  }

  @override
  WidgetRef get eventRef => ref;
}

class BrokerageNonEditableWidget extends SalesdocketConsumerWidget {
  const BrokerageNonEditableWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brokerage = ref.watch(updatedBrokerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [
        Text(
          LocaleKeys.brokerage.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Row(
          spacing: 4.w,
          children: [
            Expanded(
              child: SalesDocketInputWidget(
                label: LocaleKeys.brokerName.tr(),
                hint: LocaleKeys.brokerName.tr(),
                controller: TextEditingController(
                  text: brokerage?.brokerName ?? "",
                ),
                enable: false,
                viewOnly: true,
              ),
            ),
            Expanded(
              child: SalesDocketInputWidget(
                label: LocaleKeys.brokerCity.tr(),
                hint: LocaleKeys.brokerCity.tr(),
                controller: TextEditingController(
                  text: brokerage?.brokerCity ?? "",
                ),
                enable: false,
                viewOnly: true,
              ),
            ),
          ],
        ),
        Row(
          spacing: 4.w,
          children: [
            Expanded(
              child: SalesDocketInputWidget(
                label: LocaleKeys.brokerMobile.tr(),
                hint: LocaleKeys.brokerMobile.tr(),
                controller: TextEditingController(
                  text: brokerage?.brokerMobile ?? "",
                ),
                enable: false,
                viewOnly: true,
              ),
            ),
            Expanded(
              child: SalesDocketInputWidget(
                label: LocaleKeys.brokerAmount.tr(),
                hint: LocaleKeys.brokerAmount.tr(),
                controller: TextEditingController(
                  text: "${brokerage?.brokerAmount ?? ""}",
                ),
                enable: false,
                viewOnly: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
