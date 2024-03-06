import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

import 'globals.dart';

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
        Row(
          children: [
            Flexible(child: getImageTile(wordMain.id, borderColor: optionColors[listPosition%10]!,)),
            Flexible(child: getImageTile(wordMain.id+4000)),
          ],
        ),
        getOnsetTile(wordMain)
      ],
    );
  }

  @override
  String getMainLabel(text) {
    return text.substring(0,1).toUpperCase() + ' ' + text.substring(0,1);
  }

}
