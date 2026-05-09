import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/widget.dart';

class DialNowWidget extends ConsumerWidget {
  final String? phoneNumber;
  final Function(String) makePhoneCall;
  final VoidCallback? onCallInitiated;

  const DialNowWidget({
    super.key,
    required this.phoneNumber,
    required this.makePhoneCall,
    this.onCallInitiated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callDuration = ref.watch(callDurationProvider);

    return Expanded(
      child: SalesDocketButtonWidget(
        onPressed: () async {
          if (phoneNumber == null || phoneNumber!.trim().isEmpty) {
            context.showSnackBar(
              "Phone number is not available",
              type: SnackBarType.error,
            );
            return;
          }

          // Reset states for new call
          ref.read(callDurationProvider.notifier).state = null;
          ref.read(callStatusProvider.notifier).state = null;
          ref.read(callInProgressProvider.notifier).state = true;

          try {
            makePhoneCall(phoneNumber!.trim());
            onCallInitiated?.call();
          } catch (e) {
            ref.read(callInProgressProvider.notifier).state = false;
            context.showSnackBar(
              "Failed to initiate call",
              type: SnackBarType.error,
            );
          }
        },
        text: callDuration != null ? "Redial" : "Dial Now",
      ),
    );
  }
}
