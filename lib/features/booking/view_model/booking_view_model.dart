import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

part 'booking_view_model.g.dart';

@riverpod
class BookingViewModel extends _$BookingViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<Booking?>>> createBooking({Booking? request}) {
    return ref.read(bookingRepositoryProvider).createBooking(req: request);
  }

  Future<Result<ApiResponse<Booking?>>> updateBooking(
    int bookingId, {
    Booking? request,
    String method = "",
  }) {
    return ref
        .read(bookingRepositoryProvider)
        .updateBooking(bookingId: bookingId, req: request, method: method);
  }

  Future<Result<ApiResponse<Booking?>>> uploadBookingDocuments(
    int bookingId, {
    Booking? request,
    String method = "",
  }) {
    return ref
        .read(bookingRepositoryProvider)
        .uploadBookingDocuments(
          bookingId: bookingId,
          req: request,
          method: method,
        );
  }

  Future<Result<ApiResponse<List<String>?>?>> sendCPAApproval(
    int leadId, {
    ChangeLeadStatusRequest? request,
  }) {
    return ref.read(bookingRepositoryProvider).sendCPAApproval(leadId, request);
  }
}

final canEditBookingProvider = StateProvider<bool>((ref) => true);
final selectedBookingStepProvider = StateProvider<int>((ref) => 0);

//booking
final prevBookingLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final bookingLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final bookingLeadHistoryProvider = StateProvider<List<LeadHistory>>(
  (ref) => [],
);
final bookingFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
final isBookingFormInEditMode = StateProvider<bool>((ref) => true);

//personal details
final contactDetailsProvider = StateProvider<List<ContactDetails>?>(
  (ref) => null,
);
final panImagesProvider = StateProvider<PanImages?>((ref) => null);


//buying details
final editCarDetailsProvider = StateProvider<bool>((ref) => false);
final selectedCarProvider = StateProvider<InterestedVariant?>((ref) => null);
final selectedCarsProvider = StateProvider<List<InterestedVariant>>(
  (ref) => [],
);
final selectedCarColorProvider = StateProvider<InterestedColor?>((ref) => null);
final prevSelectedTestDriveGivenProvider = StateProvider<TestDriveGiven?>(
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
final selectedCustomerQuoteProvider = StateProvider<CustomerQuote?>(
  (ref) => null,
);
final selectedBookingProvider = StateProvider<Booking?>((ref) => null);

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

//booking form
final bookingReceiptsProvider = StateProvider<List<Receipt>>((ref) => []);
final bookingDiscountsProvider = StateProvider<List<Discount>>((ref) => []);
final bookingDiscountApprovalsProvider = StateProvider<DiscountApproval?>(
  (ref) => null,
);
final sendBookingDiscountApprovalRequestProvider =
    StateProvider<DiscountApprovalRequest?>((ref) => null);

final scheduleCallFollowupProvider = StateProvider<bool>((ref) => false);
final bookingFollowupDateTimeProvider = StateProvider<String?>((ref) => null);
