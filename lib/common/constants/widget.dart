import 'package:salesdocket_mobile/common/constants/constant.dart';

class SnackBarType<String> extends Constant {
  const SnackBarType(super.value);

  static const error = SnackBarType("error");
  static const success = SnackBarType("success");
  static const warning = SnackBarType("warning");
}
