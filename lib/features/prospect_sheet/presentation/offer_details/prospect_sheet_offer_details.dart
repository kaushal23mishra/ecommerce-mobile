import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/offer_details/details_card_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/offer_details/prospect_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/offer_details/summary_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectSheetOfferDetails extends SalesdocketConsumerStatefulWidget {
  const ProspectSheetOfferDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProspectSheetOfferDetailsState();
}

class _ProspectSheetOfferDetailsState
    extends SalesdocketConsumerState<ProspectSheetOfferDetails>
    with LeadEvents {
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
    final lead = ref.watch(prospectLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DetailsCardWidget(),
        verticalSpacing(2.h),
        if (canEdit) const SummaryWidget(),
      ],
      actionWidget: const ProspectActionWidget(),
    );
  }

  void _invalidateProviders() {
    final providers = [
      prospectLeadRequestProvider,
      editOfferSummaryProvider,
      quotationProvider,
      updatedBrokerProvider,
      selectedSchemesProvider,
      selectedAccessoriesProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [brokerFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    if (!mounted) return;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(prospectLeadRequestProvider.notifier)
          .update((state) => lead?.copyWith());
      final quotation = lead?.offerList.firstOrNull ?? const Quotation();
      ref
          .read(editOfferSummaryProvider.notifier)
          .update((state) => (quotation.quotationFields ?? []).isEmpty);
      ref.read(quotationProvider.notifier).update((state) => quotation);
      ref
          .read(selectedSchemesProvider.notifier)
          .update((state) => quotation.schemeList);
      ref
          .read(selectedAccessoriesProvider.notifier)
          .update((state) => quotation.accessoriesList);
      ref
          .read(updatedBrokerProvider.notifier)
          .update((state) => lead?.brokerages?.firstOrNull);
    });
  }

  void _fetchData() {
    final lead = ref.read(prevProspectLeadRequestProvider);
    fetchLead(leadId: lead?.id);
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (!mounted) return;
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    _initProviders(lead);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
