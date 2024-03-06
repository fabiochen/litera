import 'package:flutter/material.dart';

import 'baseModule.dart';
import 'word.dart';

import 'globals.dart';

class LessonWords extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonWords> {

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return getTextTile(
        wordMain, backgroundColor: optionColors[listPosition % 10]);
  }

}