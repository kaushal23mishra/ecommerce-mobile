import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_dialog_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectActionWidget extends SalesdocketConsumerStatefulWidget {
  const ProspectActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProspectActionState();
}

class _ProspectActionState
    extends SalesdocketConsumerState<ProspectActionWidget>
    with ProductEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketActionWidget(
      onNegativeClicked: canEdit ? () {
        _submitRequest();
      } : null,
      onPositiveClicked: () {
        _isNextClicked = true;
        if (canEdit) {
          _submitRequest();
        } else {
          _moveToNextStep();
        }
      },
    );
  }

  void _submitRequest() {
    final isInEditMode = ref.read(editOfferSummaryProvider);
    if (!isInEditMode) {
      _moveToNextStep();
      return;
    }

    final lead = ref.read(prospectLeadRequestProvider);
    if (lead == null) return;

    final newOffers = ref.read(newOfferPricesProvider);
    final quotationRequest = lead.createQuotationRequest(
      newOffers: newOffers,
      quotationType: "registration",
    );
    createQuotation(request: quotationRequest);
  }

  void _moveToNextStep() {
    if (_isNextClicked) {
      ref.invalidate(prospectLeadRequestProvider);
      final prevStep = ref.read(selectedProspectSheetStepProvider);
      ref
          .read(selectedProspectSheetStepProvider.notifier)
          .update((state) => state = prevStep + 1);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _showQuotationSummaryDialog() {
    final lead = ref.read(prospectLeadRequestProvider);
    final quotation = ref.read(quotationProvider);
    showSalesdocketDialog<bool>(
      context: context,
      builder:
          (context) => SalesdocketOfferSummaryDialogWidget(
            quotation: quotation,
            lead: lead,
          ),
    ).then((confirmed) {
      if (confirmed == true) {
        _moveToNextStep();
      } else {
        _isNextClicked = false;
      }
    });
  }

  @override
  void onQuotationCreated(Quotation? quotation) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final newOffers = ref.read(newOfferPricesProvider);
      ref
          .read(quotationProvider.notifier)
          .update((state) => quotation?.modifiedGroups(newOffers));
      ref
          .read(editOfferSummaryProvider.notifier)
          .update((state) => false);
      _showQuotationSummaryDialog();
    });
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
