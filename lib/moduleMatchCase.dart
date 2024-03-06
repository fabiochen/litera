import 'package:litera/baseMatchCharacter.dart';
import 'package:litera/globals.dart';

class ModuleMatchCase extends BaseMatchCharacter {
  @override
  _ModuleMatchCaseState createState() => _ModuleMatchCaseState();
}

class _ModuleMatchCaseState extends BaseMatchCharacterState<ModuleMatchCase> {

  @override
  double aspectRatioBig = 1.0;
  @override
  double aspectRatioSmall = 1.5;

  @override
  void next([bool refresh=true]) {
    if (isEndPosition && type == 'test') {
      Globals().expandedId[yearIndex] = Sub.MATH.index;
      Globals().prefs.setInt('expandedId-$yearIndex',Sub.MATH.index);
    }
    super.next(refresh);
  }

}