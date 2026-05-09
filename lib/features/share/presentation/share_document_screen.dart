import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/document_events.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/share/presentation/action_widget.dart';
import 'package:salesdocket_mobile/features/share/presentation/document_list_widget.dart';
import 'package:salesdocket_mobile/features/share/presentation/documents_shimmer.dart';
import 'package:salesdocket_mobile/features/share/view_model/share_document_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "ShareDocumentRoute")
class ShareDocumentScreen extends SalesdocketConsumerStatefulWidget {
  const ShareDocumentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareDocumentState();
}

class _ShareDocumentState extends SalesdocketConsumerState<ShareDocumentScreen>
    with DocumentEvents {
  late List<bool> switchStates;
  Timer? debounce;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: "Share Documents",
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              verticalSpacing(2.h),
              SalesDocketInputWidget(
                label: LocaleKeys.lblSearch.tr(),
                onChanged: _onSearchChanged,
              ),
              verticalSpacing(2.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {},
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _documentsWidget,
                        verticalSpacing(4.w),
                        const ActionWidget(),
                        verticalSpacing(4.w),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _documentsWidget {
    final isLoading = ref.watch(loadingStateProvider);

    return isLoading ? const DocumentsShimmer() : const DocumentListWidget();
  }

  void _onSearchChanged(String value) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      final documents = ref.read(shareDocumentsProvider);
      final filteredDocuments =
          value.trim().isEmpty
              ? documents
              : documents
                  .where(
                    (document) =>
                        document.documentName?.toLowerCase().contains(
                          value.toLowerCase(),
                        ) ==
                        true,
                  )
                  .toList();
      ref
          .read(shareFilteredDocumentsProvider.notifier)
          .update((state) => state = filteredDocuments);
    });
  }

  void _invalidateProviders() {
    final providers = [
      shareDocumentsProvider,
      selectedShareDocumentsProvider,
      shareFilteredDocumentsProvider,
      sendDocumentTypeProvider,
    ];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    getDocuments();
  }

  @override
  void onDocumentsFetched(List<Document> documents) {
    ref
        .read(shareDocumentsProvider.notifier)
        .update((state) => state = documents);
    ref
        .read(shareFilteredDocumentsProvider.notifier)
        .update((state) => state = documents);
  }

  @override
  WidgetRef get eventRef => ref;
}
