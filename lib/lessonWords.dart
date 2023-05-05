import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class LessonWords extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonWords> {

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getText(wordMain.title,60), // words
        getSoundTile(wordMain)
      ],
    );
  }

  String getTextValue(Word word) {
    return word.title;
  }

}