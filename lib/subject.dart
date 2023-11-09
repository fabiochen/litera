import 'package:flutter/cupertino.dart';
import 'package:litera/module.dart';
import 'package:litera/globals.dart';

class Subject {
  Sub id;
  String value;
  List<Module> modules;
  Image image;

  final PORTUGUESE = 0;

  Subject(Sub this.id, String this.value, List<Module> this.modules, this.image);

}