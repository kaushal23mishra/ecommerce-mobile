import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/credit_given.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/old_car_payment.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';
import 'package:salesdocket_mobile/utility/delivery_utils.dart';

part 'delivery_view_model.g.dart';

@riverpod
class DeliveryViewModel extends _$DeliveryViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<Delivery?>>> createDelivery({Delivery? request}) {
    return ref.read(deliveryRepositoryProvider).createDelivery(req: request);
  }

  Future<Result<ApiResponse<Delivery?>>> updateDelivery(
    int deliveryId, {
    Delivery? request,
    String method = "",
  }) {
    return ref
        .read(deliveryRepositoryProvider)
        .updateDelivery(deliveryId: deliveryId, req: request, method: method);
  }

  Future<Result<ApiResponse<Delivery?>>> uploadDeliveryDocuments({
    int? deliveryId,
    Delivery? request,
    String method = "",
  }) {
    return ref
        .read(deliveryRepositoryProvider)
        .uploadDeliveryDocuments(
          deliveryId: deliveryId,
          req: request,
          method: method,
        );
  }

  int calculatePendingAmountForCreditGiven() {
    final lead = ref.read(deliveryLeadRequestProvider);
    final receipts = ref.read(deliveryReceiptsProvider);
    final exchangeHouse = ref.read(selectedExchangeHouseProvider);
    final quotation = ref.read(quotationProvider);
    final booking = ref.read(selectedBookingProvider);
    final pendingAmount = DeliveryUtils.calculatePendingAmount(
      receipts: receipts,
      exchangeHouse:
          (exchangeHouse?.isExchanged ?? false) ? exchangeHouse : null,
      quotation: quotation,
      booking: (lead?.isFinance ?? false) ? booking : null,
    );

    return pendingAmount;
  }
}

final canEditDeliveryProvider = StateProvider<bool>((ref) => true);
final selectedDeliveryStepProvider = StateProvider<int>((ref) => 0);

//delivery
final prevDeliveryLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final deliveryLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final deliveryLeadHistoryProvider = StateProvider<List<LeadHistory>>(
  (ref) => [],
);
final deliveryFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
final isDeliveryFormInEditMode = StateProvider<bool>((ref) => true);

//personal details
final detailsSameAsPreviousProvider = StateProvider<bool>((ref) => true);
final contactDetailsProvider = StateProvider<List<ContactDetails>?>(
  (ref) => null,
);
final deliveryEmailValueProvider = StateProvider<String?>((ref) => null);
final panImagesProvider = StateProvider<PanImages?>((ref) => null);

final selectedDeliveryProvider = StateProvider<Delivery?>((ref) => null);
final showMoreDeliveryDocumentsProvider = StateProvider<bool>((ref) => false);

//buying details
final editCarDetailsProvider = StateProvider<bool>((ref) => false);
final selectedCarProvider = StateProvider<InterestedVariant?>((ref) => null);
final selectedCarsProvider = StateProvider<List<InterestedVariant>>(
  (ref) => [],
);
final selectedCarColorProvider = StateProvider<InterestedColor?>((ref) => null);
final prevTestDriveGivenProvider = StateProvider<TestDriveGiven?>(
  (ref) => null,
);
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
final selectedBookingProvider = StateProvider<Booking?>((ref) => null);
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
final selectedExchangeHouseProvider = StateProvider<ExchangeHouseRequest?>(
  (ref) => null,
);

//offer details
final editOfferSummaryProvider = StateProvider<bool>((ref) => false);
final addRemarksProvider = StateProvider<bool>((ref) => false);
final quotationProvider = StateProvider<Quotation?>((ref) => null);

//payment details
final deliveryReceiptsProvider = StateProvider<List<Receipt>>((ref) => []);
final deliveryReceiptReasonsProvider = StateProvider<List<ReceiptReason>>(
  (ref) => [],
);
final creditGivenProvider = StateProvider<CreditGiven?>((ref) => null);
final oldCarPaymentProvider = StateProvider<OldCarPayment?>((ref) => null);
final isFinanceEditModeProvider = StateProvider<bool>((ref) => false);

//delivery form
final deliveryDiscountsProvider = StateProvider<List<Discount>>((ref) => []);
final deliveryDiscountApprovalsProvider = StateProvider<DiscountApproval?>(
  (ref) => null,
);
final sendDeliveryDiscountApprovalRequestProvider =
    StateProvider<DiscountApprovalRequest?>((ref) => null);
