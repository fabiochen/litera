import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonWordAndNumber extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonWordAndNumber> {

  Widget getMainTile() {
    Word word = listProcess[listPosition] as Word;
    audioPlay(word.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getTextTile(word, 100, Colors.deepOrange),
        getText(word.title,60), // words
      ],
    );
  }

}