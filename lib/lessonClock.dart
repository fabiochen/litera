import 'package:flutter/material.dart';

import 'baseModule.dart';
import 'word.dart';
import 'globals.dart';

class LessonClock extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonClock> {

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    playTime(wordMain.title);
    return Globals().getClock(wordMain.title,20);
  }

}