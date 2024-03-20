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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: getImageTile(
          word.id,
          borderColor: optionColors[listPosition%10]!,
        )), // image
        Text(
          word.val1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: mainFontSize,
            fontFamily: 'mynerve',
            shadows: <Shadow>[
              Shadow(
                offset: Offset(3,3),
                blurRadius: 3.0,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }


  
}