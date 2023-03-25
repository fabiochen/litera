import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/subject.dart';

class Year {
  Yr id;
  String value;
  Color color;
  List<Subject> subjects;

  Year(Yr this.id, String this.value, Color this.color, List<Subject> this.subjects);

}