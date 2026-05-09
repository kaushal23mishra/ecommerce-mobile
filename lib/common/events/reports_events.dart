import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/features/reports/view_model/reports_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin ReportsEvents on UiComponentWidget {
  Future deliveredReport() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(delivery: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .deliveredReport();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(delivery: false));
        onDeliveryReportFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(delivery: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future deliveredReportBreakup() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(deliveryBreakups: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .deliveredReportBreakup();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(deliveryBreakups: false));
        onDeliveryReportBreakupFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(deliveryBreakups: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future enquiryReport() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(enquiry: true));

    final result =
        await eventRef.read(reportsViewModelProvider.notifier).enquiryReport();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(enquiry: false));
        onEnquiryReportFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(enquiry: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future enquiryReportBreakup() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(enquiryBreakups: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .enquiryReportBreakup();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(enquiryBreakups: false));
        onEnquiryReportBreakupFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(enquiryBreakups: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future conversionRatioReport() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(conversionRatio: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .conversionRatioReport();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(conversionRatio: false));
        onConversionRatioReportFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(conversionRatio: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future conversionRatioReportBreakup() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update(
          (state) => state = state.copyWith(conversionRatioBreakups: true),
        );

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .conversionRatioReportBreakup();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update(
              (state) => state = state.copyWith(conversionRatioBreakups: false),
            );
        onConversionRatioReportBreakupFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update(
              (state) => state = state.copyWith(conversionRatioBreakups: false),
            );
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future leadsAgingReport() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(leadsAging: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .leadsAgingReport();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(leadsAging: false));
        onLeadAgingReportFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(leadsAging: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future eprVsRegisteredReport() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(eprVsRegistered: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .eprVsRegisteredReport();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(eprVsRegistered: false));
        onEprVsRegisteredReportFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(eprVsRegistered: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future followupsReport() async {
    eventRef
        .read(reportsLoaderProvider.notifier)
        .update((state) => state = state.copyWith(followups: true));

    final result =
        await eventRef
            .read(reportsViewModelProvider.notifier)
            .followupsReport();
    if (!isMounted) return;

    result.when(
      success: (data) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(followups: false));
        onFollowupsReportFetched(data);
      },
      failure: (error) {
        eventRef
            .read(reportsLoaderProvider.notifier)
            .update((state) => state = state.copyWith(followups: false));
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onDeliveryReportFetched(DeliveredReport? report) {}

  void onDeliveryReportBreakupFetched(DeliveredReport? report) {}

  void onEnquiryReportFetched(EnquiryReport? report) {}

  void onEnquiryReportBreakupFetched(EnquiryReport? report) {}

  void onConversionRatioReportFetched(ConversionRatioReport? report) {}

  void onConversionRatioReportBreakupFetched(ConversionRatioReport? report) {}

  void onLeadAgingReportFetched(LeadAgingReport? report) {}

  void onEprVsRegisteredReportFetched(EprVsRegisteredReport? report) {}

  void onFollowupsReportFetched(FollowupsReport? report) {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
