import 'package:litera/baseMatchCharacter.dart';

class ModuleOrder extends BaseMatchCharacter {
  @override
  _ModuleOrderState createState() => _ModuleOrderState();
}

class _ModuleOrderState extends BaseMatchCharacterState<ModuleOrder> {

  double aspectRatioBig = 1.0;
  double aspectRatioSmall = 1.5;

}