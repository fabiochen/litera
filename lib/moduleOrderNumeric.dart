import 'package:litera/baseMatchCharacter.dart';
import 'package:litera/globals.dart';

class ModuleOrderNumeric extends BaseMatchCharacter {
  @override
  _ModuleOrderNumericState createState() => _ModuleOrderNumericState();
}

class _ModuleOrderNumericState extends BaseMatchCharacterState<ModuleOrderNumeric> {

  double aspectRatioBig = 1.0;
  double aspectRatioSmall = 1.5;

  @override
  void next() {
    if (isEndPosition && mode == 'test') {
      expandedId = 3;
      prefs.setInt('expandedId',3);
    }
    super.next();
  }

}