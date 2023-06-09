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
        getImageTile(wordMain.id), // image
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: getMainText(wordMain,60),
            ), // letter
            getOnsetTile(wordMain), // image
          ],
        )
      ],
    );
  }

  @override
  String getMainLabel(text) {
    return text.substring(0,1).toUpperCase() + ' ' + text.substring(0,1);
  }

}
