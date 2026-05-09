import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/scheme_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_car_widget.dart';
import 'package:salesdocket_mobile/features/schemes/presentation/action_widget.dart';
import 'package:salesdocket_mobile/features/schemes/presentation/schemes_list_widget.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "SchemesRoute")
class SchemesScreen extends SalesdocketConsumerStatefulWidget {
  const SchemesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends SalesdocketConsumerState<SchemesScreen>
    with SchemeEvents {
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
    final brokerageLoading = ref.watch(brokerLoadingProvider);
    final lead = ref.watch(getSchemesLeadProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.schemes.tr(),
          onHomeClicked: () => onHomeClicked(),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpacing(3.w),
                    SalesdocketSelectCarWidget(
                      selectedVariants: [
                        lead?.primaryVariant ?? const InterestedVariant(),
                      ],
                      canEdit: false,
                    ),
                    verticalSpacing(2.h),
                    const SchemesListWidget(),
                    verticalSpacing(2.h),
                    const ActionWidget(),
                  ],
                ),
              ),
            ),
            SalesdocketLoadingOverlay(isLoading: brokerageLoading),
          ],
        ),
      ),
    );
  }

  void _fetchData() {
    final lead = ref.read(getSchemesLeadProvider);
    final productReq = ref.read(getSchemesRequestProvider);
    getSchemes(productId: lead?.primaryVariantId, req: productReq);
  }

  void _invalidateProviders() {
    final providers = [schemesProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [brokerFormErrorsProvider];

    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  @override
  void onSchemesFetched(List<Scheme>? schemes) {
    final lead = ref.read(getSchemesLeadProvider);
    final filteredSchemes = lead?.getFilteredSchemes(schemes ?? []) ?? [];
    ref
        .read(schemesProvider.notifier)
        .update((state) => state = filteredSchemes);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
