import 'package:salesdocket_mobile/common/constants/constant.dart';

class SortBy extends Constant<String> {
  const SortBy(super.value);

  static const date = SortBy('Date');
  static const name = SortBy('Name');
  static const followup = SortBy('Followup');
}

List<SortBy> get sortByList => [SortBy.name, SortBy.date, SortBy.followup];

class SortOrder extends Constant<String> {
  const SortOrder(super.value);

  static const ascending = SortOrder('Ascending');
  static const descending = SortOrder('Descending');
}

List<SortOrder> get sortOrderList => [SortOrder.ascending, SortOrder.descending];
