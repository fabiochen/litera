import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
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
        Flexible(child: getImageTile(wordMain.id)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: getImageTile(wordMain.id+4000,imageSize: 100)),
            Flexible(child: getOnsetTile(wordMain, imageSize: 100))
          ],
        ),
      ],
    );
  }

  @override
  String getMainLabel(text) {
    return text.substring(0,1).toUpperCase() + ' ' + text.substring(0,1);
  }

}
