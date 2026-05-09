import 'dart:convert';

import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/dashboard.dart';
import 'package:salesdocket_mobile/common/constants/user_type.dart';
import 'package:salesdocket_mobile/utility/user_utils.dart';

extension SignInRequestExtension on SignInRequest {
  String get generateToken {
    Loggy("").debug(this);
    return " Basic ${base64UrlEncode(utf8.encode("$username:$password"))}";
  }
}

extension UserExtension on User {
  String get fullName {
    return UserUtils.fullName(salutation, firstName, lastName);
  }

  String get fullNameWOSalutation {
    return UserUtils.fullName(
      salutation,
      firstName,
      lastName,
      includeSalutation: false,
    );
  }

  int? get userType {
    if (type == null) return type;

    if (type is int) {
      return type;
    }

    if (type is String) {
      return int.parse(type);
    }

    return type;
  }

  bool get isAdmin {
    return type == UserType.admin.value || type == 0;
  }

  bool get isHOUser {
    return isAdmin && isOwner == 1;
  }

  bool get isSalesManager {
    return type == UserType.salesManager.value;
  }

  bool get isEvaluator {
    return type == UserType.evaluator.value;
  }

  bool get isSalesConsultant {
    return type == UserType.salesConsultant.value;
  }

  bool get shouldFetchAdmins {
    return adminApprovesRequests == "Yes";
  }

  bool get maskMobile {
    return hideMobile == 1;
  }

  bool get maskAddress {
    return hideAddress == 1;
  }

  List<DashboardType> get userDashboards {
    if (isHOUser) return [DashboardType.manager];
    if (isAdmin) return DashboardType.values;
    if (isSalesConsultant) return [DashboardType.lead];
    if (isEvaluator) return [DashboardType.lead];

    return DashboardType.values;
  }
}
