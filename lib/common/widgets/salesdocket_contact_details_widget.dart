import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/create_lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_required_label.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketContactDetailsWidget
    extends SalesdocketConsumerStatefulWidget {
  final List<ContactDetails> contactDetails;
  final List<FormFieldError> contactDetailErrors;
  final Function(List<ContactDetails>) updateContactDetails;
  final Function(int)? removeContactError;
  final bool checkContact;
  final List<int> nonRemovableIndices;
  final bool canEditFirstContact;

  const SalesdocketContactDetailsWidget({
    super.key,
    this.contactDetails = const [],
    this.contactDetailErrors = const [],
    required this.updateContactDetails,
    this.removeContactError,
    this.checkContact = true,
    this.nonRemovableIndices = const [],
    this.canEditFirstContact = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketContactDetailsState();
}

class _SalesdocketContactDetailsState
    extends SalesdocketConsumerState<SalesdocketContactDetailsWidget>
    with CreateLeadEvents {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupControllers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controllers = ref.watch(contactDetailsTextFieldControllerProvider);
    final contactDetails = widget.contactDetails;
    final contactDetailErrors = widget.contactDetailErrors;
    final user = ref.watch(profileProvider);

    return contactDetails.length != controllers.length
        ? const SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalesdocketRequiredLabel(
              text: LocaleKeys.lblContactDetails.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            verticalSpacing(1.h),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: contactDetails.length,
              itemBuilder: (BuildContext listContext, int index) {
                final contactDetail = contactDetails[index];
                final contactError = contactDetailErrors.firstWhereOrNull(
                  (error) => error.index == index,
                );

                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2.w,
                    children: [
                      Expanded(
                        flex: 3,
                        child: IgnorePointer(
                          ignoring:
                              (index == 0 && !widget.canEditFirstContact) ||
                              widget.nonRemovableIndices.contains(index),
                          child: SalesDocketDropDownWidget(
                            imagePath: Assets.svg.arrowDown.path,
                            itemList: _getContactTypes(index == 0),
                            itemValue: contactDetail.type,
                            onChanged:
                                (selected) =>
                                    _onContactTypeChanged(selected, index),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child:
                            index == 0 && !widget.canEditFirstContact
                                ? IgnorePointer(
                                  child: SalesDocketInputWidget(
                                    hint: contactDetail.type,
                                    isRequired: true,
                                    initialValue:
                                        (user?.maskMobile ?? false)
                                            ? contactDetail
                                                .value
                                                ?.maskedPhoneNumber
                                            : contactDetail.value,
                                  ),
                                )
                                : SalesDocketInputWidget(
                                  controller: controllers[index],
                                  maxLength:
                                      contactDetail.type ==
                                              ContactType.email.value
                                          ? 320
                                          : 10,
                                  hint: contactDetail.type ?? "",
                                  isRequired: widget.nonRemovableIndices.contains(index),
                                  inputType:
                                      contactDetail.type ==
                                              ContactType.email.value
                                          ? TextInputType.emailAddress
                                          : TextInputType.phone,
                                  inputFormatters:
                                      contactDetail.type ==
                                              ContactType.email.value
                                          ? []
                                          : InputFormatters.mobile,
                                  errorMsg: contactError?.message,
                                ),
                      ),
                      if (contactDetails.length > 1 &&
                          index != 0 &&
                          !widget.nonRemovableIndices.contains(index))
                        GestureDetector(
                          onTap: () => _onRemoveClicked(index),
                          child: Icon(
                            Icons.remove_circle,
                            color: appColors.error,
                          ),
                        ),
                      if (contactDetails.length < 3 && index == 0)
                        Visibility(
                          visible: contactDetails.length < 3 && index == 0,
                          child: GestureDetector(
                            onTap: _onAddMoreClicked,
                            child: Icon(
                              Icons.add_circle_outlined,
                              color: appColors.info,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
  }

  _onContactValueChanged(String newValue, int index) {
    final contactDetails = widget.contactDetails.toList();
    final oldValue = contactDetails[index].value;
    contactDetails[index] = contactDetails[index].copyWith(value: newValue);
    widget.updateContactDetails(contactDetails);
    if (widget.removeContactError != null) {
      widget.removeContactError!(index);
    }
    ref
        .read(selectedContactIndexProvider.notifier)
        .update((state) => state = index);

    if (widget.checkContact && oldValue != newValue) {
      if (contactDetails[index].type != ContactType.email.value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(seconds: 1), () {
          final length = newValue.trim().length;
          if (length >= 8 && length <= 15) {
            searchLeads(newValue);
          }
        });
      }
    }
  }

  _setupControllers() {
    ref.read(contactDetailsTextFieldControllerProvider.notifier).removeAll();
    final contactDetails = widget.contactDetails;
    for (int index = 0; index < contactDetails.length; index++) {
      ref
          .read(contactDetailsTextFieldControllerProvider.notifier)
          .addController(
            text: contactDetails[index].value ?? "",
            onChanged: (value) => _onContactValueChanged(value, index),
          );
    }
  }

  _onAddMoreClicked() {
    final controllers = ref.read(contactDetailsTextFieldControllerProvider);
    final contactDetails = widget.contactDetails.toList();
    contactDetails.add(ContactDetails(type: ContactType.mobile.value));
    ref
        .read(contactDetailsTextFieldControllerProvider.notifier)
        .addController(
          onChanged:
              (value) => _onContactValueChanged(value, controllers.length),
        );
    widget.updateContactDetails(contactDetails);
  }

  _onRemoveClicked(int index) {
    final contactDetails = widget.contactDetails.toList();
    contactDetails.removeAt(index);
    widget.updateContactDetails(contactDetails);
    ref
        .read(contactDetailsTextFieldControllerProvider.notifier)
        .removeController(index);
  }

  _onContactTypeChanged(String? newType, int index) {
    final contactDetails = widget.contactDetails.toList();
    contactDetails[index] = ContactDetails(type: newType, value: null);
    final contactDetailsControllers = ref.read(
      contactDetailsTextFieldControllerProvider,
    );
    contactDetailsControllers[index].text = "";
    widget.updateContactDetails(contactDetails);
  }

  _getContactTypes(bool isFirst) {
    List<String> types = [ContactType.mobile.value];
    if (!isFirst) {
      types.addAll([
        ContactType.home.value,
        ContactType.office.value,
        ContactType.email.value,
      ]);
    }

    return types;
  }

  @override
  void showBottomSheet({
    bool isDismissible = false,
    required WidgetBuilder builder,
  }) {
    showSalesdocketBottomSheet(
      context: context,
      isDismissible: isDismissible,
      builder: builder,
    );
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  void clearContactDetails(Lead lead) {
    final selectedIndex = ref.read(selectedContactIndexProvider) ?? 0;
    final controllers = ref.read(contactDetailsTextFieldControllerProvider);

    if (selectedIndex < controllers.length) {
      controllers[selectedIndex].clear();
    }
  }

  @override
  WidgetRef get eventRef => ref;
}
