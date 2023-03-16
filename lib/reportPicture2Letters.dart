import 'package:litera/baseReport.dart';
import 'package:litera/word.dart';

class ReportPicture2Letters extends BaseReport {
  @override
  _ReportPicture2LettersState createState() => _ReportPicture2LettersState();
}

class _ReportPicture2LettersState extends BaseReportState<ReportPicture2Letters> {

  Comparator<Object> criteria = (a, b) => (a as Word).title.compareTo((b as Word).title);

}
