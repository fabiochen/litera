import 'package:flutter/material.dart';
import 'package:litera/globals.dart';

class Module {
  int pos;
  String title;
  ModuleType type;
  Yr year;
  Sub subject;
  String routeName;
  List<Object>? list;
  bool isVisibleTarget;
  int? numberQuestions;
  bool useNavigation;
  Map<String,Object>? args = {};
  String fontFamily;
  late double fontSizeMain;
  late double fontSizeOption;
  double widthMain;
  double heightMain;
  double widthOption;
  double heightOption;
  Color colorMain;
  Color colorOption;
  bool containsAudio;
  bool loop;
  bool noLock;
  Object? fieldTypeMain;
  Object? fieldTypeOption;
  Object? sortCriteria;

  Module(
      int this.pos,
      String this.title,
      ModuleType this.type,
      Yr this.year,
      Sub this.subject,
      List<Object>? this.list,
      String this.routeName,
      {
        bool this.isVisibleTarget = false,
        int? this.numberQuestions,
        bool this.useNavigation = true,
        String this.fontFamily = "Litera-Regular",

        double this.fontSizeMain = 50,
        double this.fontSizeOption = 100,
        Color this.colorMain = Colors.teal,
        Color this.colorOption = Colors.teal,
        double this.widthMain = 250,
        double this.heightMain = 100,
        double this.widthOption = 200,
        double this.heightOption = 100,
        Object? this.fieldTypeMain,
        Object? this.fieldTypeOption,
        Object? this.sortCriteria,

        bool this.loop = false,
        bool this.containsAudio = true,
        bool this.noLock = false,
      }
  );

  Map<String,Object>? get arguments {
    args!['modulePos'] = this.pos;
    args!['title'] = this.title;
    args!['type'] = this.type;
    args!['year'] = this.year.index;
    args!['subject'] = this.subject.index;
    args!['list'] = this.list as Object;
    args!['isVisibleTarget'] = this.isVisibleTarget;
    if (this.numberQuestions != null) args!['numberQuestions'] = this.numberQuestions as Object;
    args!['useNavigation'] = this.useNavigation;
    args!['fontFamily'] = this.fontFamily;

    args!['fontSizeMain'] = this.fontSizeMain;
    args!['fontSizeOption'] = this.fontSizeOption;
    args!['colorMain'] = this.colorMain;
    args!['colorOption'] = this.colorOption;
    args!['widthMain'] = this.widthMain;
    args!['heightMain'] = this.heightMain;
    args!['widthOption'] = this.widthOption;
    args!['heightOption'] = this.heightOption;
    if (this.fieldTypeMain != null) args!['fieldTypeMain'] = this.fieldTypeMain as Object;
    if (this.fieldTypeOption != null) args!['fieldTypeOption'] = this.fieldTypeOption as Object;
    if (this.sortCriteria != null) args!['sortCriteria'] = this.sortCriteria as Object;

    args!['loop'] = this.loop;
    args!['containsAudio'] = this.containsAudio;
    args!['noLock'] = this.noLock;
    return args;
  }

}