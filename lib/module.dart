import 'package:flutter/material.dart';
import 'package:litera/globals.dart';

class Module {
  int pos;
  String title;
  ModuleType type;
  Yr year;
  Sub subject;
  String routeName;
  List<Object>? list1;
  List<Object>? list2;
  bool isVisibleTarget;
  int? numberQuestions;
  bool useNavigation;
  bool useProgressBar;
  Map<String,Object>? args = {};
  String fontFamily;
  late double mainFontSize;
  late double optionFontSize;
  double mainWidth;
  double mainHeight;
  double optionWidth;
  double optionHeight;
  Color mainFontColor;
  Color optionFontColor;
  bool containsAudio;
  bool loop;
  bool noLock;
  Object? mainFieldType;
  Object? optionFieldType;
  Object? optionTileType;
  Object? sortCriteria;
  Object? misc;

  Module(
      int this.pos,
      String this.title,
      ModuleType this.type,
      Yr this.year,
      Sub this.subject,
      List<Object>? this.list1,
      String this.routeName,
      {
        List<Object>? this.list2,
        bool this.isVisibleTarget = false,
        int? this.numberQuestions,
        bool this.useNavigation = true,
        bool this.useProgressBar = true,
        String this.fontFamily = "Litera-Regular",

        double this.mainFontSize = 50,
        double this.optionFontSize = 100,
        Color this.mainFontColor = Colors.teal,
        Color this.optionFontColor = Colors.teal,
        double this.mainWidth = 250,
        double this.mainHeight = 100,
        double this.optionWidth = 200,
        double this.optionHeight = 100,
        Object? this.mainFieldType,
        Object? this.optionFieldType,
        Object? this.optionTileType,
        Object? this.sortCriteria,
        Object? this.misc,

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
    args!['list1'] = this.list1 as Object;
    if (this.list2 != null) args!['list2'] = this.list2 as Object;
    args!['isVisibleTarget'] = this.isVisibleTarget;
    if (this.numberQuestions != null) args!['numberQuestions'] = this.numberQuestions as Object;
    args!['useNavigation'] = this.useNavigation;
    args!['useProgressBar'] = this.useProgressBar;
    args!['fontFamily'] = this.fontFamily;

    args!['mainFontSize'] = this.mainFontSize;
    args!['optionFontSize'] = this.optionFontSize;
    args!['mainFontColor'] = this.mainFontColor;
    args!['optionFontColor'] = this.optionFontColor;
    args!['mainWidth'] = this.mainWidth;
    args!['mainHeight'] = this.mainHeight;
    args!['optionWidth'] = this.optionWidth;
    args!['optionHeight'] = this.optionHeight;
    if (this.mainFieldType != null) args!['mainFieldType'] = this.mainFieldType as Object;
    if (this.optionFieldType != null) args!['optionFieldType'] = this.optionFieldType as Object;
    if (this.optionTileType != null) args!['optionTileType'] = this.optionTileType as Object;
    if (this.sortCriteria != null) args!['sortCriteria'] = this.sortCriteria as Object;
    if (this.misc != null) args!['misc'] = this.misc as Object;

    args!['loop'] = this.loop;
    args!['containsAudio'] = this.containsAudio;
    args!['noLock'] = this.noLock;
    return args;
  }

}