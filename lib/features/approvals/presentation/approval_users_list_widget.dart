import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/user_type.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/user_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_user_item.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_user_selection_list_widget.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ApprovalUsersListWidget extends SalesdocketConsumerStatefulWidget {
  const ApprovalUsersListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApprovalUserListState();
}

class _ApprovalUserListState
    extends SalesdocketConsumerState<ApprovalUsersListWidget>
    with UserEvents {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(profileProvider) != null) {
        _fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileProvider, (previous, next) {
      if (previous == null && next != null) {
        _fetchData();
      }
    });

    final user = ref.watch(profileProvider);
    final label = user?.shouldFetchAdmins == true
        ? LocaleKeys.selectAdmin.tr()
        : LocaleKeys.selectSalesManager.tr();
    final isLoading = ref.watch(loadingStateProvider);
    final users = ref.watch(discountApprovalUsersProvider);
    final error = ref
        .watch(discountApprovalFormErrorsProvider)
        .get(DiscountFormFields.sentTo)
        ?.message;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        SalesdocketUserSelectionListWidget(
          users: users,
          isLoading: isLoading,
          item: (user) {
            final selectedUserId = ref.watch(
              discountApprovalRequestProvider.select((state) => state?.sentTo),
            );
            final isSelected = user.id == selectedUserId;

            return SalesdocketUserItem(
              user: user,
              isSelected: isSelected,
              onClicked: () {
                ref
                    .read(discountApprovalRequestProvider.notifier)
                    .update(
                      (state) => state = state?.copyWith(sentTo: user.id),
                    );
                ref
                    .read(discountApprovalFormErrorsProvider.notifier)
                    .remove(DiscountFormFields.sentTo);
              },
            );
          },
        ),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: appColors.error),
            ),
          ),
      ],
    );
  }

  void _fetchData() {
    final user = ref.read(profileProvider);
    final userType = user?.shouldFetchAdmins == true
        ? UserType.admin.value
        : UserType.salesManager.value;

    fetchUsers(
      request: GetUsersRequest(
        type: userType,
        returnAll: "yes",
      ),
    );
  }

  @override
  void onUsersFetched(List<User> users) {
    ref
        .read(discountApprovalUsersProvider.notifier)
        .update((state) => state = users);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
