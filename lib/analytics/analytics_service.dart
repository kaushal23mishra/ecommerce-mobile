import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class AnalyticsService {
  final Mixpanel mixpanel;

  AnalyticsService({required this.mixpanel});

  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    mixpanel.track(eventName, properties: properties);
  }

  void identifyUser({required String distinctId}) {
    mixpanel.identify(distinctId);
  }
}
