import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class VisitByWidget extends ConsumerStatefulWidget {
  const VisitByWidget({super.key});

  @override
  ConsumerState<VisitByWidget> createState() => _MetWhomWidgetState();
}

class _MetWhomWidgetState extends ConsumerState<VisitByWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lead = ref.watch(followupLeadRequestProvider);
    _controller = TextEditingController(text: lead!.fullName);

    final leadHistory = ref.watch(followupLeadHistoryProvider);
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.toWhom);

    return SalesDocketInputWidget(
      controller: _controller,
      label: "Visit by?",
      hint: "Enter Visit by?",
      onChanged: (value) {
        final whomValue =
            value.trim().isNotEmpty
                ? value.trim()
                : (leadHistory.isNotEmpty ? leadHistory.first.whom : "");

        ref
            .read(followupRequestProvider.notifier)
            .update((state) => state?.copyWith(toWhom: whomValue));

        if (whomValue!.isNotEmpty) {
          ref
              .read(createFollowUpFormErrorsProvider.notifier)
              .remove(CreateFollowUpFormFields.toWhom);
        }
      },
      errorMsg: error?.message,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
