import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DetailsWidget extends SalesdocketConsumerWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(reactivateLeadProvider);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: appColors.primaryLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.primary, width: 0.3.w),
      ),
      child: Column(
        children: [
          Row(
            spacing: 1.w,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  lead?.fullName ?? "",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: appColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    lead
                            ?.phoneNumbers
                            ?.firstOrNull
                            ?.phoneNumber
                            ?.maskedPhoneNumber ??
                        "",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: appColors.textPrimary,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 2.w),
                decoration: BoxDecoration(
                  color: appColors.error,
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.block, color: appColors.secondary, size: 3.w),
                    horizontalSpacing(1.w),
                    Text(
                      '${LocaleKeys.lead.tr()} ${lead?.workflow?.state?.toCamelCase ?? ""}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: appColors.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpacing(2.h),
          Row(
            spacing: 2.w,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  lead?.leadSource ?? "",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: appColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  lead?.carName ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
