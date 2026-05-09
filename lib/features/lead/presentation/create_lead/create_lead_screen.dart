import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/address_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/contact_details_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/create_lead_action_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/create_lead_plan_follow_up_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/date_of_enquiry_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/exchange_finance_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/name_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/select_car_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/create_lead/select_lead_source_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'CreateLeadRoute')
class CreateLeadScreen extends SalesdocketConsumerStatefulWidget {
  const CreateLeadScreen({super.key});

  @override
  SalesdocketConsumerState<CreateLeadScreen> createState() =>
      _CreateLeadScreenState();
}

class _CreateLeadScreenState
    extends SalesdocketConsumerState<CreateLeadScreen> {
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
    final isLoading = ref.watch(loadingStateProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.lblCreateNewEnquiry.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            _createEprForm,
            SalesdocketLoadingOverlay(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  Widget get _createEprForm {
    final leadRequest = ref.watch(leadRequestProvider);
    if (leadRequest == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(2.h),
            const SelectCarWidget(),
            verticalSpacing(2.h),
            const SelectLeadSourceWidget(),
            verticalSpacing(2.h),
            const NameWidget(),
            verticalSpacing(2.h),
            const ContactDetailsWidget(),
            verticalSpacing(2.h),
            const AddressWidget(),
            verticalSpacing(2.h),
            const CreateLeadPlanFollowUpWidget(),
            verticalSpacing(2.h),
            const DateOfEnquiryWidget(),
            verticalSpacing(2.h),
            const ExchangeFinanceWidget(),
            verticalSpacing(2.h),
            const CreateLeadActionWidget(),
          ],
        ),
      ),
    );
  }

  void _invalidateProviders() {
    final providers = [
      selectedContactIndexProvider,
      duplicateLeadInOtherOutletProvider,
      citiesProvider,
      locationsProvider,
      isAddedFullAddressProvider,
      engineTypesProvider,
      modelsProvider,
      variantsProvider,
      createdLeadProvider,
    ];

    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [
      loadingStateProvider,
      createLeadFormErrorsProvider,
      createLeadFormFocusNodesProvider,
      contactDetailsTextFieldControllerProvider,
    ];

    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }
}
