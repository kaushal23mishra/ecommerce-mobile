import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/constants/share_document_type.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/share/presentation/share_document_type_menu_bottom_sheet.dart';
import 'package:salesdocket_mobile/features/share/view_model/share_document_view_model.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/document_utils.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerStatefulWidget {
  const ActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionState();
}

class _ActionState extends SalesdocketConsumerState<ActionWidget> {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: "Proceed",
      onPositiveClicked: () {
        _validateAndSubmitRequest();
      },
    );
  }

  void _validateAndSubmitRequest() {
    if (_isValidForm()) {
      _showSendDocumentTypeBottomSheet();
    }
  }

  Future _showSendDocumentTypeBottomSheet() async {
    final actionItem = await showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return const ShareDocumentTypeMenuBottomSheet();
      },
    );

    if (actionItem != null) {
      _onMediaMenuActionClicked(actionItem);
    }
  }

  void _onMediaMenuActionClicked(ShareDocumentType action) {
    ref
        .read(sendDocumentTypeProvider.notifier)
        .update((toUpdate) => toUpdate = action);
    _moveToSelectLeadListScreen();
  }

  void _moveToSelectLeadListScreen() {
    const type = LeadListScreenType.allLeads;
    ref
        .read(getLeadRequestProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate = LeadListUtils.getLeadListDetails(type).defaultRequest,
        );
    ref
        .read(leadListScreenTypeProvider.notifier)
        .update((toUpdate) => toUpdate = type);
    context.router.push(const SelectLeadsRoute());
  }

  bool _isValidForm() {
    final selectedDocuments = ref.read(selectedShareDocumentsProvider);
    final errors = DocumentUtils.validationErrors(selectedDocuments);
    if (errors.isNotEmpty) {
      context.showSnackBar(errors.firstErrorMessage);
      ref.read(sendDocumentFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }
}
