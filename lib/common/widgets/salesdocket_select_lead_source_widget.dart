import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/constants/lead_source_type.dart';
import 'package:salesdocket_mobile/common/entity/lead_source.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_source_extensions.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSelectLeadSourceWidget extends StatefulWidget {
  final LeadSource? selectedSource;
  final Function(String?) onSourceChanged;
  final Function(String?) onInformationChanged;
  final Function(String?) onOtherReasonChanged;
  final Function(String?)? onReferralNameChanged;
  final Function(String?)? onReferralNumberChanged;

  const SalesdocketSelectLeadSourceWidget({
    super.key,
    this.selectedSource,
    required this.onSourceChanged,
    required this.onInformationChanged,
    required this.onOtherReasonChanged,
    this.onReferralNameChanged,
    this.onReferralNumberChanged,
  });

  @override
  State<SalesdocketSelectLeadSourceWidget> createState() =>
      _SalesdocketSelectLeadSourceWidgetState();
}

class _SalesdocketSelectLeadSourceWidgetState
    extends State<SalesdocketSelectLeadSourceWidget> {
  late TextEditingController otherReasonController;
  late TextEditingController referralNameController;
  late TextEditingController referralNumberController;
  String? _referralNumberError;

  @override
  void initState() {
    super.initState();
    otherReasonController = TextEditingController(
      text: widget.selectedSource?.otherReason ?? "",
    );
    referralNameController = TextEditingController(
      text: widget.selectedSource?.referralName ?? "",
    );
    referralNumberController = TextEditingController(
      text: widget.selectedSource?.referralNumber ?? "",
    );
  }

  @override
  void didUpdateWidget(covariant SalesdocketSelectLeadSourceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedSource?.otherReason !=
        oldWidget.selectedSource?.otherReason) {
      otherReasonController.text = widget.selectedSource?.otherReason ?? "";
    }
    if (widget.selectedSource?.referralName !=
        oldWidget.selectedSource?.referralName) {
      referralNameController.text = widget.selectedSource?.referralName ?? "";
    }
    if (widget.selectedSource?.referralNumber !=
        oldWidget.selectedSource?.referralNumber) {
      referralNumberController.text =
          widget.selectedSource?.referralNumber ?? "";
    }
    if (widget.selectedSource?.source != oldWidget.selectedSource?.source) {
      setState(() => _referralNumberError = null);
    }
  }

  @override
  void dispose() {
    otherReasonController.dispose();
    referralNameController.dispose();
    referralNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SalesDocketChipWidget(
          label: LocaleKeys.lblLeadSource.tr(),
          isRequired: true,
          chips: leadSourcesList.map((source) => source.value).toList(),
          selectedChips: widget.selectedSource?.source == null
              ? []
              : [widget.selectedSource?.source ?? ""],
          errorText: widget.selectedSource?.sourceErr,
          onSelected: (selected) {
            widget.onSourceChanged(selected?.firstOrNull);
          },
        ),
        _sourceOfInformationWidget,
        _othersSourceOfInformationWidget,
        if (widget.selectedSource?.showReferralFields == true) _referralFieldsWidget,
      ],
    );
  }

  Widget get _sourceOfInformationWidget {
    final reasons = leadSourcesList
            .firstWhereOrNull(
              (source) => source.value == widget.selectedSource?.source,
            )
            ?.reasons ??
        [];

    return reasons.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketDropDownWidget(
              text: LocaleKeys.lblSourceOfLead.tr(),
              itemList: reasons,
              itemValue: widget.selectedSource?.information,
              imagePath: Assets.svg.arrowDown.path,
              errorText: widget.selectedSource?.informationErr,
              onChanged: widget.onInformationChanged,
            ),
          );
  }

  Widget get _othersSourceOfInformationWidget {
    if (widget.selectedSource?.information == LocaleKeys.others.tr()) {
      return Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: SalesDocketInputWidget(
          maxLength: 25,
          inputType: TextInputType.text,
          label: LocaleKeys.others.tr(),
          controller: otherReasonController,
          hint: LocaleKeys.others.tr(),
          errorMsg: widget.selectedSource?.otherReasonErr,
          onChanged: (value) {
            widget.onOtherReasonChanged(value.trim());
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget get _referralFieldsWidget {
    final isInstitutional = widget.selectedSource?.isInstitutional == true;
    final nameLbl = isInstitutional ? 'Institution Name' : 'Referral Name';
    final numberLbl = isInstitutional ? 'Institution Number' : 'Referral Number';
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: SalesDocketInputWidget(
            inputType: TextInputType.text,
            label: nameLbl,
            hint: 'Enter $nameLbl',
            controller: referralNameController,
            onChanged: (value) {
              widget.onReferralNameChanged?.call(
                value.trim().isNotEmpty ? value.trim() : null,
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: SalesDocketInputWidget(
            inputType: TextInputType.phone,
            label: numberLbl,
            hint: 'Enter $numberLbl',
            controller: referralNumberController,
            inputFormatters: InputFormatters.mobile,
            errorMsg: _referralNumberError,
            onChanged: (value) {
              final trimmed = value.trim().isNotEmpty ? value.trim() : null;
              setState(() {
                _referralNumberError = trimmed != null
                    ? validateMobile(trimmed)
                    : null;
              });
              if (_referralNumberError == null) {
                widget.onReferralNumberChanged?.call(trimmed);
              }
            },
          ),
        ),
      ],
    );
  }
}
