import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadItemHeaderWidget extends SalesdocketConsumerWidget {
  final Lead lead;

  const LeadItemHeaderWidget({super.key, required this.lead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = lead.stateValue ?? "";
    final profile = ref.watch(profileProvider);

    return Container(
      decoration: BoxDecoration(
        color: appColors.active,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2.w),
          topRight: Radius.circular(2.w),
        ),
        border: Border(
          bottom: BorderSide(color: appColors.border, width: 0.3.w),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (status.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.w)),
                color: lead.stateColor ?? appColors.grayMedium,
              ),
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: appColors.textSecondary,
                ),
              ),
            ),
          if (lead.isItCCLead)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
              child: Text(
                'CC',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: appColors.textSecondary,
                ),
              ),
            ),
          horizontalSpacing(2.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 0.5.w),
              child: Text(
                lead.listCardDisplayName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: appColors.secondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            (profile?.maskMobile ?? false)
                ? lead.listCardDisplayMobile.maskedPhoneNumber
                : lead.listCardDisplayMobile,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: appColors.secondary),
          ),
          horizontalSpacing(1.w),
          if ((lead.duplicateLeadInOutlet ?? 0) > 0)
            GestureDetector(
              onTap: () => _onInfoClicked(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                child: Icon(Icons.info, color: appColors.secondary, size: 5.w),
              ),
            ),
          horizontalSpacing(1.w),
        ],
      ),
    );
  }

  void _onInfoClicked() {}
}
