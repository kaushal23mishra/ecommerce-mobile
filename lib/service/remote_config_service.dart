import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:loggy/loggy.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static bool isInitialized = false;

  // Cached values — populated once during initialize()
  static String baseUrl = '';
  static bool maintenanceMode = false;
  static String maintenanceMessage = '';
  static String forceUpdateVersion = '';

  static const Map<String, dynamic> _defaults = {
    RemoteConfigKeys.baseUrl: '',
    RemoteConfigKeys.forceUpdateVersion: '',
    RemoteConfigKeys.maintenanceMode: false,
    RemoteConfigKeys.maintenanceMessage: '',
  };

  static Future<void> initialize() async {
    try {
      if (isInitialized) return;

      Loggy('RemoteConfigService').info('Initializing...');

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await _remoteConfig.setDefaults(_defaults);

      await _remoteConfig.fetchAndActivate();

      // Cache all values once — no repeated Firebase calls after this
      baseUrl = _remoteConfig.getString(RemoteConfigKeys.baseUrl);
      maintenanceMode = _remoteConfig.getBool(RemoteConfigKeys.maintenanceMode);
      maintenanceMessage = _remoteConfig.getString(RemoteConfigKeys.maintenanceMessage);
      forceUpdateVersion = _remoteConfig.getString(RemoteConfigKeys.forceUpdateVersion);

      isInitialized = true;
      Loggy('RemoteConfigService').info('Remote config initialized — baseUrl: $baseUrl');
    } catch (e, st) {
      Loggy(
        'RemoteConfigService',
      ).error('Failed to initialize remote config: $e', e, st);
    }
  }
}

abstract class RemoteConfigKeys {
  static const String baseUrl = 'base_url';
  static const String forceUpdateVersion = 'force_update_version';
  static const String maintenanceMode = 'maintenance_mode';
  static const String maintenanceMessage = 'maintenance_message';
}
