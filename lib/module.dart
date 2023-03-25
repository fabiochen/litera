import 'package:litera/globals.dart';

class Module {
  int id;
  String title;
  ModuleType type;
  Yr year;
  Sub subject;
  String routeName;
  Map<String,Object> args;

  Module(var this.id, String this.title, ModuleType this.type, Yr this.year, Sub this.subject, String this.routeName, Map<String,Object> this.args);

  Map<String,Object> get arguments {
    args['type'] = this.type;
    return args;
  }

}