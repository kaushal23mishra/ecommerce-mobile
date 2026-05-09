import 'package:salesdocket_mobile/common/constants/constant.dart';

class PurchaseMode extends Constant<String> {
  const PurchaseMode(super.value);

  static const finance = PurchaseMode('Finance');
  static const cash = PurchaseMode('Cash');
  static const po = PurchaseMode('PO');
  static const referral = PurchaseMode('Referral');
}

List<PurchaseMode> get purchaseModeList =>
    [PurchaseMode.cash, PurchaseMode.finance, PurchaseMode.po].toList();

class FinanceForm extends Constant<String> {
  const FinanceForm(super.value);

  static const dO = FinanceForm('DO');
  static const credit = FinanceForm('Credit');
  static const self = FinanceForm('Self');
}

List<FinanceForm> get financeFormList =>
    [FinanceForm.dO, FinanceForm.credit, FinanceForm.self].toList();

class FinanceReason extends Constant<String> {
  final String key;

  const FinanceReason(super.value, {required this.key});

  static const betterReason = FinanceReason(
    'Better Reason',
    key: "Better rate",
  );
  static const ownBankerRelation = FinanceReason(
    'Own Banker Relation',
    key: "Own Banker Relation",
  );
  static const lessPaperFormalities = FinanceReason(
    'Less Paper Foundation',
    key: "Less Paper Formalities",
  );
  static const betterTerms = FinanceReason('Better Terms', key: "Better Terms");
  static const directDSALead = FinanceReason(
    'Direct DSA Lead',
    key: "Direct DSA Lead",
  );
}

List<FinanceReason> get selfFinanceReasonsList =>
    [
      FinanceReason.betterReason,
      FinanceReason.ownBankerRelation,
      FinanceReason.lessPaperFormalities,
      FinanceReason.betterTerms,
    ].toList();

List<FinanceReason> get otherFinanceReasonsList =>
    [
      FinanceReason.betterReason,
      FinanceReason.ownBankerRelation,
      FinanceReason.lessPaperFormalities,
      FinanceReason.betterTerms,
      FinanceReason.directDSALead,
    ].toList();
