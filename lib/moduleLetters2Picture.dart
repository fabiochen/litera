import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';

class ModuleLetters2Picture extends BaseOptionTiles {
  @override
  _ModuleLetters2PictureState createState() => _ModuleLetters2PictureState();
}

class _ModuleLetters2PictureState extends BaseOptionTilesState<ModuleLetters2Picture> {

  Widget getMainTile() {
    // listProcess.shuffle();
    // wordMain = listProcess[Random().nextInt(4)];
    listProcess.shuffle();
    listProcess.sort((a, b) => (a as Word).processed?1:0);
    int i= Random().nextInt(4);
    wordMain = listProcess[i] as Word;
    wordMain.processed = true;
    listProcess[i] = wordMain;
    return super.getMainTile();
  }

  @override
  Widget getOptionValue(Word word) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title.substring(0,1),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 50,
        ),
      ),
    );
  }

}