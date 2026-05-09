import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/approval_type.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/booking/booking_approval_form.dart';
import 'package:salesdocket_mobile/features/approvals/presentation/delivery/delivery_approval_form.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "ApprovalRoute")
class ApprovalsScreen extends SalesdocketConsumerStatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApprovalsScreenState();
}

class _ApprovalsScreenState extends SalesdocketConsumerState<ApprovalsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
      _invalidateProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final approvalType = ref.watch(approvalTypeProvider);
    final loading = ref.watch(loadingStateProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: "${approvalType?.value} ${LocaleKeys.approval.tr()}",
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            _approvalFormWidget,
            SalesdocketLoadingOverlay(isLoading: loading),
          ],
        ),
      ),
    );
  }

  Widget get _approvalFormWidget {
    final approvalType = ref.watch(approvalTypeProvider);
    switch (approvalType) {
      case ApprovalType.booking:
        return const BookingApprovalForm();
      case ApprovalType.delivery:
        return const DeliveryApprovalForm();
      default:
        return const SizedBox.shrink();
    }
  }

  void _invalidateProviders() {
    final providers = [
      moreDiscountApprovalReasonsProvider,
      discountApprovalUsersProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [discountApprovalFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }
}
