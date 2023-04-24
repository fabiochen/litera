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

  List<Word> listOption1 = [];
  List<Word> listOption2 = [];
  List<Word> listOption3 = [];
  List<Word> listOption4 = [];
  List<Word> listMain = [];

  @override
  Widget getMainTile() {
    listOriginal.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      int processedIndex = listProcess.indexWhere((word) => (word as Word).processed == false);
      wordMain = listProcess[processedIndex] as Word;
      print("word: " + wordMain.title);
      wordMain.processed = true;
      listProcess[processedIndex] = wordMain;
      setProcessed = Set();
      setProcessed.add(wordMain);
      listOriginal.forEach((word) {
        setProcessed.add(word as Word);
      });
      List temp = setProcessed.toList().sublist(0,4);
      temp.shuffle();
      setProcessed = (temp as List<Word>).toSet();
      listOption1.add(setProcessed.elementAt(0));
      listOption2.add(setProcessed.elementAt(1));
      listOption3.add(setProcessed.elementAt(2));
      listOption4.add(setProcessed.elementAt(3));
      listMain.add(wordMain);
    }
    wordMain = listMain[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption1[listPosition]),
              getOptionTile(listOption2[listPosition])
            ],
          ),
        ),
        Flexible(child: getCenterTile(listMain[listPosition])),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption3[listPosition]),
              getOptionTile(listOption4[listPosition])
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
                      bool isCorrect = wordMain.id == wordOption.id;
                      audioPlay(isCorrect);
                      if (type == ModuleType.TEST) {
                        if (isCorrect) {
                          flagCorrect.value = 1;
                          correctCount++;
                        } else {
                          flagWrong.value = 1;
                          wrongCount++;
                        }
                        Timer(Duration(milliseconds: 1000), () async {
                          next();
                        });
                      } else {
                        if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
                            next();
                          });
                      }
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
