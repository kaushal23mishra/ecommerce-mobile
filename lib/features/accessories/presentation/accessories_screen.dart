import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/accessories_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_car_widget.dart';
import 'package:salesdocket_mobile/features/accessories/presentation/accessories_list_widget.dart';
import 'package:salesdocket_mobile/features/accessories/presentation/action_widget.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: "AccessoriesRoute")
class AccessoriesScreen extends SalesdocketConsumerStatefulWidget {
  const AccessoriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccessoriesScreenState();
}

class _AccessoriesScreenState
    extends SalesdocketConsumerState<AccessoriesScreen>
    with AccessoriesEvents {
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
    final lead = ref.watch(getAccessoriesLeadProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          titleText: LocaleKeys.accessories.tr(),
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
                    const AccessoriesListWidget(),
                    verticalSpacing(2.h),
                    const ActionWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchData() {
    final lead = ref.read(getAccessoriesLeadProvider);
    getAccessories(productId: lead?.primaryVariantId);
  }

  void _invalidateProviders() {
    final providers = [accessoriesProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  @override
  void onAccessoriesFetched(List<Accessory>? accessories) {
    ref
        .read(accessoriesProvider.notifier)
        .update((state) => state = accessories ?? []);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
