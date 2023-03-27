import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonNumbers extends BaseModule {
  @override
  _LessonNumbersState createState() => _LessonNumbersState();
}

class _LessonNumbersState extends BaseModuleState<LessonNumbers> {

  // list sort criteria
  Comparator<Word> criteria = (a, b) => a.value.compareTo(b.value);

  Widget getMainTile() {
    Word word = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(word.id), // image
        getText(word), // words
      ],
    );
  }

  String getTextValue(Word word) {
    audioPlay(word.id);
    return word.value;
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

}