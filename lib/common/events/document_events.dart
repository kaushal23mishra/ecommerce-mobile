import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/document/view_model/document_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin DocumentEvents on UiComponentWidget {
  Future getDocuments({GetDocumentsRequest? request}) async {
    showLoader();
    final result = await eventRef
        .read(documentViewModelProvider.notifier)
        .getDocuments(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        onDocumentsFetched(data?.data?.data ?? []);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future sendDocuments({SendDocumentsRequest? request}) async {
    showLoader();
    final result = await eventRef
        .read(documentViewModelProvider.notifier)
        .sendDocuments(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onDocumentsSend();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onDocumentsFetched(List<Document> documents) {}

  void onDocumentsSend() {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
