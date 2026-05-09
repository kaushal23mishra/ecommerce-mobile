import 'package:salesdocket_mobile/common/constants/constant.dart';

class UserType extends Constant<String> {
  const UserType(super.value);

  static const admin = UserType('Admin');
  static const salesManager = UserType('Sales Manager');
  static const salesConsultant = UserType('Sales Consultant');
  static const evaluator = UserType('EVALUATOR');
}
