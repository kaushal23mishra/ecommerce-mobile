import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/document_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/share/view_model/share_document_view_model.dart';
import 'package:salesdocket_mobile/utility/document_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerStatefulWidget {
  const ActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionState();
}

class _ActionState extends SalesdocketConsumerState<ActionWidget>
    with DocumentEvents {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.secondary,
        boxShadow: [
          BoxShadow(
            color: appColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SalesdocketActionWidget(
        positiveText: "Send",
        onPositiveClicked: () {
          _validateAndSubmitRequest();
        },
      ),
    );
  }

  void _validateAndSubmitRequest() {
    final selectedLeads = ref.read(selectedLeadsProvider);
    final sendBy = ref.read(sendDocumentTypeProvider);
    final selectedDocuments = ref.read(selectedShareDocumentsProvider);
    final request = DocumentUtils.sendDocumentsRequest(
      sendBy,
      selectedDocuments,
      selectedLeads,
    );
    sendDocuments(request: request);
  }

  @override
  void onDocumentsSend() {
    showSnackBar("Document Shared Successfully", type: SnackBarType.success);
    onHomeClicked();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
