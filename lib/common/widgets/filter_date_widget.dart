import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class FilterDateWidget extends SalesdocketConsumerStatefulWidget {
  final String? fromHeader;
  final String? fromDate;
  final String? toHeader;
  final String? toDate;
  final DateTime? minTime;
  final Function(String)? onFromDateChanged;
  final Function(String)? onToDateChanged;
  final String format;
  final String visibleFormat;
  final CupertinoDatePickerMode? mode;

  const FilterDateWidget({
    super.key,
    this.fromDate,
    this.fromHeader,
    this.minTime,
    this.onFromDateChanged,
    this.toDate,
    this.toHeader,
    this.onToDateChanged,
    this.format = 'dd-MM-yyyy',
    this.visibleFormat = 'dd-MM-yyyy',
    this.mode,
  });

  @override
  SalesdocketConsumerState<FilterDateWidget> createState() =>
      _FilterDateWidgetState();
}

class _FilterDateWidgetState
    extends SalesdocketConsumerState<FilterDateWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    // Initialize dates from widget properties
    _fromDate =
        widget.fromDate != null && widget.fromDate!.isNotEmpty
            ? DateFormat(widget.format).parse(widget.fromDate!)
            : null;
    _toDate =
        widget.toDate != null && widget.toDate!.isNotEmpty
            ? DateFormat(widget.format).parse(widget.toDate!)
            : null;
  }

  @override
  void didUpdateWidget(FilterDateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync local state when parent widget properties change
    if (widget.fromDate != oldWidget.fromDate) {
      _fromDate =
          widget.fromDate != null && widget.fromDate!.isNotEmpty
              ? DateFormat(widget.format).parse(widget.fromDate!)
              : null;
    }
    if (widget.toDate != oldWidget.toDate) {
      _toDate =
          widget.toDate != null && widget.toDate!.isNotEmpty
              ? DateFormat(widget.format).parse(widget.toDate!)
              : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.onFromDateChanged != null)
          Padding(
            padding: EdgeInsets.only(top: 2.25.h),
            child: _dateFromWidget(context),
          ),
        if (widget.onToDateChanged != null)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: _dateToWidget(context),
          ),
      ],
    );
  }

  Widget _dateFromWidget(BuildContext context) {
    return Column(
      spacing: 1.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fromHeader ?? LocaleKeys.lblDateFrom.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            SalesdocketTimePickerSpinnerPopUp(
              minTime: widget.minTime,
              maxTime: _toDate,
              mode: widget.mode ?? CupertinoDatePickerMode.date,
              timeFormat: widget.visibleFormat,
              initTime: _fromDate,
              onChange: (newDate) {
                setState(() {
                  _fromDate = newDate;
                });
                if (widget.onFromDateChanged != null) {
                  widget.onFromDateChanged!(
                    newDate.formatDateTime(format: widget.format),
                  );
                }
                // If toDate is before new fromDate, reset toDate
                if (_toDate != null && _toDate!.isBefore(newDate)) {
                  setState(() {
                    _toDate = null;
                  });
                  if (widget.onToDateChanged != null) {
                    widget.onToDateChanged!('');
                  }
                }
              },
            ),
            if (_fromDate != null)
              Positioned(
                right: 3.w,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _fromDate = null;
                    });
                    if (widget.onFromDateChanged != null) {
                      widget.onFromDateChanged!('');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColors.textSecondary.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 4.w,
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _dateToWidget(BuildContext context) {
    return Column(
      spacing: 1.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.toHeader ?? LocaleKeys.lblDateTo.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            SalesdocketTimePickerSpinnerPopUp(
              minTime: _fromDate ?? widget.minTime ?? DateTime.now(),
              mode: widget.mode ?? CupertinoDatePickerMode.date,
              initTime: _toDate,
              timeFormat: widget.visibleFormat,
              onChange: (newDate) {
                setState(() {
                  _toDate = newDate;
                });
                if (widget.onToDateChanged != null) {
                  widget.onToDateChanged!(
                    newDate.formatDateTime(format: widget.format),
                  );
                }
              },
            ),
            if (_toDate != null)
              Positioned(
                right: 3.w,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _toDate = null;
                    });
                    if (widget.onToDateChanged != null) {
                      widget.onToDateChanged!('');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColors.textSecondary.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 4.w,
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
