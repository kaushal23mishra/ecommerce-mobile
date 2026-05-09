import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';

class UserUtils {
  static String fullName(
    String? salutation,
    String? firstName,
    String? lastName, {
    bool includeSalutation = true,
  }) {
    if ((firstName == null || firstName.trim().isEmpty) && 
        (lastName == null || lastName.trim().isEmpty)) {
      return "";
    }
    var name = "";
    if (includeSalutation && !salutation.isNullOrEmpty) {
      name += "$salutation ";
    }
    if (!firstName.isNullOrEmpty) {
      name += "$firstName";
    }
    if (!lastName.isNullOrEmpty) {
      name += " $lastName";
    }

    return name;
  }

  static String campaignFullName(
    String? firstName,
    String? lastName, {
    bool includeSalutation = true,
  }) {
    var name = "";

    if (!firstName.isNullOrEmpty) {
      name += "$firstName";
    }
    if (!lastName.isNullOrEmpty) {
      name += " $lastName";
    }

    return name;
  }

  static String completeAddress(LeadAddress? address, LeadLocality? locality) {
    String toAdd = "";
    final line1 = address?.line1;
    if (line1 != null && line1.isNotEmpty) {
      toAdd += "$line1 ";
    }
    final line2 = address?.line2;
    if (line2 != null && line2.isNotEmpty) {
      toAdd += "$line2 ";
    }
    final localityName = locality?.localityName;
    if (localityName != null && localityName.isNotEmpty) {
      toAdd += "$localityName ";
    }
    final cityName = locality?.city?.city;
    if (cityName != null && cityName.isNotEmpty) {
      toAdd += "$cityName ";
    }
    final stateName = locality?.city?.state?.state;
    if (stateName != null && stateName.isNotEmpty) {
      toAdd += "$stateName ";
    }

    return toAdd;
  }

  static List<ContactDetails> contactDetails(
    Lead? lead,
    List<LeadPhoneNumber>? phoneNumbers,
    List<LeadEmail>? emails,
  ) {
    final details = <ContactDetails>[];

    final existingPhoneNumbers =
        phoneNumbers == null || phoneNumbers.isEmpty
            ? (lead?.phoneNumbers ?? [])
            : phoneNumbers;
    for (var phone in existingPhoneNumbers) {
      if (details.any((detail) => detail.value == phone.phoneNumber)) continue;

      details.add(
        ContactDetails(
          value: phone.phoneNumber,
          type: phone.phoneType,
          fixed: true,
        ),
      );
    }

    final existingEmails =
        emails == null || emails.isEmpty ? (lead?.emails ?? []) : emails;
    for (var email in existingEmails) {
      if (details.any((detail) => detail.value == email.emailId)) continue;

      details.add(
        ContactDetails(
          value: email.emailId,
          type: ContactType.email.value,
          fixed: true,
        ),
      );
    }

    return details;
  }
}
