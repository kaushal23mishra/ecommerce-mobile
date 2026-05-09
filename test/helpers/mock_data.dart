import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/domain/entities/user_entity.dart';
import 'package:salesdocket_core/src/domain/entities/lead_entity.dart';

/// Factory for creating mock data in tests
class MockData {
  // User mocks
  static User createUser({
    int id = 1,
    String firstName = 'John',
    String lastName = 'Doe',
    String? salutation,
    String? phone,
    String? employeeId,
    String? gender,
    String? dob,
    dynamic type,
    String status = 'active',
    int? organizationId,
    String? organizationName,
    int? hideMobile,
    int? hideAddress,
    int? isOwner,
    int? lpaApprover,
  }) {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      salutation: salutation ?? 'Mr.',
      phone: phone ?? '1234567890',
      employeeId: employeeId,
      gender: gender,
      dob: dob,
      type: type,
      status: status,
      organizationId: organizationId,
      organizationName: organizationName,
      hideMobile: hideMobile,
      hideAddress: hideAddress,
      isOwner: isOwner,
      lpaApprover: lpaApprover,
    );
  }

  static UserEntity createUserEntity({
    int id = 1,
    String firstName = 'John',
    String lastName = 'Doe',
    String? salutation,
    String? phone,
    String? status,
  }) {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      salutation: salutation ?? 'Mr.',
      phone: phone ?? '1234567890',
      status: status ?? 'active',
    );
  }

  // Lead mocks
  static Lead createLead({
    int id = 1,
    String firstName = 'Jane',
    String lastName = 'Customer',
    List<String>? phones,
    List<String>? emails,
    String? localityName,
  }) {
    return Lead(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phoneNumbers:
          phones?.map((p) => LeadPhoneNumber(phoneNumber: p)).toList() ??
          [LeadPhoneNumber(phoneNumber: '9876543210')],
      emails:
          emails?.map((e) => LeadEmail(emailId: e)).toList() ??
          [LeadEmail(emailId: '${firstName.toLowerCase()}@customer.com')],
      locality: LeadLocality(localityName: localityName ?? 'City Center'),
    );
  }

  static LeadEntity createLeadEntity({
    int id = 1,
    String firstName = 'Jane',
    String lastName = 'Customer',
    LeadStatus status = LeadStatus.active,
    DateTime? createdAt,
    List<String>? phoneNumbers,
    List<String>? emails,
  }) {
    return LeadEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      status: status,
      createdAt: createdAt ?? DateTime.now(),
      phoneNumbers: phoneNumbers ?? ['9876543210'],
      emails: emails ?? ['${firstName.toLowerCase()}@customer.com'],
    );
  }

  // API Response mocks
  static ApiResponse<T> createApiResponse<T>(
    T data, {
    int? total,
    int? currentPage,
    int? lastPage,
    dynamic status,
  }) {
    return ApiResponse<T>(
      data: data,
      total: total,
      currentPage: currentPage,
      lastPage: lastPage,
      status: status,
    );
  }

  // Common test users
  static User get admin =>
      createUser(id: 1, firstName: 'Admin', lastName: 'User', type: 1);

  static User get salesManager =>
      createUser(id: 2, firstName: 'Manager', lastName: 'User', type: 2);

  static User get salesConsultant =>
      createUser(id: 3, firstName: 'Consultant', lastName: 'User', type: 3);

  static User get evaluator =>
      createUser(id: 4, firstName: 'Evaluator', lastName: 'User', type: 4);
}
