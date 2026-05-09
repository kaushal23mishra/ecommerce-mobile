import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/locality_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_search_district_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_search_location_widget.dart';
import 'package:salesdocket_mobile/features/locality/utils/extensions.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketAddressWidget extends SalesdocketConsumerStatefulWidget {
  final List<FormFieldError> errors;
  final Function(LeadFormFields)? removeError;

  const SalesdocketAddressWidget({
    super.key,
    this.errors = const [],
    this.removeError,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketAddressState();
}

class _SalesdocketAddressState
    extends SalesdocketConsumerState<SalesdocketAddressWidget>
    with LocalityEvents {
  final _cityController = TextEditingController(text: "");
  final _stateController = TextEditingController(text: "");
  final _locationController = TextEditingController(text: "");
  final _addressLineOneController = TextEditingController(text: "");
  final _addressLineTwoController = TextEditingController(text: "");

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupLocality();
      _setupAddress();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _locationController.dispose();
    _addressLineOneController.dispose();
    _addressLineTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2.h,
      children: [_districtWidget, _locationWidget, _fullAddressWidget],
    );
  }

  Widget get _districtWidget {
    final error = widget.errors.get(LeadFormFields.district);

    return GestureDetector(
      onTap: _onDistrictClicked,
      child: SalesDocketInputWidget(
        enable: false,
        viewOnly: true,
        controller: _cityController,
        hint: LocaleKeys.lblDistrict.tr(),
        label: LocaleKeys.lblDistrict.tr(),
        isRequired: true,
        errorMsg: error?.message,
      ),
    );
  }

  Widget get _locationWidget {
    final error = widget.errors.get(LeadFormFields.location);

    return GestureDetector(
      onTap: _onLocationClicked,
      child: SalesDocketInputWidget(
        enable: false,
        viewOnly: true,
        controller: _locationController,
        hint: LocaleKeys.lblLocation.tr(),
        label: LocaleKeys.lblLocation.tr(),
        isRequired: true,
        errorMsg: error?.message,
      ),
    );
  }

  Widget get _fullAddressWidget {
    final addressLine1Error = widget.errors.get(LeadFormFields.addressLineOne);
    ref.listen<LeadAddress?>(addressProvider, _addressProviderListener);

    return Column(
      spacing: 2.h,
      children: [
        SalesDocketInputWidget(
          controller: _stateController,
          label: LocaleKeys.lblState.tr(),
          hint: LocaleKeys.lblState.tr(),
          enable: false,
          viewOnly: true,
        ),
        SalesDocketInputWidget(
          controller: _addressLineOneController,
          maxLength: 150,
          inputType: TextInputType.text,
          label: '${LocaleKeys.lblAddressLine.tr()} 1',
          hint: '${LocaleKeys.lblAddressLine.tr()} 1',
          isRequired: true,
          errorMsg: addressLine1Error?.message,
        ),
        SalesDocketInputWidget(
          controller: _addressLineTwoController,
          maxLength: 150,
          inputType: TextInputType.text,
          label: '${LocaleKeys.lblAddressLine.tr()} 2',
          hint: '${LocaleKeys.lblAddressLine.tr()} 2',
        ),
      ],
    );
  }

  void _setupAddress() {
    final address = ref.read(addressProvider);
    _addressLineOneController.text =
        (address?.line1 == "-") ? "" : (address?.line1 ?? "");
    _addressLineOneController.addListener(() {
      _onAddressLineOneTextChanged(_addressLineOneController.text);
    });
    _addressLineTwoController.text = address?.line2 ?? "";
    _addressLineTwoController.addListener(() {
      _onAddressLineTwoTextChanged(_addressLineTwoController.text);
    });
  }

  void _addressProviderListener(LeadAddress? prev, LeadAddress? next) {
    if (prev?.line1 != next?.line1) {
      _addressLineOneController.text =
          (next?.line1 == "-") ? "" : (next?.line1 ?? "");
    }
    if (prev?.line2 != next?.line2) {
      _addressLineTwoController.text = next?.line2 ?? "";
    }
  }

  void _onDistrictClicked() async {
    final oldCity = ref.read(localityProvider)?.city?.id;
    ref.invalidate(citiesProvider);

    final city = await showSalesdocketBottomSheet<City?>(
      context: context,
      builder:
          (_) => SalesdocketBottomSheet(
            title: LocaleKeys.searchDistrict.tr(),
            widget: SalesdocketSearchDistrictWidget(city: _cityController.text),
          ),
    );

    if (city != null && city.id != oldCity) {
      ref
          .read(localityProvider.notifier)
          .update((state) => state = state?.copyWith(city: City(id: city.id)));
      ref
          .read(localityProvider.notifier)
          .update((state) => state = state?.copyWith(id: null));
      if (widget.removeError != null) {
        widget.removeError!(LeadFormFields.district);
      }

      _cityController.text = city.cityName;
      _stateController.text = city.stateName;
      _locationController.text = "";
    }
  }

  void _onLocationClicked() async {
    final cityId = ref.read(localityProvider)?.city?.id;
    if (cityId == null) {
      context.showSnackBar(
        LocaleKeys.pleaseEnterValidCity.tr(),
        type: SnackBarType.error,
      );
      return;
    }

    ref.invalidate(locationsProvider);
    final location = await showSalesdocketBottomSheet<Location?>(
      context: context,
      builder:
          (_) => SalesdocketBottomSheet(
            title: LocaleKeys.searchLocation.tr(),
            widget: SalesdocketSearchLocationWidget(cityId: cityId),
          ),
    );

    if (location == null) return;

    ref
        .read(localityProvider.notifier)
        .update((state) => state = state?.copyWith(id: location.id));
    final locations = ref.watch(locationsProvider);
    final locationId = ref.read(localityProvider.select((state) => state?.id));
    final selectedLocation = locations.firstWhereOrNull(
      (location) => location.id == locationId,
    );
    _locationController.text = selectedLocation?.locality ?? "";
    if (widget.removeError != null) {
      widget.removeError!(LeadFormFields.location);
    }
  }

  void _setupLocality() {
    final locality = ref.read(localityProvider);
    final city = locality?.city?.city;
    if (city != null) {
      searchCities(text: city);
    }

    _cityController.text = city ?? "";
    _locationController.text = locality?.localityName ?? "";
  }

  @override
  void onCitiesFetched(List<City> cities) {
    final selectedCity = ref.read(localityProvider)?.city?.id;
    if (selectedCity != null) {
      final city = cities.firstWhereOrNull(
        (toFilter) => toFilter.id == selectedCity,
      );
      _stateController.text = city?.stateName ?? "";
    }
  }

  void _onAddressLineOneTextChanged(String text) {
    ref
        .read(addressProvider.notifier)
        .update((state) => state = state?.copyWith(line1: text.trim()));
    if (widget.removeError != null) {
      widget.removeError!(LeadFormFields.addressLineOne);
    }
  }

  void _onAddressLineTwoTextChanged(String text) {
    ref
        .read(addressProvider.notifier)
        .update((lead) => lead = lead?.copyWith(line2: text.trim()));
  }

  @override
  WidgetRef get eventRef => ref;
}
