import 'dart:math';
import 'package:flutter/material.dart';

import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleWords2Picture extends BaseOptionTiles {
  @override
  _ModuleWords2PictureState createState() => _ModuleWords2PictureState();
}

class _ModuleWords2PictureState extends BaseOptionTilesState<ModuleWords2Picture> {

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    listProcess.sort((a, b) => (a as Word).processed?1:0);
    int i= Random().nextInt(4);
    wordMain = listProcess[i] as Word;
    wordMain.processed = true;
    listProcess[i] = wordMain;
    return super.getMainTile();
  }

  @override
  Widget getCenterTile(word) {
    return getImageTile(word.id);
  }

  @override
  ButtonTheme getOptionTile(Word wordOption, [double _width=150, double _height=100]) {
    return super.getOptionTile(wordOption,200);
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
          fontSize: 30,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

}
