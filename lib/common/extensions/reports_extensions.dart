import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/chart_data.dart';
import 'package:salesdocket_mobile/common/entity/reports.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

extension DeliveredReportExtension on DeliveredReport {
  ReportCardItem get reportCardItem {
    final details = delivered?.firstOrNull;

    return ReportCardItem(
      today: details?.ftdCount ?? '0',
      mtdValue: details?.ftmCount ?? '0',
      mtdChange: details?.mtdGrowthPercentage.onePlaceFixedValue ?? "0",
      ytdValue: details?.ytdCount ?? '0',
      ytdChange: details?.ytdGrowthPercentage.onePlaceFixedValue ?? "0",
    );
  }

  List<ReportTableData> get tableData {
    final data = <ReportTableData>[];

    for (var breakup in (deliveredBreakup ?? <Delivered>[])) {
      data.add(
        ReportTableData(
          header: breakup.roleOrDesignationName ?? '',
          today: breakup.todayCount ?? '0',
          mtd: breakup.mtdFtmCount ?? '0',
          ytd: breakup.ytdCount ?? '0',
          cellType: 2,
        ),
      );

      final subTableItems = (breakup.deliverySubBreakup ?? []).map(
        (subData) => ReportTableData(
          header: subData.roleOrDesignationName ?? '',
          today: subData.todayCount ?? '0',
          mtd: subData.mtdFtmCount ?? '0',
          ytd: subData.ytdCount ?? '0',
          cellType: 3,
        ),
      );

      data.addAll(subTableItems);
    }

    return data;
  }
}

extension EnquiryReportExtension on EnquiryReport {
  ReportCardItem get reportCardItem {
    final details = enquiry?.firstOrNull;

    return ReportCardItem(
      today: details?.ftdCount ?? '0',
      mtdValue: details?.ftmCount ?? '0',
      mtdChange: details?.mtdGrowthPercentage.onePlaceFixedValue ?? "0",
      ytdValue: details?.ytdCount ?? '0',
      ytdChange: details?.ytdGrowthPercentage.onePlaceFixedValue ?? "0",
    );
  }

  List<ReportTableData> get tableData {
    final data = <ReportTableData>[];

    for (var breakup in (enquiryBreakup ?? <Enquiry>[])) {
      data.add(
        ReportTableData(
          header: breakup.roleOrDesignationName ?? '',
          today: breakup.todayCount ?? '0',
          mtd: breakup.mtdFtmCount ?? '0',
          ytd: breakup.ytdCount ?? '0',
          cellType: 2,
        ),
      );

      final subTableItems = (breakup.enquirySubBreakup ?? []).map(
        (subData) => ReportTableData(
          header: subData.roleOrDesignationName ?? '',
          today: subData.todayCount ?? '0',
          mtd: subData.mtdFtmCount ?? '0',
          ytd: subData.ytdCount ?? '0',
          cellType: 3,
        ),
      );

      data.addAll(subTableItems);
    }

    return data;
  }
}

extension ConversionRatioReportExtension on ConversionRatioReport {
  ReportCardItem get reportCardItem {
    final details = conversionRatio?.firstOrNull;

    return ReportCardItem(
      today: details?.ftdCount.onePlaceFixedValue ?? "0",
      mtdValue: details?.ftmCount ?? '0',
      mtdChange: details?.mtdGrowthPercentage.onePlaceFixedValue ?? "0",
      ytdValue: details?.ytdCount ?? '0',
      ytdChange: details?.ytdGrowthPercentage.onePlaceFixedValue ?? "0",
    );
  }

  List<ReportTableData> get tableData {
    final data = <ReportTableData>[];

    for (var breakup in (conversionRatioBreakup ?? <ConversionRatio>[])) {
      data.add(
        ReportTableData(
          header: breakup.roleOrDesignationName ?? '',
          today: breakup.todayCount.onePlaceFixedValue,
          mtd: breakup.mtdFtmCount.onePlaceFixedValue,
          ytd: breakup.ytdCount.onePlaceFixedValue,
          cellType: 2,
        ),
      );

      final subTableItems = (breakup.conversionRatioSubBreakup ?? []).map(
        (subData) => ReportTableData(
          header: subData.roleOrDesignationName ?? '',
          today: subData.todayCount.onePlaceFixedValue,
          mtd: subData.mtdFtmCount.onePlaceFixedValue,
          ytd: subData.ytdCount.onePlaceFixedValue,
          cellType: 3,
        ),
      );

      data.addAll(subTableItems);
    }

    return data;
  }
}

extension EprVsRegisteredExtension on EprVsRegistered {
  double get eprProgress {
    return double.tryParse(eprPercentage ?? "0") ?? 0.0;
  }
}

extension FollowupsExtension on Followups {
  List<ChartData> get chartData {
    final appColors = UiComponentManager().appColors;
    return [
      ChartData(
        '${zeroFollowupCount ?? 0}',
        double.tryParse(zeroFollowupCount ?? "0") ?? 0,
        color: appColors.error,
        subtitle: "0 ${LocaleKeys.follow_ups.tr()}",
      ),
      ChartData(
        '${oneFollowupCount ?? 0}',
        double.tryParse(oneFollowupCount ?? "0") ?? 0,
        color: appColors.warning,
        subtitle: "1 ${LocaleKeys.follow_ups.tr()}",
      ),
      ChartData(
        '${twoFollowupCount ?? 0}',
        double.tryParse(twoFollowupCount ?? "0") ?? 0,
        color: appColors.blueMedium,
        subtitle: "2 ${LocaleKeys.follow_ups.tr()}",
      ),
      ChartData(
        '${threeFollowupCount ?? 0}',
        double.tryParse(threeFollowupCount ?? "0") ?? 0,
        color: appColors.info,
        subtitle: "3 ${LocaleKeys.follow_ups.tr()}",
      ),
      ChartData(
        '${gtThreeFollowupCount ?? 0}',
        double.tryParse(gtThreeFollowupCount ?? "0") ?? 0,
        color: appColors.success,
        subtitle: ">3 ${LocaleKeys.follow_ups.tr()}",
      ),
    ];
  }
}
