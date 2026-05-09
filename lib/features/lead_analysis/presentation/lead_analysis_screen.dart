import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage(name: "LeadAnalysisRoute")
class LeadAnalysisScreen extends SalesdocketConsumerStatefulWidget {
  const LeadAnalysisScreen({super.key});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeadAnalysisScreenState();
}

class _LeadAnalysisScreenState
    extends SalesdocketConsumerState<LeadAnalysisScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _setupWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.leadAnalysis.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }

  void _setupWebView() {
    final token = CacheManager.getString(keyToken);
    final url = "${AppConfigs.http}${AppConfigs.domain}/individual_kpi";
    String? lastUrl;

    logDebug('Initial KPI URL: $url');

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(
            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
          )
          ..setBackgroundColor(appColors.secondary)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                logDebug('Page started loading: $url');
              },
              onPageFinished: (String url) {
                logDebug('Page finished loading: $url');
              },
              onWebResourceError: (WebResourceError error) {
                logError(
                  'WebView resource error: ${error.description}, type: ${error.errorType}, url: ${error.url}',
                );
              },
              onNavigationRequest: (NavigationRequest request) {
                logDebug('Navigation request: ${request.url}');

                if (!request.url.startsWith("http")) {
                  return NavigationDecision.navigate;
                }

                // Break infinite loop: if we just manually loaded this URL, let it through
                if (request.url == lastUrl) {
                  logDebug('Allowing navigation (already handled): ${request.url}');
                  return NavigationDecision.navigate;
                }

                logDebug('Intercepting navigation to add headers: ${request.url}');
                lastUrl = request.url;
                _controller.loadRequest(
                  Uri.parse(request.url),
                  headers: {"Authorization": token},
                );
                return NavigationDecision.prevent;
              },
            ),
          )
          ..loadRequest(Uri.parse(url), headers: {"Authorization": token});

    lastUrl = url;
  }
}
