import 'package:salesdocket_mobile/common/constants/constant.dart';

class SearchBy extends Constant<String> {
  const SearchBy(super.value);

  static const mobile = SearchBy('Mobile');
  static const name = SearchBy('Name');
}

List<SearchBy> get searchByList => [SearchBy.mobile, SearchBy.name];
