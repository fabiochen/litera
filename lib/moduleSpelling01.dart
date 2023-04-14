import 'package:flutter/material.dart';

import 'package:litera/baseMatchCharacter.dart';

class ModuleSpelling01 extends BaseMatchCharacter {
  @override
  _ModuleSpelling01State createState() => _ModuleSpelling01State();
}

class _ModuleSpelling01State extends BaseMatchCharacterState<ModuleSpelling01> {

  double aspectRatioBig = 1;
  double aspectRatioSmall = 1;
  int crossAxisCount = 6;

  @override
  List<Flexible> getMainChildren() {
    return [
      Flexible(
        flex: 2,
        child: getImageTile(wordMain.id)
      ), // image
    ] + super.getMainChildren();
  }

}
