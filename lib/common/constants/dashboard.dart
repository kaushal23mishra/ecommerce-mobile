import 'package:salesdocket_mobile/common/constants/constant.dart';

class DashboardType extends Constant<String> {
  const DashboardType(super.value);

  static const lead = DashboardType('Lead');
  static const manager = DashboardType('Manager');

  static List<DashboardType> get values => [manager, lead];
}
