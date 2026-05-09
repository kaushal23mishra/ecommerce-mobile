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
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CancellationUsersListWidget extends SalesdocketConsumerStatefulWidget {
  const CancellationUsersListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CancellationUsersListState();
}

class _CancellationUsersListState
    extends SalesdocketConsumerState<CancellationUsersListWidget>
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

    final isLoading = ref.watch(loadingStateProvider);
    final users = ref.watch(cancelBookingUsersProvider);
    final error = ref
        .watch(cancelBookingFormErrorsProvider)
        .get(CancelBookingFormFields.sentTo)
        ?.message;

    final user = ref.watch(profileProvider);
    final label = (user?.shouldFetchAdmins == true || user?.isSalesManager == true)
        ? LocaleKeys.selectAdmin.tr()
        : LocaleKeys.selectSalesManager.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesdocketUserSelectionListWidget(
          label: label,
          isRequired: true,
          users: users,
          isLoading: isLoading,
          item: (user) {
            final selectedUserId = ref.watch(
              cancelBookingRequestProvider.select((state) => state?.sentTo),
            );
            final isSelected = user.id == selectedUserId;

            return SalesdocketUserItem(
              user: user,
              isSelected: isSelected,
              onClicked: () {
                ref.read(cancelBookingRequestProvider.notifier).update(
                      (state) => state = state?.copyWith(sentTo: user.id),
                    );
                ref
                    .read(cancelBookingFormErrorsProvider.notifier)
                    .remove(CancelBookingFormFields.sentTo);
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
    final userType = (user?.shouldFetchAdmins == true || user?.isSalesManager == true)
        ? UserType.admin.value
        : UserType.salesManager.value;

    fetchUsers(request: GetUsersRequest(type: userType, returnAll: "yes"));
  }

  @override
  void onUsersFetched(List<User> users) {
    ref
        .read(cancelBookingUsersProvider.notifier)
        .update((state) => state = users);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
