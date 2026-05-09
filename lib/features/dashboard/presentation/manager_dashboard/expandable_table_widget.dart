import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/reports.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExpandableTableSection extends SalesdocketStatefulWidget {
  final bool isExpanded;
  final Function onExpandChanged;
  final bool isLoading;
  final List<ReportTableData> tableData;

  const ExpandableTableSection({
    super.key,
    required this.isExpanded,
    required this.onExpandChanged,
    required this.tableData,
    this.isLoading = false,
  });

  @override
  State<ExpandableTableSection> createState() => _ExpandableTableSectionState();
}

class _ExpandableTableSectionState
    extends SalesdocketState<ExpandableTableSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return const ExpandableTableShimmerWidget();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(1.5.h),
        GestureDetector(
          onTap: () {
            widget.onExpandChanged(!widget.isExpanded);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isExpanded
                    ? LocaleKeys.hideDetails.tr()
                    : LocaleKeys.lblShowMoreDetails.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: appColors.textDisabled,
                ),
              ),
              horizontalSpacing(2.w),
              Icon(
                widget.isExpanded ? Icons.remove_circle : Icons.add_circle,
                color: appColors.textDisabled,
                size: 5.w,
              ),
            ],
          ),
        ),
        if (widget.isExpanded)
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: Table(
              border: TableBorder.all(color: appColors.grayMedium.withValues(alpha: 0.5), width: 0.2.w),
              children: [_buildTableHeaders, ..._buildTableRows],
            ),
          ),
      ],
    );
  }

  TableRow get _buildTableHeaders {
    return TableRow(
      children: [
        _buildTableCell('', isFirst: true),
        _buildTableCell(LocaleKeys.today.tr(), cellType: 1),
        _buildTableCell(LocaleKeys.mtd.tr(), cellType: 1),
        _buildTableCell(LocaleKeys.ytd.tr(), cellType: 1),
      ],
    );
  }

  List<TableRow> get _buildTableRows {
    return widget.tableData
        .asMap()
        .entries
        .map(
          (entry) => _buildTableRow(
            rowData: [
              entry.value.header ?? "",
              entry.value.today ?? "",
              entry.value.mtd ?? "",
              entry.value.ytd ?? "",
            ],
            cellType: entry.value.cellType,
            isEven: entry.key.isEven,
          ),
        )
        .toList();
  }

  TableRow _buildTableRow({
    List<String> rowData = const [],
    int cellType = 1,
    bool isEven = false,
  }) {
    return TableRow(
      children:
          rowData
              .asMap()
              .entries
              .map(
                (entry) => _buildTableCell(
                  entry.value,
                  cellType: cellType,
                  isFirst: entry.key == 0,
                  isEven: isEven,
                ),
              )
              .toList(),
    );
  }

  TableCell _buildTableCell(
    String content, {
    int cellType = 1,
    bool isFirst = false,
    bool isEven = false,
  }) {
    // cellType == 1: Header
    // cellType == 2: Total/Summary
    // default: Normal row
    final bool isHeader = cellType == 1;

    return TableCell(
      verticalAlignment:
          isFirst
              ? TableCellVerticalAlignment.middle
              : TableCellVerticalAlignment.fill,
      child: Container(
        alignment: Alignment.center,
        color:
            isHeader
                ? Colors.black
                : (cellType == 2
                    ? appColors.grayMedium.withValues(alpha: 0.2)
                    : (isEven ? Colors.white : appColors.grayLight)),
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isHeader ? Colors.white : appColors.textPrimary,
            fontWeight: isHeader || cellType == 2 ? FontWeight.w700 : FontWeight.normal,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ExpandableTableShimmerWidget extends SalesdocketStatelessWidget {
  const ExpandableTableShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpacing(1.5.h),
        SalesDocketShimmerWidget.rectangular(height: 2.4.h, width: 40.w),
      ],
    );
  }
}
