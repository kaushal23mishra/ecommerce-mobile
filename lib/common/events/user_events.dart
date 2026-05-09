import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/features/users/view_model/user_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin UserEvents on UiComponentWidget {
  Future fetchUsers({GetUsersRequest? request}) async {
    showLoader();
    final result = await eventRef
        .read(userViewModelProvider.notifier)
        .getUsers(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        final users = data?.data ?? [];
        onUsersFetched(users);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future fetchProfile() async {
    final result =
        await eventRef
            .read(profileViewModelProvider.notifier)
            .fetchProfileFromRemote();
    if (!isMounted) return;

    result.when(
      success: (data) {
        final user = data;
        onProfileFetched(user);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onUsersFetched(List<User> users) {}

  void onProfileFetched(User? user) {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
