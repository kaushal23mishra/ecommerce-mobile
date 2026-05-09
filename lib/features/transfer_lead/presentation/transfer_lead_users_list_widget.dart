import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_user_item.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_user_selection_list_widget.dart';
import 'package:salesdocket_mobile/features/transfer_lead/view_model/transfer_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class TransferLeadUsersListWidget extends SalesdocketConsumerStatefulWidget {
  const TransferLeadUsersListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransferLeadUsersListState();
}

class _TransferLeadUsersListState
    extends SalesdocketConsumerState<TransferLeadUsersListWidget> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);
    final users = ref.watch(transferLeadUsersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.chooseSalesConsultant.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        SalesdocketUserSelectionListWidget(
          users: users,
          isLoading: isLoading,
          item: (user) {
            final selectedUserId = ref.watch(
              transferLeadFollowupRequestProvider.select(
                (lead) => lead?.actorId,
              ),
            );
            final isSelected = user.id == selectedUserId;

            return SalesdocketUserItem(
              user: user,
              isSelected: isSelected,
              onClicked: () {
                ref
                    .read(transferLeadFollowupRequestProvider.notifier)
                    .update(
                      (state) => state = state?.copyWith(actorId: user.id),
                    );
              },
            );
          },
        ),
      ],
    );
  }
}
