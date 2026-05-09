import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/locality_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectActionWidget extends SalesdocketConsumerStatefulWidget {
  const ProspectActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProspectActionState();
}

class _ProspectActionState
    extends SalesdocketConsumerState<ProspectActionWidget>
    with LocalityEvents, LeadEvents, NavigationEvents {
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
    final newLocality = ref.read(localityProvider);
    final newAddress = ref.read(addressProvider);
    if (_isValidForm(request)) {
      setLeadAddress(localityId: newLocality?.id, address: newAddress);
    }
  }

  bool _isValidForm(Lead? request) {
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final newLocality = ref.read(localityProvider);
    final newAddress = ref.read(addressProvider);
    final errors =
        request?.prospectPersonalDetailsValidationErrors(
          newContactDetails: newContactDetails,
          newLocality: newLocality,
          newAddress: newAddress,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(prospectFormErrorsProvider.notifier).addAll(errors);
      ref.read(isProspectFormInEditMode.notifier).update((state) => state = true);
    }

    return errors.isEmpty;
  }

  @override
  void onAddressCreated(CreateAddressResponse? data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final lead = ref.read(prospectLeadRequestProvider);
      if (lead == null) return;

      final newContactDetails = ref.read(contactDetailsProvider) ?? [];
      final newLocality = ref.read(localityProvider);
      final newAddress = ref.read(addressProvider);
      final request = lead
          .prospectPersonalDetailsRequest(newContactDetails: newContactDetails)
          .copyWith(
            address: newAddress,
            addressId: data?.addressId,
            localityId: newLocality?.id,
            locality: newLocality,
          );
      updateLead(leadId: lead.id, lead: request);
    });
  }

  @override
  void onLeadUpdated(Lead? lead) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_isNextClicked) {
        ref.invalidate(prospectLeadRequestProvider);
        ref
            .read(selectedProspectSheetStepProvider.notifier)
            .update((state) => state = state + 1);
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
