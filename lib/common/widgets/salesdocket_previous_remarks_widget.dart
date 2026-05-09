import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketPreviousRemarksWidget extends SalesdocketStatelessWidget {
  final List<Quotation> remarks;

  const SalesdocketPreviousRemarksWidget({
    super.key,
    required this.remarks,
  });

  @override
  Widget build(BuildContext context) {
    if (remarks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(2.h),
        Text(
          LocaleKeys.previousRemarks.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(color: appColors.primary, width: 0.3.w),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: remarks.length,
            itemBuilder: (context, index) {
              final item = remarks[index];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.25.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.remark ?? "",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: appColors.textDisabled),
                      ),
                    ),
                    Text(
                      item.createdAt?.formatDateTime() ?? "",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: appColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        verticalSpacing(1.h),
      ],
    );
  }
}
