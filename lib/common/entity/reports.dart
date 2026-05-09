class ReportCardItem {
  final String? today;
  final String? mtdValue;
  final String? mtdChange;
  final String? ytdValue;
  final String? ytdChange;

  ReportCardItem({
    this.today,
    this.mtdChange,
    this.mtdValue,
    this.ytdValue,
    this.ytdChange,
  });
}

class ReportTableData {
  final String? header;
  final String? today;
  final String? mtd;
  final String? ytd;
  final int cellType;

  ReportTableData({
    this.header,
    this.today,
    this.mtd,
    this.ytd,
    this.cellType = 1,
  });
}
