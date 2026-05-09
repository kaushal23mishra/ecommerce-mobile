import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_lead_source_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
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
    var selectedSource = ref.watch(selectedLeadSourceProvider);
    final errors = ref.watch(prospectFormErrorsProvider);

    selectedSource = selectedSource?.copyWith(
      sourceErr: errors.get(LeadFormFields.leadSource)?.message,
      informationErr: errors.get(LeadFormFields.sourceOfLead)?.message,
      otherReasonErr: errors.get(LeadFormFields.othersReason)?.message,
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
        .read(selectedLeadSourceProvider.notifier)
        .update(
          (state) =>
              state = state?.copyWith(
                source: selected,
                information: null,
                otherReason: null,
                referralName: null,
                referralNumber: null,
              ),
        );
    ref
        .read(prospectFormErrorsProvider.notifier)
        .remove(LeadFormFields.leadSource);
  }

  void _onInformationChanged(selected) {
    ref
        .read(selectedLeadSourceProvider.notifier)
        .update(
          (state) =>
              state = state?.copyWith(information: selected, otherReason: null),
        );
    ref
        .read(prospectFormErrorsProvider.notifier)
        .remove(LeadFormFields.sourceOfLead);
  }

  void _onOtherReasonChanged(value) {
    ref
        .read(selectedLeadSourceProvider.notifier)
        .update(
          (state) => state = state?.copyWith(
            otherReason: value.trim().isNotEmpty ? value.trim() : null,
          ),
        );
    ref
        .read(prospectFormErrorsProvider.notifier)
        .remove(LeadFormFields.othersReason);
  }

  void _onReferralNameChanged(String? value) {
    ref
        .read(selectedLeadSourceProvider.notifier)
        .update((state) => state = state?.copyWith(referralName: value));
  }

  void _onReferralNumberChanged(String? value) {
    ref
        .read(selectedLeadSourceProvider.notifier)
        .update((state) => state = state?.copyWith(referralNumber: value));
  }
}
