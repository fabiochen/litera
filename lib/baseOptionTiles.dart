import 'dart:async';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    Globals().printDebug("baseOptionTiles: getMainTile");
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      int processedIndex = listProcess.indexWhere((word) => (word as Word).processed == false);
      wordMain = listProcess[processedIndex] as Word;
      Globals().printDebug("processed word: " + wordMain.title);
      wordMain.processed = true;
      listProcess[processedIndex] = wordMain;
      Globals().printDebug("getMainTile 1:");
      setProcessed = Set();
      setProcessed.add(wordMain);
      Globals().printDebug("getMainTile 2:");
      listProcess.forEach((word) {
        setProcessed.add(word as Word);
      });
      List temp = setProcessed.toList().sublist(0,4);
      temp.shuffle();
      Globals().printDebug("getMainTile 3:");
      setProcessed = (temp as List<Word>).toSet();
      listOption1.add(setProcessed.elementAt(0));
      listOption2.add(setProcessed.elementAt(1));
      listOption3.add(setProcessed.elementAt(2));
      listOption4.add(setProcessed.elementAt(3));
      Globals().printDebug("getMainTile 4:");
      listMain.add(wordMain);
    }
    wordMain = listMain[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(listOption1[listPosition], optionColors[0]!),
            getOptionTile(listOption2[listPosition], optionColors[1]!)
          ],
        ),
        Flexible(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getCenterTile(listMain[listPosition]),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(listOption3[listPosition], optionColors[2]!),
            getOptionTile(listOption4[listPosition], optionColors[3]!)
          ],
        ),
      ],
    );
  }

  Widget getCenterTile(word) {
    return getImageTile(word.id);
  }

  Widget getOptionTile(Word wordOption, [Color backGroundColor=Colors.white]) {
    //Globals().printDebug("getOptionTile: " + wordOption.title);
    debugPrint("baseOptionTiles: getOptionTile: " + wordOption.title);
    bool showBackground;
    try {
      showBackground = misc as bool;
    } catch (e) {
      showBackground = true;
    }
    if (!showBackground) backGroundColor = Colors.white;
    return Column(
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
          width: optionWidth,
          height: optionHeight,
          child: PlayerBuilder.isPlaying(
              player: Globals().audioPlayer,
              builder: (context, isPlaying) {
                return ElevatedButton(
                  style: Globals().buttonStyle(
                    backgroundColor: backGroundColor,
                    borderColor: (!isPlaying) ? Colors.blue :  Colors.grey.shade50,
                  ),
                  onPressed: (!isPlaying) ? () {
                    correctionLogic(wordOption);
                  } : () {},
                  child: getOptionValue(wordOption),
                );
              }
          ),
        ),
      ],
    );
  }

  void correctionLogic(Word wordOption) {
    Globals().printDebug("correctionLogic 1 ");
    bool isCorrect = wordMain.id == wordOption.id;
    audioPlay(isCorrect);
    if (type == ModuleType.TEST) {
      Globals().printDebug("correctionLogic 2 ");
      if (isCorrect) {
        Globals().printDebug("correctionLogic 3 ");
        flagCorrect.value = 1;
        correctCount++;
      } else {
        flagWrong.value = 1;
        wrongCount++;
      }
      Globals().printDebug("correctionLogic 4 ");
      Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    }
  }

  Widget getOptionValue(Word word, [double fontSize=50]) {
    Globals().printDebug("baseOptionTiles: getOptionValue");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AutoSizeText(
        word.title.substring(0,1),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: optionFontColor,
          fontSize: optionFontSize,
          fontFamily: fontFamily
        ),
      ),
    );
  }

}
