import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin SchemeEvents on UiComponentWidget {
  Future getSchemes({int? productId, GetSchemesRequest? req}) async {
    if (productId == null) {
      showSnackBar("Get Schemes: product id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(schemesViewModelProvider.notifier)
        .getSchemes(productId: productId, req: req);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onSchemesFetched(data?.data ?? []);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onSchemesFetched(List<Scheme>? schemes) {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
