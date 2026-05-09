import 'package:salesdocket_mobile/common/constants/constant.dart';

class SortOrder extends Constant<String> {
  final String label;

  const SortOrder(super.val, {required this.label});

  static const asc = SortOrder('asc', label: "Ascending");
  static const desc = SortOrder('desc', label: "Descending");
}

List<SortOrder> get sortOrders => [SortOrder.asc, SortOrder.desc].toList();

List<String> get sortOrderLabels =>
    sortOrders.map((order) => order.label).toList();
