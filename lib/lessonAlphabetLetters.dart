import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class LessonAlphabetLetters extends BaseModule {
  @override
  _LessonAlphabetLettersState createState() => _LessonAlphabetLettersState();
}

class _LessonAlphabetLettersState extends BaseModuleState<LessonAlphabetLetters> {

  Comparator<Object> criteria = (a, b) => (a as Word).title.compareTo((b as Word).title);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.sort(criteria);
  }

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getMainText(100, "Maria_lucia"), // letter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getSoundTile(wordMain),
            getOnsetTile(wordMain)
          ],
        ),
      ],
    );
  }

  @override
  String getMainLabel() {
    audioPlay(wordMain.id);
    return wordMain.title.substring(0,1).toUpperCase() + ' ' + wordMain.title.substring(0,1);
  }

}
