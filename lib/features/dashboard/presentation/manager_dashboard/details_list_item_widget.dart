import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/reports.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DetailsListItemWidget extends SalesdocketConsumerWidget {
  final String title;
  final bool isLoading;
  final ReportCardItem reportCardItem;

  const DetailsListItemWidget({
    super.key,
    required this.reportCardItem,
    required this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) return const DetailsItemShimmerWidget();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.active,
            borderRadius: BorderRadius.circular(1.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 3.w),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
          ),
        ),
        verticalSpacing(1.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.w,
            children: [
              _todayWidget(context),
              Expanded(flex: 4, child: _mtdWidget(context)),
              Expanded(flex: 4, child: _ytdWidget(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _todayWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          color: appColors.secondary,
          child: Text(
            LocaleKeys.today.tr(),
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
        verticalSpacing(0.5.h),
        Expanded(
          child: Container(
            constraints: BoxConstraints(minWidth: 24.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: appColors.active,
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                reportCardItem.today ?? "0",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: appColors.secondary,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mtdWidget(BuildContext context) {
    return _statsWidget(
      context,
      title: LocaleKeys.mtd.tr(),
      description: LocaleKeys.fromLastMonth.tr(),
      value: reportCardItem.mtdValue,
      change: reportCardItem.mtdChange,
    );
  }

  Widget _ytdWidget(BuildContext context) {
    return _statsWidget(
      context,
      title: LocaleKeys.ytd.tr(),
      description: LocaleKeys.fromLastYear.tr(),
      value: reportCardItem.ytdValue,
      change: reportCardItem.ytdChange,
    );
  }

  Widget _statsWidget(
    BuildContext context, {
    required String title,
    String? value,
    String? change,
    String? description,
  }) {
    final changeValue = double.tryParse(change ?? "") ?? 0;

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: appColors.textDisabled),
        ),
        verticalSpacing(0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.active,
            borderRadius: BorderRadius.circular(1.w),
          ),
          child: Column(
            children: [
              verticalSpacing(1.h),
              Container(
                constraints: BoxConstraints(minHeight: 4.h),
                child: FittedBox(
                  child: Text(
                    value ?? "--",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: appColors.secondary,
                      fontSize: 22.sp,
                    ),
                  ),
                ),
              ),
              verticalSpacing(1.h),
              Row(
                children: [
                  Container(
                    width: 1.5.w,
                    height: 5.h,
                    color:
                        changeValue == 0
                            ? appColors.secondary
                            : changeValue < 0
                            ? appColors.error
                            : appColors.success,
                  ),
                  Expanded(
                    child: Container(
                      height: 5.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      color: appColors.secondary,
                      child: FittedBox(
                        child: Text(
                          "${change ?? "0"}%",
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(
                            color:
                                changeValue == 0
                                    ? appColors.textDisabled
                                    : changeValue < 0
                                    ? appColors.error
                                    : appColors.success,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpacing(1.h),
              Text(
                description ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: appColors.secondary),
              ),
              verticalSpacing(1.h),
            ],
          ),
        ),
      ],
    );
  }
}

class DetailsItemShimmerWidget extends SalesdocketStatelessWidget {
  const DetailsItemShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketShimmerWidget.rectangular(height: 2.h, width: 24.w),
        verticalSpacing(2.h),
        Row(
          spacing: 2.w,
          children: List.generate(
            3,
            (_) => Expanded(
              child: Column(
                children: [
                  SalesDocketShimmerWidget.rectangular(
                    height: 2.h,
                    width: 20.w,
                  ),
                  verticalSpacing(0.5.h),
                  SalesDocketShimmerWidget.rectangular(
                    height: 12.h,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
