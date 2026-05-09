import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PrevCommentsWidget extends SalesdocketConsumerWidget {
  const PrevCommentsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(prospectLeadHistoryProvider);
    final registrationCommentHistory =
        (history.whereOrNull(
                  (toFilter) => toFilter.responseType == 'registration_comment',
                ) ??
                [])
            .toList();

    return registrationCommentHistory.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.previousComments.tr(),
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
                  itemCount: registrationCommentHistory.length,
                  itemBuilder: (context, index) {
                    final item = registrationCommentHistory[index];

                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.leadHistoryResponse?.comment ?? "",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: appColors.textDisabled),
                          ),
                        ),
                        Text(
                          item.createdAt?.formatDateTime() ?? "",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: appColors.textDisabled),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }
}
