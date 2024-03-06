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
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getImageTile(wordMain.id,
          borderColor: optionColors[listPosition%10]!,
        ),
        getOnsetTile(wordMain)
      ],
    );
  }

}
