import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_state.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadStatusWidget extends SalesdocketConsumerWidget {
  const LeadStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(prospectLeadRequestProvider);
    final error = ref.watch(prospectFormErrorsProvider).get(LeadFormFields.leadStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.lblWhatAccordingToYouIsTheLeadStatus.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(2.h),
        Row(
          children:
              _items.map((item) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Future.microtask(() {
                        ref.read(prospectLeadRequestProvider.notifier).update(
                          (state) => state?.copyWith(leadState: item.title),
                        );
                        ref
                            .read(prospectFormErrorsProvider.notifier)
                            .remove(LeadFormFields.leadStatus);
                      });
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SalesDocketImageWidget(
                              imagePath: item.icon ?? "",
                              width: 18.w,
                            ),
                            if (lead?.leadState == item.title)
                              Positioned(
                                right: 0.25.w,
                                child: Icon(
                                  Icons.check_circle,
                                  color: appColors.success,
                                  size: 6.w,
                                ),
                              ),
                          ],
                        ),
                        verticalSpacing(0.5.h),
                        Text(item.title?.toCamelCase ?? ""),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
        if (error != null) ...[
          verticalSpacing(1.h),
          Text(
            error.message.toString(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: appColors.error),
          ),
        ],
      ],
    );
  }

  List<MenuItem> get _items => [
    MenuItem(title: LeadState.hot.value, icon: Assets.images.smileyHappy.path),
    MenuItem(title: LeadState.warm.value, icon: Assets.images.smileyBlank.path),
    MenuItem(title: LeadState.cold.value, icon: Assets.images.smileySad.path),
  ];
}
