import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectActionWidget extends SalesdocketConsumerStatefulWidget {
  const ProspectActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProspectActionState();
}

class _ProspectActionState
    extends SalesdocketConsumerState<ProspectActionWidget>
    with LeadEvents, NavigationEvents {
  bool _isNextClicked = false;

  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketActionWidget(
      onNegativeClicked: canEdit ? () {
        _validateFormAndSubmitRequest();
      } : null,
      onPositiveClicked: () {
        if (canEdit) {
          _isNextClicked = true;
          _validateFormAndSubmitRequest();
        } else {
          _isNextClicked = true;
          onLeadUpdated(null);
        }
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    final request = ref.read(prospectLeadRequestProvider);
    if (_isValidForm(request)) {
      final newTestDrive = ref.read(selectedTestDriveGivenProvider);
      createLeadHistory(
        leadId: request?.id,
        req: RequestUtils.createLeadHistoryRequest(newTestDrive: newTestDrive),
      );
    }
  }

  bool _isValidForm(Lead? request) {
    final newSelectedCars = ref.read(selectedCarsProvider);
    final newCarColor = ref.read(selectedCarColorProvider);
    final newTestDrive = ref.read(selectedTestDriveGivenProvider);
    final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
    final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
    final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
    final errors =
        request?.prospectBuyingDetailsValidationErrors(
          newCarDetails: newSelectedCars,
          newCarColor: newCarColor,
          newTestDrive: newTestDrive,
          newFirstTimeBuyer: newFirstTimeBuyer,
          newInterestedInComp: newInterestedInComp,
          newCustomerQuote: newCustomerQuote,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(prospectFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  @override
  void onLeadHistoryCreated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final lead = ref.read(prospectLeadRequestProvider);
      if (lead == null) return;

      final newSelectedCars = ref.read(selectedCarsProvider);
      final newCarColor = ref.read(selectedCarColorProvider);
      final newTestDrive = ref.read(selectedTestDriveGivenProvider);
      final newInterestedInComp = ref.read(selectedInterestedInCompProvider);
      final newFirstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
      final newCustomerQuote = ref.read(selectedCustomerQuoteProvider);
      final newLeadSource = ref.read(selectedLeadSourceProvider);
      final request = lead.prospectBuyingDetailsRequest(
        newSelectedCars: newSelectedCars,
        newCarColor: newCarColor,
        newTestDrive: newTestDrive,
        newInterestedInComp: newInterestedInComp,
        newFirstTimeBuyer: newFirstTimeBuyer,
        newCustomerQuote: newCustomerQuote,
        newLeadSource: newLeadSource,
      );
      updateLead(leadId: lead.id, lead: request);
    });
  }

  @override
  void onLeadUpdated(Lead? lead) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_isNextClicked) {
        final firstTimeBuyer = ref.read(selectedFirstTimeBuyerProvider);
        final step =
            (firstTimeBuyer?.isExistingVehicle == FirstTimeBuyerState.yes.value)
                ? 3
                : 2;
        ref.invalidate(prospectLeadRequestProvider);
        ref
            .read(selectedProspectSheetStepProvider.notifier)
            .update((state) => step);
      } else {
        leadActionBackToPrevScreen(context);
      }
    });
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
