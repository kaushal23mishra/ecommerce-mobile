import 'package:riverpod/riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

final reactivateLeadProvider = StateProvider<Lead?>((ref) => null);
final reactivateLeadFollowupRequestProvider =
    StateProvider<LeadFollowupRequest?>((ref) => null);
final createLeadHistoryRequestProvider =
    StateProvider<CreateLeadHistoryRequest?>((ref) => null);
final reactivateLeadFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
