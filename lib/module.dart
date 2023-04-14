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
  bool loop;
  List<int>? misc;

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
        bool this.loop = false,
        List<int>? this.misc,
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
    args!['loop'] = this.loop;
    if (this.misc != null) args!['misc'] = this.misc as List<int>;
    return args;
  }

}