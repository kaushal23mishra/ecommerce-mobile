import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/share_document_type.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';

class DocumentUtils {
  static List<FormFieldError> validationErrors(List<int> documents) {
    final errors = <FormFieldError>[];
    if (documents.isEmpty) {
      errors.add(
        FormFieldError(
          field: SendDocumentFormFields.documents,
          message: "Please select atleast one document!",
        ),
      );
    }

    return errors;
  }

  static SendDocumentsRequest sendDocumentsRequest(
    ShareDocumentType? sendType,
    List<int> selectedDocuments,
    List<Lead> selectedLeads,
  ) {
    var request = SendDocumentsRequest(
      documentIds: selectedDocuments.join(","),
    );
    if (sendType == ShareDocumentType.sms) {
      final phones = selectedLeads
          .map((lead) => lead.phoneNumbers ?? [])
          .expand((phones) => phones)
          .map((phone) => phone.phoneNumber)
          .where((phone) => (phone ?? "").isNotEmpty);

      return request.copyWith(sendSms: phones.join(","));
    } else if (sendType == ShareDocumentType.email) {
      final emails = selectedLeads
          .map((lead) => lead.emails ?? [])
          .expand((emails) => emails)
          .map((email) => email.emailId)
          .where((email) => (email ?? "").isNotEmpty);

      return request.copyWith(
        sendEmail: emails.join(","),
        leadName: "Customer",
      );
    }

    return request;
  }
}
