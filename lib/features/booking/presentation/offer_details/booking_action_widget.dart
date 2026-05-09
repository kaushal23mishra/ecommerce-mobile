import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_offer_summary_dialog_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BookingActionWidget extends SalesdocketConsumerStatefulWidget {
  const BookingActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingActionState();
}

class _BookingActionState extends SalesdocketConsumerState<BookingActionWidget>
    with ProductEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditBookingProvider);
    final lead = ref.watch(bookingLeadRequestProvider);
    final workflow = lead?.workflow;
    
    // If not editable, show only Next button
    if (!canEdit) {
      return SalesdocketActionWidget(
        onPositiveClicked: () {
          _isNextClicked = true;
          _moveToNextStep();
        },
        positiveText: LocaleKeys.lblNext.tr(),
      );
    }

    return SalesdocketActionWidget(
      onNegativeClicked: () {
        _submitRequest();
      },
      onPositiveClicked: () {
        _isNextClicked = true;
        _submitRequest();
      },
    );
  }

  void _submitRequest() {
    final lead = ref.read(bookingLeadRequestProvider);
    if (lead == null) return;

    final newOffers = ref.read(newOfferPricesProvider);
    final quotation = ref.read(quotationProvider);
    final quotationRequest = lead.createQuotationRequest(
      newOffers: newOffers,
      quotation: quotation,
      quotationType: "booking",
    );
    createQuotation(request: quotationRequest);
  }

  void _moveToNextStep() {
    if (_isNextClicked) {
      ref.invalidate(bookingLeadRequestProvider);
      ref
          .read(selectedBookingStepProvider.notifier)
          .update((state) => state = state + 1);
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _showQuotationSummaryDialog() {
    final lead = ref.read(bookingLeadRequestProvider);
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
    final newOffers = ref.read(newOfferPricesProvider);
    ref
        .read(quotationProvider.notifier)
        .update((state) => state = quotation?.modifiedGroups(newOffers));
    ref
        .read(editOfferSummaryProvider.notifier)
        .update((state) => state = false);
    _showQuotationSummaryDialog();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
