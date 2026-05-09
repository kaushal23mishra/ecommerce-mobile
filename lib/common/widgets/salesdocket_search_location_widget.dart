import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/locality_events.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSearchLocationWidget
    extends SalesdocketConsumerStatefulWidget {
  final int cityId;

  const SalesdocketSearchLocationWidget({super.key, required this.cityId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketSearchLocationState();
}

class _SalesdocketSearchLocationState
    extends SalesdocketConsumerState<SalesdocketSearchLocationWidget>
    with LocalityEvents {
  final _searchController = TextEditingController(text: "");

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupController();
      searchLocations(widget.cityId, const LocationSearchRequest());
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Column(
        children: [
          SalesDocketInputWidget(
            controller: _searchController,
            hint: LocaleKeys.enterLocation.tr(),
          ),
          Expanded(child: _locationsWidget),
        ],
      ),
    );
  }

  Widget get _locationsWidget {
    final locations = ref.watch(locationsProvider);

    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];

        return GestureDetector(
          onTap: () => _onItemSelected(location),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? verticalSpacing(2.h) : const Divider(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Text(
                  location.locality ?? "",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setupController() {
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    final search = _searchController.text;
    searchLocations(widget.cityId, LocationSearchRequest(search: search));
  }

  void _onItemSelected(Location location) {
    context.router.maybePop(location);
  }

  @override
  void onLocationsFetched(List<Location> list) {
    ref
        .read(locationsProvider.notifier)
        .update((locations) => locations = list);
  }

  @override
  WidgetRef get eventRef => ref;
}
