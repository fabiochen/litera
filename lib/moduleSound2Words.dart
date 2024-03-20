import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ModuleSound2Words extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleSound2Words> {

  Widget getCenterTile(word) {
    audioPlay(word.id);
    return getSoundTile(word);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    debugPrint("baseOptionValue: " + word.title);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AutoSizeText(
        word.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 50,
        ),
      ),
    );
  }

}