import 'package:salesdocket_mobile/common/constants/constant.dart';

class TestDriveGivenState extends Constant<int> {
  final String label;

  const TestDriveGivenState(super.value, this.label);

  static const yes = TestDriveGivenState(1, "Yes");
  static const no = TestDriveGivenState(0, "No");
}

List<TestDriveGivenState> get testDriveGivenStateList =>
    [TestDriveGivenState.yes, TestDriveGivenState.no].toList();

class TestDriveWhyNotGivenState extends Constant<String> {
  const TestDriveWhyNotGivenState(super.value);

  static const notInterested = TestDriveWhyNotGivenState('Not interested');
  static const vehicleNotAvailable = TestDriveWhyNotGivenState(
    'Vehicle not available',
  );
  static const vehicleDamagedOrUnderRepair = TestDriveWhyNotGivenState(
    'Vehicle damaged/under repair',
  );
  static const notMetInPerson = TestDriveWhyNotGivenState('Not met in person');
  static const alreadyDriven = TestDriveWhyNotGivenState('Already driven');
  static const iDidNotOffer = TestDriveWhyNotGivenState('I Did Not Offer');
  static const others = TestDriveWhyNotGivenState('Others');
}

List<String> get testDriveWhyNotGivenStateList =>
    [
      TestDriveWhyNotGivenState.notInterested,
      TestDriveWhyNotGivenState.vehicleNotAvailable,
      TestDriveWhyNotGivenState.vehicleDamagedOrUnderRepair,
      TestDriveWhyNotGivenState.notMetInPerson,
      TestDriveWhyNotGivenState.alreadyDriven,
      TestDriveWhyNotGivenState.iDidNotOffer,
      TestDriveWhyNotGivenState.others,
    ].map((status) => status.value).toList();
