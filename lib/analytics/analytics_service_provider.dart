import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_mobile/analytics/analytics_service.dart';
import 'package:salesdocket_mobile/analytics/mixpanel_provider.dart';

part 'analytics_service_provider.g.dart';

@riverpod
AnalyticsService analyticsService(AnalyticsServiceRef ref) {
  final mixpanel = ref.watch(mixpanelProvider);
  return AnalyticsService(mixpanel: mixpanel);
}
