import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class LessonAlphabetCursive extends BaseModule {
  @override
  _LessonAlphabetCursiveState createState() => _LessonAlphabetCursiveState();
}

class _LessonAlphabetCursiveState extends BaseModuleState<LessonAlphabetCursive> {

  Comparator<Object> criteria = (a, b) => (a as Word).title.compareTo((b as Word).title);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.sort(criteria);
  }

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textBaseline: TextBaseline.alphabetic,
          children: [
            getMainText(wordMain, 60, fontFamily :  "Litera-Regular"),
            getMainText(wordMain, 60, fontFamily: "Maria_lucia", fontColor: Colors.red)
          ],
        ), // letter
        getSoundTile(wordMain),
      ],
    );
  }

  @override
  String getMainLabel(text) {
    return text.substring(0,1).toUpperCase() + ' ' + text.substring(0,1);
  }

}
