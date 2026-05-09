import 'package:salesdocket_mobile/common/constants/constant.dart';

class Ownership extends Constant<String> {
  const Ownership(super.value);

  static const first = Ownership("First owner");
  static const second = Ownership("Second owner");
  static const third = Ownership("Third owner");
}

List<Ownership> get ownershipList =>
    [Ownership.first, Ownership.second, Ownership.third].toList();
