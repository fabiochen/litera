import 'package:litera/globals.dart';

class Module {
  int pos;
  String title;
  ModuleType type;
  Yr year;
  Sub subject;
  String routeName;
  List<Object>? list;
  Map<String,Object> args = <String,Object>{};

  Module(
      var this.pos,
      String this.title,
      ModuleType this.type,
      Yr this.year,
      Sub this.subject,
      List<Object>? this.list,
      String this.routeName,
      [Object? args]
  );

  Map<String,Object> get arguments {
    args['modulePos'] = this.pos;
    args['title'] = this.title;
    args['type'] = this.type;
    args['year'] = this.year.index;
    args['subject'] = this.subject.index;
    args['list'] = this.list as Object;
    return args;
  }

}