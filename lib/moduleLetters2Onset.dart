import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';

import 'dart:math';

class ModuleLetters2Onset extends BaseOptionTiles {
  @override
  _ModuleLetters2OnsetState createState() => _ModuleLetters2OnsetState();
}

class _ModuleLetters2OnsetState extends BaseOptionTilesState<ModuleLetters2Onset> {

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    listProcess.sort((a, b) => (a as Word).processed?1:0);
    int i= Random().nextInt(4);
    wordMain = listProcess[i] as Word;
    wordMain.processed = true;
    listProcess[i] = wordMain;
    audioPlay(wordMain.id);
    return super.getMainTile();
  }

  @override
  Widget getCenterTile() {
    return getOnsetTile(wordMain);
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
