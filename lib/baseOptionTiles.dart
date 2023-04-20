import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class BaseOptionTiles extends BaseModule {
  @override
  BaseOptionTilesState createState() => BaseOptionTilesState();
}

class BaseOptionTilesState<T extends BaseOptionTiles> extends BaseModuleState<T> {

  List<Word> option1 = [];
  List<Word> option2 = [];
  List<Word> option3 = [];
  List<Word> option4 = [];
  List<Word> optionMain = [];

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= option1.length) {
      int i= Random().nextInt(4);
      wordMain = listProcess[i] as Word;
      option1.add(listProcess[0] as Word);
      option2.add(listProcess[1] as Word);
      option3.add(listProcess[2] as Word);
      option4.add(listProcess[3] as Word);
      optionMain.add(wordMain);
    }
    wordMain = optionMain[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(option1[listPosition]),
              getOptionTile(option2[listPosition])
            ],
          ),
        ),
        Flexible(child: getCenterTile(optionMain[listPosition])),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(option3[listPosition]),
              getOptionTile(option4[listPosition])
            ],
          ),
        ),
      ],
    );
  }

  Widget getCenterTile(word) {
    return getImageTile(word.id);
  }

  ButtonTheme getOptionTile(Word wordOption, [double _width=150, double _height=100]) {
    return ButtonTheme(
        child: Expanded(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: flagCorrect,
                  builder: (context, value, widget) {
                    saveCorrectionValues();
                    return SizedBox.shrink();
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: flagWrong,
                  builder: (context, value, widget) {
                    saveCorrectionValues();
                    return SizedBox.shrink();
                  },
                ),
                SizedBox(
                  width: _width,
                  height: _height,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white
                    ),
                    onPressed: () {
                      if (type == ModuleType.TEST) {
                        if (wordMain.id == wordOption.id) {
                          flagCorrect.value = 1;
                          correctCount++;
                        } else {
                          flagWrong.value = 1;
                          wrongCount++;
                        }
                      }
                      audioPlay(wordMain.id == wordOption.id);
                      Timer(Duration(milliseconds: 1000), () async {
                        next();
                      });
                    },
                    child: getOptionValue(wordOption),
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title.substring(0,1),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: fontSize,
          fontFamily: fontFamily
        ),
      ),
    );
  }

}
