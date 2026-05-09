import 'package:salesdocket_mobile/common/constants/constant.dart';

class Profession extends Constant<String> {
  const Profession(super.val);

  static const engineer = Profession('Engineer');
  static const it = Profession('IT');
  static const business = Profession('Business');
  static const governmentEmployee = Profession('Government Employee');
  static const teacher = Profession('Teacher');
  static const banker = Profession('Banker');
  static const corporateOfficials = Profession('Corporate Officials');
  static const athlete = Profession('Athlete');
  static const artists = Profession('Artists');
  static const lawyer = Profession('Lawyer');
  static const hospitality = Profession('Hospitality');
  static const labour = Profession('Labour');
  static const politician = Profession('Politician');
  static const doctor = Profession('Doctor');
  static const nurse = Profession('Nurse');
  static const customerDidntReveal = Profession("Customer Didn't Reveal");
  static const other = Profession('Other');

  // Legacy constants kept for backward compatibility with existing backend data
  static const salaried = Profession('Salaried');
  static const selfEmployed = Profession('Self Employed');
  static const iDidNotAsk = Profession('I Did not ask');
}

List<String> get professionList =>
    [
      Profession.engineer,
      Profession.it,
      Profession.business,
      Profession.governmentEmployee,
      Profession.teacher,
      Profession.banker,
      Profession.corporateOfficials,
      Profession.athlete,
      Profession.artists,
      Profession.lawyer,
      Profession.hospitality,
      Profession.labour,
      Profession.politician,
      Profession.doctor,
      Profession.nurse,
      Profession.customerDidntReveal,
      Profession.other,
      // Legacy values — kept so existing records display correctly in the dropdown
      Profession.salaried,
      Profession.selfEmployed,
      Profession.iDidNotAsk,
    ].map((p) => p.value).toList();
