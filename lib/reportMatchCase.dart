import 'package:litera/baseReport.dart';
import 'package:litera/word.dart';

class ReportMatchCase extends BaseReport {
  @override
  _ReportMatchCaseState createState() => _ReportMatchCaseState();
}

class _ReportMatchCaseState extends BaseReportState<ReportMatchCase> {

  Comparator<Object> criteria = (a, b) => (a as Word).title.compareTo((b as Word).title);

}
