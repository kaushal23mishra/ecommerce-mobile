import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_search_district_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_search_location_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/locality/utils/extensions.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AddressWidget extends SalesdocketConsumerStatefulWidget {
  const AddressWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends SalesdocketConsumerState<AddressWidget> {
  final _stateController = TextEditingController(text: "");
  final _locationController = TextEditingController(text: "");
  final _districtController = TextEditingController(text: "");
  final _addressLineOneController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    final addressLineOne = ref.read(leadRequestProvider)?.addressLineOne;
    _addressLineOneController.text =
        (addressLineOne == "-") ? "" : (addressLineOne ?? "");
  }

  @override
  void dispose() {
    _districtController.dispose();
    _stateController.dispose();
    _locationController.dispose();
    _addressLineOneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFullAddressAdded = ref.watch(isAddedFullAddressProvider);

    return Column(
      spacing: 2.h,
      children: [
        _districtWidget,
        _locationWidget,
        isFullAddressAdded
            ? GestureDetector(
              onTap: _onRemoveFullAddressClicked,
              child: Row(
                spacing: 2.w,
                children: [
                  Icon(Icons.remove_circle, color: appColors.error),
                  Expanded(
                    child: Text(
                      LocaleKeys.removeFullAddress.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            )
            : GestureDetector(
              onTap: _onAddFullAddressClicked,
              child: Row(
                spacing: 2.w,
                children: [
                  Icon(Icons.add_circle, color: appColors.info),
                  Expanded(
                    child: Text(
                      LocaleKeys.addFullAddress.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
        if (isFullAddressAdded) _fullAddressWidget,
      ],
    );
  }

  Widget get _districtWidget {
    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.district);

    return GestureDetector(
      onTap: _onDistrictClicked,
      child: SalesDocketInputWidget(
        enable: false,
        viewOnly: true,
        controller: _districtController,
        label: LocaleKeys.lblDistrict.tr(),
        isRequired: true,
        errorMsg: error?.message,
      ),
    );
  }

  Widget get _locationWidget {
    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.location);

    return GestureDetector(
      onTap: _onLocationClicked,
      child: SalesDocketInputWidget(
        enable: false,
        viewOnly: true,
        controller: _locationController,
        label: LocaleKeys.lblLocation.tr(),
        isRequired: true,
        errorMsg: error?.message,
      ),
    );
  }

  Widget get _fullAddressWidget {
    final addressLineOneError = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.addressLineOne);

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
          maxLength: 25,
          inputType: TextInputType.text,
          label: '${LocaleKeys.lblAddressLine.tr()} 1',
          hint: '${LocaleKeys.lblAddressLine.tr()} 1',
          onChanged: _onAddressLineOneTextChanged,
          errorMsg: addressLineOneError?.message,
        ),
        SalesDocketInputWidget(
          maxLength: 25,
          inputType: TextInputType.text,
          label: '${LocaleKeys.lblAddressLine.tr()} 2',
          hint: '${LocaleKeys.lblAddressLine.tr()} 2',
          onChanged: _onAddressLineTwoTextChanged,
        ),
      ],
    );
  }

  void _onDistrictClicked() async {
    final oldCity = ref.read(leadRequestProvider)?.cityId;
    ref.invalidate(citiesProvider);

    final city = await showSalesdocketBottomSheet<City?>(
      context: context,
      builder:
          (_) => SalesdocketBottomSheet(
            title: LocaleKeys.searchDistrict.tr(),
            widget: SalesdocketSearchDistrictWidget(
              city: _districtController.text,
            ),
          ),
    );

    if (city != null && city.id != oldCity) {
      ref
          .read(leadRequestProvider.notifier)
          .update((lead) => lead = lead?.copyWith(cityId: city.id));
      ref
          .read(createLeadFormErrorsProvider.notifier)
          .remove(LeadFormFields.district);
      ref
          .read(leadRequestProvider.notifier)
          .update((lead) => lead = lead?.copyWith(localityId: null));

      _districtController.text = city.cityName;
      _stateController.text = city.stateName;
      _locationController.text = "";
    }
  }

  void _onLocationClicked() async {
    final cityId = ref.read(leadRequestProvider)?.cityId;
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

    ref
        .read(leadRequestProvider.notifier)
        .update((lead) => lead = lead?.copyWith(localityId: location?.id));
    final locations = ref.read(locationsProvider);
    final locationId = ref.read(
      leadRequestProvider.select((lead) => lead?.localityId),
    );
    final selectedLocation = locations.firstWhereOrNull(
      (location) => location.id == locationId,
    );
    _locationController.text = selectedLocation?.locality ?? "";
    ref
        .read(createLeadFormErrorsProvider.notifier)
        .remove(LeadFormFields.location);
  }

  void _onAddFullAddressClicked() {
    ref
        .read(isAddedFullAddressProvider.notifier)
        .update((isAdded) => isAdded = true);
  }

  void _onRemoveFullAddressClicked() {
    ref
        .read(isAddedFullAddressProvider.notifier)
        .update((isAdded) => isAdded = false);
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) =>
              lead = lead?.copyWith(addressLineOne: null, addressLineTwo: null),
        );
  }

  void _onAddressLineOneTextChanged(String text) {
    ref
        .read(leadRequestProvider.notifier)
        .update((lead) => lead = lead?.copyWith(addressLineOne: text.trim()));
    ref
        .read(createLeadFormErrorsProvider.notifier)
        .remove(LeadFormFields.addressLineOne);
  }

  void _onAddressLineTwoTextChanged(String text) {
    ref
        .read(leadRequestProvider.notifier)
        .update((lead) => lead = lead?.copyWith(addressLineTwo: text.trim()));
  }
}
