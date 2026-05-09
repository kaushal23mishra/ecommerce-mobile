import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/user_type.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/users/view_model/user_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_filters_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ScNamesWidget extends SalesdocketConsumerStatefulWidget {
  const ScNamesWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScNamesWidgetState();
}

class _ScNamesWidgetState extends SalesdocketConsumerState<ScNamesWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedAssignees = ref.watch(
      leadFilterRequestProvider.select((req) => req?.assignedTo),
    );
    final users = ref.watch(leadScUsersProviders);
    final filterItems = LeadFiltersUtils.userFilters(users);

    return CheckListWidget<int>(
      items: filterItems,
      selectedItems: selectedAssignees,
      onChanged: (selected) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    assignedTo: selected.isEmpty ? null : selected,
                    scType:
                        selected.isEmpty
                            ? null
                            : UserType.salesConsultant.value,
                  ),
            );
      },
    );
  }

  void _fetchUsers() {
    final leadState = ref.read(leadFilterRequestProvider)?.leadState;
    final request = GetUsersRequest(
      orderBy: "date",
      type: UserType.salesConsultant.value,
      leadState: leadState,
    );

    ref.read(userViewModelProvider.notifier).getUsers(request: request).then((
      result,
    ) {
      result.when(
        success: (data) {
          final users = data?.data ?? [];
          if (users.isNotEmpty) {
            ref
                .read(leadScUsersProviders.notifier)
                .update((state) => state = users);
          }
        },
        failure: (error) {
          context.showSnackBar(
            error.message ?? LocaleKeys.defaultErrorMessage.tr(),
            type: SnackBarType.error,
          );
        },
      );
    });
  }
}
