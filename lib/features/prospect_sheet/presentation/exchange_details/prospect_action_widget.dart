import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/booking_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class ProspectActionWidget extends SalesdocketConsumerStatefulWidget {
  const ProspectActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProspectActionState();
}

class _ProspectActionState
    extends SalesdocketConsumerState<ProspectActionWidget>
    with LeadEvents, ProductEvents, NavigationEvents {
  bool _isNextClicked = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    // Reset edit mode when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isMounted) {
        ref.read(isECEditModeProvider.notifier).state = false;
        _clearFormErrors();
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _clearFormErrors() {
    if (!mounted) return;

    try {
      final notifier = ref.read(prospectFormErrorsProvider.notifier);
      notifier.state = [];
    } catch (e) {
      // Ignore errors during disposal
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider);
    final lead = ref.watch(prospectLeadRequestProvider);
    final isECEditMode = ref.watch(isECEditModeProvider);

    // Check if lead is in EC status and user is evaluator
    final isEC = lead?.isEC ?? false;
    final showEditSave = user!.isEvaluator && isEC;

    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketActionWidget(
      isEvaluator: canEdit ? user.isEvaluator : false,
      evaluatorButtonText:
          showEditSave && canEdit
              ? (isECEditMode
                  ? LocaleKeys.lblSave.tr()
                  : LocaleKeys.lblEdit.tr())
              : null,
      onNegativeClicked: canEdit ? () {
        if (showEditSave) {
          _handleEditSave();
        } else {
          _validateFormAndSubmitRequest(isNext: false);
        }
      } : null,
      onPositiveClicked: () {
        if (canEdit) {
          _validateFormAndSubmitRequest(isNext: true);
        } else {
          _isNextClicked = true;
          _moveToNextStep();
        }
      },
    );
  }

  void _handleEditSave() {
    if (!mounted) return;

    final isECEditMode = ref.read(isECEditModeProvider);

    if (isECEditMode) {
      // Save mode - validate and submit changes
      _clearFormErrors();
      final isValid = _validateForm();
      if (isValid) {
        _submitRequest();
        // Toggle back to view mode only after successful save
        ref.read(isECEditModeProvider.notifier).state = false;
      }
    } else {
      // Edit mode - enable editing
      _clearFormErrors();
      ref.read(isECEditModeProvider.notifier).state = true;
    }
  }

  void _validateFormAndSubmitRequest({required bool isNext}) {
    if (!mounted) return;

    _isNextClicked = isNext;
    _clearFormErrors();

    final isValid = _validateForm();
    if (isValid) {
      _submitRequest();
    }
  }

  void _submitRequest() {
    if (!mounted) return;

    final lead = ref.read(prospectLeadRequestProvider);
    if (lead == null) return;

    final request = lead.prospectExchangeDetailsRequest();
    updateLead(leadId: lead.id, lead: request);
  }

  bool _validateForm() {
    if (!mounted) return false;

    final lead = ref.read(prospectLeadRequestProvider);
    if (lead == null) return false;

    return _isValidForm(lead);
  }

  bool _isValidForm(Lead? request) {
    if (!mounted) return false;

    final newFirstTimeBuyer = ref.read(selectedExchangeCarProvider);
    final newExchangeProduct = ref.read(selectedExchangeProductProvider);
    final user = ref.read(profileProvider);

    _clearFormErrors();

    final errors =
        request?.prospectExchangeDetailsValidationErrors(
          newExchangeProduct: newExchangeProduct,
          newFirstTimeBuyer: newFirstTimeBuyer,
          user: user,
        ) ??
        [];

    if (errors.isNotEmpty) {
      // Use WidgetsBinding to ensure context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showSnackBar(errors.firstErrorMessage);
          ref.read(prospectFormErrorsProvider.notifier).state = errors;
        }
      });
      return false;
    }

    return true;
  }

  void _uploadImages(ExchangeProduct? exchangeProduct) {
    if (!mounted) return;

    final exchangeImages = ref.read(exchangeImagesProvider);
    final images = BookingUtils.getExchangeImages(exchangeImages);
    if (images.isEmpty) return;

    uploadExchangeDocuments(
      exchangeId: exchangeProduct?.id,
      request: ExchangeProduct(
        leadId: exchangeProduct?.leadId,
        documents: images,
      ),
    );
  }

  void _moveToNextStep() {
    if (!mounted) return;

    if (_isNextClicked) {
      // Use postFrameCallback to ensure we're in a valid build context
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.invalidate(prospectLeadRequestProvider);
          final prevStep = ref.read(selectedProspectSheetStepProvider);
          ref.read(selectedProspectSheetStepProvider.notifier).state =
              prevStep + 1;
        }
      });
    } else {
      leadActionBackToPrevScreen(context);
    }
  }

  void _sendExchangeData(Lead? lead) {
    if (!mounted) return;

    final newFirstTimeBuyer = ref.read(selectedExchangeCarProvider);
    final newExchangeProduct = ref.read(selectedExchangeProductProvider);

    if (newExchangeProduct?.id != null) {
      final request = newExchangeProduct?.prospectUpdateExchangeDetailsRequest(
        lead: lead,
        newFirstTimeBuyer: newFirstTimeBuyer,
      );
      updateExchangeProduct(request: request);
    } else {
      final request = newExchangeProduct?.prospectCreateExchangeDetailsRequest(
        lead: lead,
        newFirstTimeBuyer: newFirstTimeBuyer,
      );
      createExchangeProduct(request: request);
    }
  }

  @override
  void onLeadUpdated(Lead? lead) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (lead?.isExchange == InterestedInExchangeState.no.value) {
        _moveToNextStep();
        return;
      }

      _sendExchangeData(lead);
    });
  }

  @override
  void onExchangeUpdated(ExchangeProduct? exchangeProduct) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _moveToNextStep();
      _uploadImages(exchangeProduct);
    });
  }

  @override
  void onExchangeCreated(ExchangeProduct? exchangeProduct) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _moveToNextStep();
      _uploadImages(exchangeProduct);
    });
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    // Don't use context directly, use the build context safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.showSnackBar(message, type: type);
      }
    });
  }

  @override
  WidgetRef get eventRef => ref;
}
