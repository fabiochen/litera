import 'package:litera/baseReport.dart';
import 'package:flutter/material.dart';

class ReportSyllableSound2Text extends BaseReport {
  @override
  _ReportSyllableSound2TextState createState() => _ReportSyllableSound2TextState();
}

class _ReportSyllableSound2TextState extends BaseReportState<ReportSyllableSound2Text> {

  @override
  Text getMainText(double fontSize) {
    return super.getMainText(25);
  }
}
