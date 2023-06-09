import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class LessonImageText extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonImageText> {

  // list sort criteria
  Comparator<Object> criteria = (a, b) => ((a as Word).id).compareTo((b as Word).id);

  Widget getMainTile() {
    Word word = listProcess[listPosition] as Word;
    audioPlay(word.id);
    String text = Globals().getLabelFromFieldType(word, mainFieldType);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(word.id), // image
        getText(text,mainFontSize), // words
      ],
    );
  }
  
}