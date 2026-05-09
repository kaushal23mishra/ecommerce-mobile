import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DetailsCardWidget extends SalesdocketConsumerWidget {
  const DetailsCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(createdLeadProvider);

    return Container(
      padding: EdgeInsets.only(top: 3.w, bottom: 2.w, left: 3.w, right: 3.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Column(
        spacing: 3.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 3.w,
            children: [
              _textContainer(
                child: Text(
                  lead?.fullName ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.primaryLight,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              _textContainer(
                child: Text(
                  "${lead?.id ?? ""}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.primaryLight,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              _textContainer(
                child: Text(
                  lead?.leadSource ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.primaryLight,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: appColors.secondary,
              borderRadius: BorderRadius.circular(1.w),
              border: Border.all(color: appColors.border, width: 0.3.w),
            ),
            child: Text(
              lead?.carName ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: appColors.primary,
                fontSize: 15.sp,
              ),
            ),
          ),
          _textContainer(
            child: Text(
              LocaleKeys.enquiryPendingRegistration.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: appColors.primaryLight,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textContainer({required Widget child, Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: color ?? appColors.primary,
        borderRadius: BorderRadius.circular(1.w),
      ),
      child: child,
    );
  }
}
