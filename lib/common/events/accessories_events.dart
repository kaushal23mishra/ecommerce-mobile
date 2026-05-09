import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin AccessoriesEvents on UiComponentWidget {
  Future getAccessories({int? productId}) async {
    if (productId == null) {
      showSnackBar("Get Accessories: product id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(accessoriesViewModelProvider.notifier)
        .getAccessories(productId: productId);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onAccessoriesFetched(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onAccessoriesFetched(List<Accessory>? accessories) {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
