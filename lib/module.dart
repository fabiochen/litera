import 'package:litera/globals.dart';

class Module {
  var id;
  String title;
  ModuleType type;
  Year year;
  Subject subject;
  String routeName;
  Object args;

  Module(var this.id, String this.title, ModuleType this.type, Year this.year, Subject this.subject, [String this.routeName, Object this.args]);

  Object get arguments {
    return args;
  }

}