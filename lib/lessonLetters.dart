import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class LessonLetters extends BaseModule {
  @override
  _LessonLettersState createState() => _LessonLettersState();
}

class _LessonLettersState extends BaseModuleState<LessonLetters> {

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getMainText(100), // letter
        getOnsetTile(wordMain)
      ],
    );
  }

  @override
  String getMainLabel() {
    audioPlay(wordMain.id);
    return wordMain.title.substring(0,1).toUpperCase();
  }

}
