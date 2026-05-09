import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_edit_form_switch.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/address_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/contact_details_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/date_of_birth_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/details_card_widget.dart';

import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/name_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/profession_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/prospect_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/personal_details/type_of_customers_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectSheetPersonalDetails extends SalesdocketConsumerStatefulWidget {
  const ProspectSheetPersonalDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProspectSheetPersonalDetailsState();
}

class _ProspectSheetPersonalDetailsState
    extends SalesdocketConsumerState<ProspectSheetPersonalDetails>
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

    final isInEditMode = ref.watch(isProspectFormInEditMode);
    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DetailsCardWidget(),
        verticalSpacing(2.h),
        if (canEdit)
          SalesdocketEditFormSwitch(
            label: "Edit Personal Details",
            isInEditMode: isInEditMode,
            onChanged: (value) {
              ref
                  .read(isProspectFormInEditMode.notifier)
                  .update((state) => state = value);
            },
            form: _formWidget,
          ),
      ],
      actionWidget: const ProspectActionWidget(),
    );
  }

  Widget get _formWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(1.h),
        const NameWidget(),
        verticalSpacing(2.h),
        const ContactDetailsWidget(),
        verticalSpacing(2.h),
        const AddressWidget(),
        verticalSpacing(2.h),
        const TypeOfCustomersWidget(),
        verticalSpacing(2.h),
        const ProfessionWidget(),
        verticalSpacing(2.h),
        const DateOfBirthWidget(),
        verticalSpacing(2.h),

        verticalSpacing(1.h),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [
      selectedContactIndexProvider,
      contactDetailsProvider,
      citiesProvider,
      locationsProvider,
      addressProvider,
      localityProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [
      contactDetailsTextFieldControllerProvider,
      prospectFormErrorsProvider,
    ];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    ref
        .read(prospectLeadRequestProvider.notifier)
        .update((state) => state = lead?.copyWith());
    ref
        .read(contactDetailsProvider.notifier)
        .update((state) => state = lead?.contactDetails);
    ref
        .read(localityProvider.notifier)
        .update((state) => state = lead?.locality ?? const LeadLocality());
    ref
        .read(addressProvider.notifier)
        .update((state) => state = lead?.address ?? const LeadAddress());
  }

  void _fetchData() {
    final lead = ref.read(prevProspectLeadRequestProvider);
    fetchLead(leadId: lead?.id);
  }

  void _setupView() {
    if (!mounted) return;
    final lead = ref.read(prospectLeadRequestProvider);
    final newContactDetails = ref.read(contactDetailsProvider) ?? [];
    final newLocality = ref.read(localityProvider);
    final newAddress = ref.read(addressProvider);
    final errors =
        lead?.prospectPersonalDetailsValidationErrors(
          newContactDetails: newContactDetails,
          newLocality: newLocality,
          newAddress: newAddress,
        ) ??
        [];
    ref
        .read(isProspectFormInEditMode.notifier)
        .update((state) => errors.isNotEmpty);
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (!mounted) return;
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    _initProviders(lead);
    _setupView();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
