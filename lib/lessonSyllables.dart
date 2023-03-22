import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonSyllables extends BaseModule {
  @override
  _LessonSyllablesState createState() => _LessonSyllablesState();
}

class _LessonSyllablesState extends BaseModuleState<LessonSyllables> {

  // list sort criteria
  Comparator<Word> criteria = (a, b) => a.id.compareTo(b.id);

  Widget getMainTile() {
    wordMain = listProcess[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getText(wordMain), // words
        getSoundTile(wordMain)
      ],
    );
  }

  String getTextValue(Word word) {
    audioPlay(word.id);
    return word.title;
  }

  Text getText(Word word) {
    return Text(
        getTextValue(word),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 80,
          color: Colors.teal,
        )
    );
  }

  void next() {
    if (isEndPosition) {
      moduleIndex++;
      if (moduleIndex > getUnlockModuleIndex(year, subject))
        setUnlockModuleIndex(moduleIndex);
      moduleIndex++;
      if (moduleIndex > getUnlockModuleIndex(year, subject))
        setUnlockModuleIndex(moduleIndex);
    }
    super.next();
  }
}