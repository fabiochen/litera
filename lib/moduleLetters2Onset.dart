import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';

class ModuleLetters2Onset extends BaseOptionTiles {
  @override
  _ModuleLetters2OnsetState createState() => _ModuleLetters2OnsetState();
}

class _ModuleLetters2OnsetState extends BaseOptionTilesState<ModuleLetters2Onset> {

  @override
  Widget getCenterTile(word) {
    audioPlay(word.id);
    return getOnsetTile(word);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
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
