import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_no_data_widget.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/bottom_bar_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/leads_shimmer.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/share/presentation/select_leads/action_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'SelectLeadsRoute')
class SelectLeadsScreen extends SalesdocketConsumerStatefulWidget {
  const SelectLeadsScreen({super.key});

  @override
  SalesdocketConsumerState<SelectLeadsScreen> createState() =>
      _SelectLeadsState();
}

class _SelectLeadsState extends SalesdocketConsumerState<SelectLeadsScreen>
    with LeadEvents {
  VoidCallback? _focusListener;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _focusListener = () {
        if (FocusScope.of(context).hasFocus) {
          setupStatusBar();
          _fetchLeads();
        }
      };
      FocusScope.of(context).addListener(_focusListener!);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_focusListener != null) {
      FocusScope.of(context).removeListener(_focusListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLeads = ref.watch(selectedLeadsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appColors.grayLight,
        appBar: SalesDocketAppBarWidget(
          title: _appbarTitleWidget,
          onHomeClicked: () => onHomeClicked(),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _fetchLeads();
          },
          child: Column(
            children: [
              const BottomBarWidget(),
              verticalSpacing(1.h),
              Expanded(child: _buildList),
              if (selectedLeads.isNotEmpty) const ActionWidget(),
            ],
          ),
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
        final responseAsync = ref.watch(leadsProvider(page: page));

        return responseAsync.when(
          error: (err, stack) {
            return Center(child: Text('Error: $err'));
          },
          loading: () => const LeadShimmer(),
          data: (res) {
            return res.when(
              success: (apiRes) {
                final leads = apiRes?.data?.data ?? [];
                if (leads.isEmpty && index == 0) {
                  return SalesdocketNoDataWidget(
                    text: LocaleKeys.noLeadFound.tr(),
                  );
                }
                if (indexInPage >= leads.length) {
                  return null;
                }
                final lead = leads[indexInPage];
                final selectedLeads = ref.watch(selectedLeadsProvider);
                final isSelected = selectedLeads.any(
                  (selectedLead) => selectedLead.id == lead.id,
                );

                return LeadItemWidget(
                  lead: lead,
                  isSelected: isSelected,
                  onLeadClicked: () {
                    final newLeads = selectedLeads.toList();
                    final leadId = lead.id;
                    if (leadId == null) return;

                    if (isSelected) {
                      newLeads.remove(lead);
                    } else {
                      newLeads.add(lead);
                    }
                    ref
                        .read(selectedLeadsProvider.notifier)
                        .update((state) => state = newLeads);
                  },
                  hasActions: false,
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

  Widget get _appbarTitleWidget {
    final countData = ref.watch(leadListCountProvider);

    return Column(
      children: [
        Text(
          "Select Leads",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: appColors.textPrimary),
        ),
        verticalSpacing(0.5.h),
        Text(
          "$countData ${LocaleKeys.leads.tr()}",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: appColors.textPrimary),
        ),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [selectedLeadsProvider];
    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  Future _fetchLeads({int page = 1}) async {
    ref.invalidate(leadsProvider);
    ref.read(leadsProvider(page: page));
  }

  @override
  void onLeadsDownloaded() {
    showSnackBar(LocaleKeys.exportSuccessful.tr(), type: SnackBarType.success);
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }
}
