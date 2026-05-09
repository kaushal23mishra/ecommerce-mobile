import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/form_field_focus_node.dart';
import 'package:salesdocket_mobile/common/events/create_lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_required_label.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ContactDetailsWidget extends SalesdocketConsumerStatefulWidget {
  const ContactDetailsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactDetailsWidgetState();
}

class _ContactDetailsWidgetState
    extends SalesdocketConsumerState<ContactDetailsWidget>
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
    final contactDetails =
        ref.watch(leadRequestProvider.select((lead) => lead?.contactDetails)) ??
        [];

    final controllers = ref.watch(contactDetailsTextFieldControllerProvider);
    final contactDetailErrors =
        ref
            .watch(createLeadFormErrorsProvider)
            .getAll(LeadFormFields.contactDetails) ??
        [];
    final node = ref
        .watch(createLeadFormFocusNodesProvider)
        .get(LeadFormFields.contactDetails);

    return Focus(
      focusNode: node?.focusNode,
      child: Column(
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

              return contactDetails.length != controllers.length
                  ? const SizedBox.shrink()
                  : Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 2.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2.w,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SalesDocketDropDownWidget(
                            imagePath: Assets.svg.arrowDown.path,
                            itemList: _getContactTypes(index == 0),
                            itemValue: contactDetail.type,
                            onChanged:
                                (selected) =>
                                    _onContactTypeChanged(selected, index),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: SalesDocketInputWidget(
                            // enable: !(contactDetails[index].fixed ?? false),
                            controller: controllers[index],
                            maxLength:
                                contactDetail.type == ContactType.email.value
                                    ? 320
                                    : 10,
                            hint: contactDetail.type ?? "",
                            isRequired: true,
                            inputType:
                                contactDetail.type == ContactType.email.value
                                    ? TextInputType.emailAddress
                                    : TextInputType.phone,
                            inputFormatters:
                                contactDetail.type == ContactType.email.value
                                    ? []
                                    : [FilteringTextInputFormatter.digitsOnly],
                            errorMsg: contactError?.message,
                          ),
                        ),
                        if (contactDetails.length > 1 && index != 0)
                          GestureDetector(
                            onTap: () => _onRemoveClicked(index),
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Icon(
                                Icons.remove_circle,
                                color: appColors.error,
                              ),
                            ),
                          ),
                        if (contactDetails.length < 3 && index == 0)
                          Visibility(
                            visible: contactDetails.length < 3 && index == 0,
                            child: GestureDetector(
                              onTap: _onAddMoreClicked,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Icon(
                                  Icons.add_circle_outlined,
                                  color: appColors.info,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  _onContactValueChanged(String newValue, int index) {
    final contactDetails =
        (ref.read(leadRequestProvider)?.contactDetails ?? []).toList();
    contactDetails[index] = contactDetails[index].copyWith(value: newValue);
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) => lead = lead?.copyWith(contactDetails: contactDetails),
        );
    ref
        .read(selectedContactIndexProvider.notifier)
        .update((state) => state = index);
    ref
        .read(createLeadFormErrorsProvider.notifier)
        .removeWhere((element) => element.index == index);

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

  _setupControllers() {
    final contactDetails =
        ref.watch(leadRequestProvider.select((lead) => lead?.contactDetails)) ??
        [];
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
    final contactDetails =
        (ref.read(leadRequestProvider)?.contactDetails ?? []).toList();
    contactDetails.add(ContactDetails(type: ContactType.mobile.value));
    ref
        .read(contactDetailsTextFieldControllerProvider.notifier)
        .addController(
          onChanged:
              (value) => _onContactValueChanged(value, controllers.length),
        );
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) => lead = lead?.copyWith(contactDetails: contactDetails),
        );
  }

  _onRemoveClicked(int index) {
    final contactDetails =
        (ref.read(leadRequestProvider)?.contactDetails ?? []).toList();
    contactDetails.removeAt(index);
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) => lead = lead?.copyWith(contactDetails: contactDetails),
        );
    ref
        .read(contactDetailsTextFieldControllerProvider.notifier)
        .removeController(index);
  }

  _onContactTypeChanged(String? newType, int index) {
    final contactDetails =
        (ref.read(leadRequestProvider)?.contactDetails ?? []).toList();
    contactDetails[index] = ContactDetails(type: newType, value: null);
    final contactDetailsControllers = ref.read(
      contactDetailsTextFieldControllerProvider,
    );
    contactDetailsControllers[index].text = "";
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) => lead = lead?.copyWith(contactDetails: contactDetails),
        );
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

  void _moveToHomeScreen() {
    context.router.popUntilRouteWithName(HomeRoute.page.name);
  }

  @override
  void handleReactiveDuplicateLead(Lead lead) {
    clearContactDetails(lead);
    eventRef
        .read(reactivateLeadProvider.notifier)
        .update((toUpdate) => toUpdate = lead);
    context.router.push(const ReactivateLeadRoute()).then((isReactivated) {
      if (isReactivated is bool && isReactivated == true) {
        _moveToHomeScreen();
      }
    });
  }

  @override
  void clearContactDetails(Lead lead) {
    final selectedIndex = eventRef.read(selectedContactIndexProvider) ?? 0;
    final controllers = eventRef.read(
      contactDetailsTextFieldControllerProvider,
    );
    controllers[selectedIndex].clear();
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
  WidgetRef get eventRef => ref;
}
