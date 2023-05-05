import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class LessonLetters extends BaseModule {
  @override
  _LessonLettersState createState() => _LessonLettersState();
}

class _LessonLettersState extends BaseModuleState<LessonLetters> {

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getMainText(wordMain, 100), // letter
        getSoundTile(wordMain)
      ],
    );
  }

  @override
  String getMainLabel(text) {
    return text.substring(0,1).toUpperCase() + " " + text.substring(0,1).toLowerCase();
  }

}
