import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class LessonNumbers extends BaseModule {
  @override
  _LessonNumbersState createState() => _LessonNumbersState();
}

class _LessonNumbersState extends BaseModuleState<LessonNumbers> {

  // list sort criteria
  Comparator<Object> criteria = (a, b) => ((a as Word).id).compareTo((b as Word).id);

  Widget getMainTile() {
    Word word = listProcess[listPosition] as Word;
    audioPlay(word.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(word.id), // image
        getText(word.title,70), // words
      ],
    );
  }

  // Text getText(Word word) {
  //   audioPlay(word.id);
  //   return Text(
  //       getText(word.value),
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: 80,
  //         color: Colors.teal,
  //       )
  //   );
  // }
  //
}