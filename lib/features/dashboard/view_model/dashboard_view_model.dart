import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'dashboard_view_model.g.dart';

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<WorkflowCounter?>>> getWorkflowCounters() {
    return ref.read(workflowRepositoryProvider).getWorkflowCounters();
  }
}

final dashboardCurrentPageProvider = StateProvider<int>((ref) => 0);
final workflowCounterProvider = StateProvider<WorkflowCounter?>((ref) => null);

//lead dashboard
final deliveredShowMoreProvider = StateProvider<bool>((ref) => false);
final enquiryShowMoreProvider = StateProvider<bool>((ref) => false);
final conversionShowMoreProvider = StateProvider<bool>((ref) => false);

final deliveredReportProvider = StateProvider<DeliveredReport?>((ref) => null);
final deliveredReportBreakupProvider = StateProvider<DeliveredReport?>(
  (ref) => null,
);
final enquiryReportProvider = StateProvider<EnquiryReport?>((ref) => null);
final enquiryReportBreakupProvider = StateProvider<EnquiryReport?>(
  (ref) => null,
);
final conversionRatioReportProvider = StateProvider<ConversionRatioReport?>(
  (ref) => null,
);
final conversionRatioReportBreakupProvider =
    StateProvider<ConversionRatioReport?>((ref) => null);
final leadsAgingReportProvider = StateProvider<LeadAgingReport?>((ref) => null);
final eprVsRegisteredReportProvider = StateProvider<EprVsRegisteredReport?>(
  (ref) => null,
);
final followupsReportProvider = StateProvider<FollowupsReport?>((ref) => null);
