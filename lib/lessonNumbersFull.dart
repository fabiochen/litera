import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonNumbersFull extends BaseModule {
  @override
  _LessonNumbersFullState createState() => _LessonNumbersFullState();
}

class _LessonNumbersFullState extends BaseModuleState<LessonNumbersFull> {

  // list sort criteria
  Comparator<Word> criteria = (a, b) => a.value.compareTo(b.value);

  Widget getMainTile() {
    Word word = listProcess[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getTextTile(word),
        getText(word), // words
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
          fontSize: 60,
          color: Colors.teal,
        )
    );
  }

}