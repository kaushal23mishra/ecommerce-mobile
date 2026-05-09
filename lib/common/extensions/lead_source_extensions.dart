import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/constants/lead_source_type.dart';
import 'package:salesdocket_mobile/common/entity/lead_source.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

extension LeadSourceExtension on LeadSource {
  bool get isInstitutional => source == LeadSourceType.institutional.value;

  bool get showReferralFields {
    if (isInstitutional) {
      return information != null && information!.isNotEmpty;
    }
    if (source != LeadSourceType.referral.value) return false;
    return information == LocaleKeys.lblFriendsAndFamily.tr() ||
        information == LocaleKeys.lblBusinessNetwork.tr() ||
        information == LocaleKeys.lblDirector.tr();
  }
}
