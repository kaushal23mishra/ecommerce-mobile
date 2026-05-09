import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/lead_source_type.dart';
import 'package:salesdocket_mobile/common/constants/lead_state.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/entity/check_list_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';

class LeadFiltersUtils {
  static List<CheckListItem<String>> get closedReasonsFilters => [
    CheckListItem(
      key: 'Customer postponed indefinitely',
      value: 'Customer postponed indefinitely',
    ),
    CheckListItem(
      key: 'Poor customer response',
      value: 'Poor customer response',
    ),
    CheckListItem(key: 'Already delivered', value: 'Already delivered'),
    CheckListItem(key: 'Duplicate entry', value: 'Duplicate entry'),
    CheckListItem(key: 'Already booked', value: 'Already booked'),
    CheckListItem(
      key: 'Unable to speak to Customer',
      value: 'Unable to speak to Customer',
    ),
    CheckListItem(key: 'Wrong number', value: 'Wrong number'),
    CheckListItem(
      key: 'Purchase second hand car',
      value: 'Purchase second hand car',
    ),
    CheckListItem(
      key: 'Chose to switch back to petrol vehicle',
      value: 'Chose to switch back to petrol vehicle',
    ),
    CheckListItem(
      key: 'Doubt in electric vehicle',
      value: 'Doubt in electric vehicle',
    ),
  ];

  static List<CheckListItem<String>> get lostReasonsFilters => [
    CheckListItem(key: 'Competitor', value: 'Competitor'),
    CheckListItem(key: 'Co-Dealer', value: 'Co-Dealer'),
  ];

  static List<CheckListItem<String>> get leadTypeFilters {
    return LeadState.values
        .map(
          (status) => CheckListItem(
            key: status.value.toLowerCase(),
            value: status.value.toCamelCase,
          ),
        )
        .toList();
  }

  static List<CheckListItem<String>> leadStatusFilters(LeadCounts? leadCounts) {
    return leadFiltersWorkflowStatusList
        .map(
          (status) => CheckListItem(
            key: status[1],
            value:
                "${status[1]} (${leadCounts?.count(status[1].toLowerCase()) ?? 0})",
          ),
        )
        .toList();
  }

  static List<CheckListItem<String>> get followupTypeFilters {
    return FollowUpPlanType.values
        .map(
          (plan) =>
              CheckListItem(key: plan.value.toLowerCase(), value: plan.value),
        )
        .toList();
  }

  static List<CheckListItem<String>> get emailFilters => [
    CheckListItem(key: 'email', value: 'Yes'),
  ];

  static List<CheckListItem<String>> get interestedInCompetitionFilters => [
    CheckListItem(key: '1', value: 'Yes'),
    CheckListItem(key: '0', value: 'No'),
  ];

  static List<CheckListItem<String>> get dmsIdFilters => [
    CheckListItem(key: 'Y', value: 'Yes'),
    CheckListItem(key: 'N', value: 'No'),
  ];

  static List<CheckListItem<String>> get exchangeFilters => [
    CheckListItem(key: 'yes', value: 'Yes'),
    CheckListItem(key: 'no', value: 'No'),
  ];

  static List<CheckListItem<String>> get testDriveFilters => [
    CheckListItem(key: 'yes', value: 'Yes'),
    CheckListItem(key: 'no', value: 'No'),
  ];

  static List<CheckListItem<String>> get homeVisitFilters => [
    CheckListItem(key: 'Y', value: 'Yes'),
  ];

  static List<CheckListItem<int>> userFilters(List<User> users) {
    return users
        .where((user) => user.id != null)
        .map((user) => CheckListItem(key: user.id ?? 0, value: user.fullName))
        .toList();
  }

  static List<CheckListItem<int>> modelsFilters(List<Product> models) {
    return models
        .where((model) => model.productId != null)
        .map(
          (model) => CheckListItem(
            key: model.productId ?? 0,
            value: model.productName ?? "",
          ),
        )
        .toList();
  }

  static List<CheckListItem<String>> get leadSourcesFilters {
    return leadSourcesList
        .map((source) => CheckListItem(key: source.value, value: source.value))
        .toList();
  }

  static List<CheckListItem<String>> get myLeadsFilters => [
    CheckListItem(key: 'yes', value: 'Yes'),
  ];
}
