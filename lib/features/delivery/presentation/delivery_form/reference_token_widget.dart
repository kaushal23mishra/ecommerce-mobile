import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/contact_type.dart';
import '../../../../common/constants/follow_up_plan_type.dart';
import '../../../../common/constants/purchase_mode.dart';
import '../../../../common/constants/strings.dart';
import '../../../../routing/app_router.dart';
import '../../../lead/view_model/lead_view_model.dart';

class ReferenceTokenWidget extends SalesdocketConsumerWidget {
  final String leadId;
  final bool deactivated;

  const ReferenceTokenWidget({
    super.key,
    required this.leadId,
    this.deactivated = false,
  });

  Future<void> _handleSwitchChange(
    bool value,
    BuildContext context,
    WidgetRef ref,
  ) async {
    // First update delivery state
    ref
        .read(selectedDeliveryProvider.notifier)
        .update((state) => state?.copyWith(referenceTaken: value ? 1 : null));

    // Prepare data in background
    final request = await _prepareLeadRequest();

    // Schedule navigation for next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leadRequestProvider.notifier).update((state) => request);
      context.router.push(const CreateLeadRoute());
    });
  }

  Future<CreateLeadRequest> _prepareLeadRequest() async {
    return CreateLeadRequest(
      salutation: CommonString.salutations.first,
      contactDetails: [ContactDetails(type: ContactType.mobile.value)],
      isExchange: 0,
      purchaseMode: PurchaseMode.cash.value,
      sourceOfInformation: '',
      followUpPlan: FollowUpPlanType.call.value,
      dateOfEnquiry: DateTime.now().formatDateTime(),
      leadSource: PurchaseMode.referral.value,
      referenceLeadId: leadId,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDelivery = ref.watch(selectedDeliveryProvider);

    return SalesdocketSwitchWidget(
      deactivated: deactivated,
      value: selectedDelivery?.referenceTaken == 1,
      label: LocaleKeys.referenceTaken.tr(),
      onChanged: (value) => _handleSwitchChange(value, context, ref),
      hasSpace: true,
    );
  }
}
