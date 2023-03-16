import 'package:flutter/material.dart';

import 'package:litera/baseReport.dart';
import 'package:litera/word.dart';

class ReportNumbers2Picture extends BaseReport {
  @override
  _ReportNumbers2PictureState createState() => _ReportNumbers2PictureState();
}

class _ReportNumbers2PictureState extends BaseReportState<ReportNumbers2Picture> {

  @override
  Comparator<Object> criteria = (a, b) => (a as Word).id.compareTo((b as Word).id);

  @override
  String getMainLabel() {
    return wordMain.value;
  }

  @override
  Text getMainText(double fontSize) {
    return super.getMainText(15);
  }

}
