import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class ModuleSyllableOnset2Text extends BaseOptionTiles {
  @override
  _ModuleSyllableOnset2TextState createState() => _ModuleSyllableOnset2TextState();
}

class _ModuleSyllableOnset2TextState extends BaseOptionTilesState<ModuleSyllableOnset2Text> {

  Widget getCenterTile() {
    audioPlay(wordMain.id);
    return getSoundTile(wordMain);
  }

  @override
  Widget getOptionValue(Word word) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
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