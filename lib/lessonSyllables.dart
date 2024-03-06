import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class LessonSyllables extends BaseModule {
  @override
  _LessonSyllablesState createState() => _LessonSyllablesState();
}

class _LessonSyllablesState extends BaseModuleState<LessonSyllables> {

  // list sort criteria
  Comparator<Object> criteria = (a, b) => ((a as Word).id).compareTo((b as Word).id);

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getTextTile(
          wordMain,
          fontSize: 100,
          fontColor: Colors.teal,
          backgroundColor: optionColors[listPosition%10],
        ),
      ],
    );
  }

  String getTextValue(Word word) {
    audioPlay(word.id);
    return word.title;
  }

}