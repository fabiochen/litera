import 'package:litera/baseMatchCharacter.dart';

class ModuleOrderNumeric extends BaseMatchCharacter {
  @override
  _ModuleOrderNumericState createState() => _ModuleOrderNumericState();
}

class _ModuleOrderNumericState extends BaseMatchCharacterState<ModuleOrderNumeric> {

  double aspectRatioBig = 1.0;
  double aspectRatioSmall = 1.5;

}