import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_item_action.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';

class LeadListItem {
  final GetLeadRequest defaultRequest;
  final String title;
  final List<MenuItem> filterItems;
  final List<LeadListItemAction> actions;
  final List<LeadListItemMenuAction> menuActions;

  const LeadListItem({
    required this.defaultRequest,
    required this.title,
    this.filterItems = const [],
    this.actions = const [],
    this.menuActions = const [],
  });
}
