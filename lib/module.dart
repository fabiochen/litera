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

  Module(
      var this.pos,
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
        String this.fontFamily = "LiteraIcons"
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
    return args;
  }

}