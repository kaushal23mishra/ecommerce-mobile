import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/lead_source.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

final selectedProspectSheetStepProvider = StateProvider<int>((ref) => 0);

//prospect lead
final prevProspectLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final prospectLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final prospectLeadHistoryProvider = StateProvider<List<LeadHistory>>(
  (ref) => [],
);
final prospectFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
final isProspectFormInEditMode = StateProvider<bool>((ref) => true);
final canEditProspectSheetProvider = StateProvider<bool>((ref) => true);
final isECEditModeProvider = StateProvider<bool>((ref) => false);

//personal details
final contactDetailsProvider = StateProvider<List<ContactDetails>?>(
  (ref) => null,
);

//buying details
final editCarDetailsProvider = StateProvider<bool>((ref) => false);
final selectedCarProvider = StateProvider<InterestedVariant?>((ref) => null);
final selectedCarsProvider = StateProvider<List<InterestedVariant>>(
  (ref) => [],
);
final selectedCarColorProvider = StateProvider<InterestedColor?>((ref) => null);
final selectedLeadSourceProvider = StateProvider<LeadSource?>((ref) => null);
final selectedTestDriveGivenProvider = StateProvider<TestDriveGiven?>(
  (ref) => null,
);
final selectedInterestedInCompProvider = StateProvider<InterestedInComp?>(
  (ref) => null,
);
final editExistingVehicleProvider = StateProvider<bool>((ref) => false);
final selectedFirstTimeBuyerProvider = StateProvider<FirstTimeBuyer?>(
  (ref) => null,
);
final selectedCustomerQuoteProvider = StateProvider<CustomerQuote?>(
  (ref) => null,
);

//exchange details
final editExchangeVehicleDetailsProvider = StateProvider<bool>((ref) => false);
final selectedExchangeCarProvider = StateProvider<FirstTimeBuyer?>(
  (ref) => null,
);
final selectedExchangeProductProvider = StateProvider<ExchangeProduct?>(
  (ref) => null,
);
final editTyreReplacementProvider = StateProvider<bool>((ref) => false);
final addExchangeVehicleImagesProvider = StateProvider<bool>((ref) => false);
final addMoreExchangeVehicleImagesProvider = StateProvider<bool>(
  (ref) => false,
);
final exchangeImagesProvider = StateProvider<ExchangeProductImages?>(
  (ref) => null,
);

//offer details
final editOfferSummaryProvider = StateProvider<bool>((ref) => false);
final quotationProvider = StateProvider<Quotation?>((ref) => null);

//plan follow-up
final updatedFollowupPlanProvider = StateProvider<CreateLeadHistoryRequest?>(
  (ref) => null,
);
final rescheduleFollowupProvider = StateProvider<bool>((ref) => false);
final rescheduleFollowupRequestProvider = StateProvider<LeadFollowupRequest?>(
  (ref) => null,
);
