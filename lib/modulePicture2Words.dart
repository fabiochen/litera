import 'package:flutter/material.dart';
import 'globals.dart';

import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ModulePicture2Words extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModulePicture2Words> {

  @override
  Widget getCenterTile(word) {
    return getImageTile(word.id);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    String text = word.title;
    switch (optionFieldType) {
      case FieldType.VAL3:
        text = Globals().getWordFromId(int.parse(word.val3)).title;
        break;
      default:
        text = word.title;
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: optionFontSize,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

}
