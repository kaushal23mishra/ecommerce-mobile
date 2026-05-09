import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/lead_source.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_lead_source_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SelectLeadSourceWidget extends SalesdocketConsumerStatefulWidget {
  const SelectLeadSourceWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectLeadSourceWidgetState();
}

class _SelectLeadSourceWidgetState
    extends SalesdocketConsumerState<SelectLeadSourceWidget> {
  @override
  Widget build(BuildContext context) {
    LeadSource? selectedSource;
    selectedSource = ref.watch(
      leadRequestProvider.select(
        (lead) => LeadSource(
          source: lead?.leadSource,
          information: lead?.sourceOfInformation,
          otherReason: lead?.otherSourceOfInformation,
        ),
      ),
    );
    selectedSource = ref.watch(
      createLeadFormErrorsProvider.select(
        (errors) => selectedSource?.copyWith(
          sourceErr: errors.get(LeadFormFields.leadSource)?.message,
          informationErr: errors.get(LeadFormFields.sourceOfLead)?.message,
          otherReasonErr: errors.get(LeadFormFields.othersReason)?.message,
        ),
      ),
    );

    return SalesdocketSelectLeadSourceWidget(
      selectedSource: selectedSource,
      onSourceChanged: _onSourceChanged,
      onInformationChanged: _onInformationChanged,
      onOtherReasonChanged: _onOtherReasonChanged,
      onReferralNameChanged: _onReferralNameChanged,
      onReferralNumberChanged: _onReferralNumberChanged,
    );
  }

  void _onSourceChanged(selected) {
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) =>
              lead = lead?.copyWith(
                leadSource: selected,
                sourceOfInformation: "",
                otherSourceOfInformation: null,
                referralName: null,
                referralNumber: null,
              ),
        );
    ref
        .read(createLeadFormErrorsProvider.notifier)
        .remove(LeadFormFields.leadSource);
  }

  void _onInformationChanged(selected) {
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) =>
              lead = lead?.copyWith(
                sourceOfInformation: selected,
                otherSourceOfInformation: null,
              ),
        );
    ref
        .read(createLeadFormErrorsProvider.notifier)
        .remove(LeadFormFields.sourceOfLead);
  }

  void _onOtherReasonChanged(value) {
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) => lead = lead?.copyWith(otherSourceOfInformation: value),
        );
    ref
        .read(createLeadFormErrorsProvider.notifier)
        .remove(LeadFormFields.othersReason);
  }

  void _onReferralNameChanged(String? value) {
    ref
        .read(leadRequestProvider.notifier)
        .update((lead) => lead = lead?.copyWith(referralName: value));
  }

  void _onReferralNumberChanged(String? value) {
    ref
        .read(leadRequestProvider.notifier)
        .update((lead) => lead = lead?.copyWith(referralNumber: value));
  }
}
