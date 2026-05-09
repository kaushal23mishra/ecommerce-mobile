import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/salesdocket_locale.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LanguagePickerWidget extends SalesdocketConsumerWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 4.w,
      children: [
        Expanded(
          child: Text(
            DateTime.now().formatDateTime(format: "dd MMM, yyyy"),
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
        _languageSelectionWidget(context, ref),
      ],
    );
  }

  Widget _languageSelectionWidget(BuildContext context, WidgetRef ref) {
    final selectedLocale = context.locale;
    final supportedLocales = SalesdocketLocale.values;

    return Row(
      children:
          supportedLocales.map((locale) {
            final isSelected =
                locale.locale.languageCode == selectedLocale.languageCode;

            return GestureDetector(
              onTap: () {
                context.setLocale(locale.locale);
              },
              child:
                  isSelected
                      ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.w,
                          horizontal: 3.w,
                        ),
                        decoration: BoxDecoration(color: appColors.primary),
                        child: Text(
                          locale.value,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: appColors.secondary),
                        ),
                      )
                      : Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.6.w,
                          horizontal: 2.6.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: appColors.primary,
                            width: 0.4.w,
                          ),
                        ),
                        child: Text(
                          locale.value,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: appColors.textDisabled),
                        ),
                      ),
            );
          }).toList(),
    );
  }
}
