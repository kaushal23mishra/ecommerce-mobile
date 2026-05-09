import 'package:salesdocket_core/salesdocket_core.dart';

extension CityExtension on City {
  String get cityName {
    final address = city?.split(",") ?? [];
    return address.isNotEmpty ? address[0] : "";
  }

  String get stateName {
    final address = city?.split(",") ?? [];
    return address.length > 1 ? address[1] : "";
  }
}
