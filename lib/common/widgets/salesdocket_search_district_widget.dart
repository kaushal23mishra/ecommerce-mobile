import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/locality_events.dart';
import 'package:salesdocket_mobile/features/locality/utils/extensions.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSearchDistrictWidget
    extends SalesdocketConsumerStatefulWidget {
  final String city;

  const SalesdocketSearchDistrictWidget({super.key, this.city = ""});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketSearchDistrictState();
}

class _SalesdocketSearchDistrictState
    extends SalesdocketConsumerState<SalesdocketSearchDistrictWidget>
    with LocalityEvents {
  final _searchController = TextEditingController(text: "");

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupController();
      _searchCities(widget.city);
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
            hint: LocaleKeys.enterDistrict.tr(),
          ),
          Expanded(child: _citiesWidget),
        ],
      ),
    );
  }

  Widget get _citiesWidget {
    final cities = ref.watch(citiesProvider);

    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];

        return GestureDetector(
          onTap: () => _onItemSelected(city),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? verticalSpacing(2.h) : const Divider(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Text(
                  city.cityName,
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
    _searchController.text = widget.city;
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    final search = _searchController.text.trim();
    _searchCities(search);
  }

  void _searchCities(String search) {
    searchCities(text: search.isEmpty ? null : search);
  }

  void _onItemSelected(City city) {
    context.router.maybePop(city);
  }

  @override
  void onCitiesFetched(List<City> list) {
    ref.read(citiesProvider.notifier).update((cities) => cities = list);
  }

  @override
  WidgetRef get eventRef => ref;
}
