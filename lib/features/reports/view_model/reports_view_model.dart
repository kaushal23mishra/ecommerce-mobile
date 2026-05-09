import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/reports_loader.dart';

part 'reports_view_model.g.dart';

@riverpod
class ReportsViewModel extends _$ReportsViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<DeliveredReport?>> deliveredReport() {
    return ref.read(reportsRepositoryProvider).deliveredReport();
  }

  Future<Result<DeliveredReport?>> deliveredReportBreakup() {
    return ref.read(reportsRepositoryProvider).deliveredReportBreakup();
  }

  Future<Result<EnquiryReport?>> enquiryReport() {
    return ref.read(reportsRepositoryProvider).enquiryReport();
  }

  Future<Result<EnquiryReport?>> enquiryReportBreakup() {
    return ref.read(reportsRepositoryProvider).enquiryReportBreakup();
  }

  Future<Result<ConversionRatioReport?>> conversionRatioReport() {
    return ref.read(reportsRepositoryProvider).conversionRatioReport();
  }

  Future<Result<ConversionRatioReport?>> conversionRatioReportBreakup() {
    return ref.read(reportsRepositoryProvider).conversionRatioReportBreakup();
  }

  Future<Result<LeadAgingReport?>> leadsAgingReport() {
    return ref.read(reportsRepositoryProvider).leadsAgingReport();
  }

  Future<Result<EprVsRegisteredReport?>> eprVsRegisteredReport() {
    return ref.read(reportsRepositoryProvider).eprVsRegisteredReport();
  }

  Future<Result<FollowupsReport?>> followupsReport() {
    return ref.read(reportsRepositoryProvider).followupsReport();
  }
}

final reportsLoaderProvider = StateProvider<ReportsLoader>(
  (ref) => ReportsLoader.empty(),
);
