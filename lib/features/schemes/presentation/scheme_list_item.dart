import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SchemeListItem extends SalesdocketConsumerWidget {
  final Scheme scheme;
  final VoidCallback? onRemoved;
  const SchemeListItem({super.key, required this.scheme, this.onRemoved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSchemes = ref.watch(selectedSchemesProvider).toList();
    final isSelected = selectedSchemes.any((s) => s.id == scheme.id);

    return Column(
      children: [
        Row(
          children: [
            horizontalSpacing(2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme.schemeName?.sentenceToCamelCase ?? "N/A",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  _subheaderWidget(context, ref),
                ],
              ),
            ),
            SalesdocketSwitchWidget(
              value: isSelected,
              label: "${scheme.schemeMrp ?? ""}",
              onChanged: (value) => _onSwitchChanged(value, ref),
            ),
          ],
        ),
      ],
    );
  }

  void _onSwitchChanged(bool value, WidgetRef ref) {
    final selectedSchemes = ref.read(selectedSchemesProvider).toList();

    if (value) {
      selectedSchemes.add(scheme);
    } else {
      selectedSchemes.removeWhere((s) => s.id == scheme.id);
      // Call the removal callback if provided
      onRemoved?.call();
    }

    ref.read(selectedSchemesProvider.notifier).state = selectedSchemes;
  }

  Widget _subheaderWidget(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(getSchemesLeadProvider);
    Widget? headerWidget;

    switch (scheme.schemeName) {
      case "CORPORATE DISCOUNT":
        headerWidget = Text(
          lead?.corporateName ?? "N/A",
          style: Theme.of(context).textTheme.bodySmall,
        );
        break;
      case "EXCHANGE":
        final exchangeProduct =
            "${lead?.exchangeProducts?.firstOrNull?.variant?.product?.brand?.name ?? ""} ${lead?.exchangeProducts?.firstOrNull?.variant?.product?.name ?? ""}"
                .trim();
        headerWidget = Text(
          exchangeProduct.isNotEmpty ? exchangeProduct : "N/A",
          style: Theme.of(context).textTheme.bodySmall,
        );
        break;
      default:
        break;
    }

    return headerWidget == null
        ? const SizedBox.shrink()
        : Padding(padding: EdgeInsets.only(top: 1.h), child: headerWidget);
  }
}
