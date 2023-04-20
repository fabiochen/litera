import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class LessonAlphabet extends BaseModule {
  @override
  _LessonAlphabetState createState() => _LessonAlphabetState();
}

class _LessonAlphabetState extends BaseModuleState<LessonAlphabet> {

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(wordMain.id), // image
        getMainText(wordMain,60), // letter
        getOnsetTile(wordMain), // image
      ],
    );
  }

  @override
  String getMainLabel(word) {
    audioPlay(word.id);
    return word.title.substring(0,1).toUpperCase() + ' ' + word.title.substring(0,1);
  }

}
