import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/features/transfer_lead/presentation/action_widget.dart';
import 'package:salesdocket_mobile/features/transfer_lead/presentation/transfer_lead_plan_followup_widget.dart';
import 'package:salesdocket_mobile/features/transfer_lead/view_model/transfer_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import '../../../common/providers/loading_state_provider.dart';
import '../../../common/widgets/salesdocket_loading_overlay.dart';
import '../../../common/widgets/salesdocket_no_data_widget.dart';
import '../../../common/widgets/salesdocket_user_item.dart';
import '../../../configs/app_configs.dart';
import '../../lead/presentation/lead_list/leads_shimmer.dart';

@RoutePage(name: "TransferLeadRoute")
class TransferLeadScreen extends SalesdocketConsumerStatefulWidget {
  const TransferLeadScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransferLeadState();
}

class _TransferLeadState extends SalesdocketConsumerState<TransferLeadScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);
    final transferringLeads = ref.watch(transferringLeadsProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText:
              transferringLeads.isNotEmpty
                  ? "Transfer Leads"
                  : LocaleKeys.lblTransferLead.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),

        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  verticalSpacing(2.h),
                  const TransferLeadPlanFollowupWidget(),
                  verticalSpacing(3.h),
                  Expanded(child: _buildList),
                  verticalSpacing(2.h),
                  const ActionWidget(),
                ],
              ),
            ),
            SalesdocketLoadingOverlay(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  Widget get _buildList {
    final pageSize = AppConfigs.pageSize;

    return ListView.builder(
      itemBuilder: (context, index) {
        final page = index ~/ pageSize + 1;
        final indexInPage = index % pageSize;
        final responseAsync = ref.watch(getUsers3Provider(page: page));
        return responseAsync.when(
          error: (err, stack) {
            return Center(child: Text('Error: $err'));
          },
          loading: () => const ListShimmer(),
          data: (res) {
            return res.when(
              success: (apiRes) {
                final leads = apiRes?.data ?? [];
                if (leads.isEmpty && index == 0) {
                  return SalesdocketNoDataWidget(
                    text: LocaleKeys.noLeadFound.tr(),
                  );
                }
                if (indexInPage >= leads.length) {
                  return null;
                }
                final user = leads[indexInPage];

                final selectedUserId = ref.watch(
                  transferLeadFollowupRequestProvider.select(
                    (lead) => lead?.actorId,
                  ),
                );
                final isSelected = user.id == selectedUserId;

                return Column(
                  children: [
                    SalesdocketUserItem(
                      user: user,
                      isSelected: isSelected,
                      onClicked: () {
                        ref
                            .read(transferLeadFollowupRequestProvider.notifier)
                            .update(
                              (state) =>
                                  state = state?.copyWith(actorId: user.id),
                            );
                      },
                    ),
                    Divider(),
                  ],
                );
              },
              failure: (error) {
                return Center(child: Text('Error: $error'));
              },
            );
          },
        );
      },
    );
  }

  void _fetchData() {
    ref.invalidate(getUsers3Provider);
    ref.read(getUsers3Provider(page: 1));
  }

  void _invalidateProviders() {
    final providers = [transferLeadUsersProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [transferLeadFormErrorsProvider];

    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  @override
  void onUsersFetched(List<User> users) {
    ref
        .read(transferLeadUsersProvider.notifier)
        .update((state) => state = users);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
