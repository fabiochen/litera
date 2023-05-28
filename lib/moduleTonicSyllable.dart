import 'dart:async';
import 'package:flutter/material.dart';

import 'globals.dart';
import 'word.dart';
import 'baseOptionTiles.dart';

class ModuleTonicSyllable extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleTonicSyllable> {

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      int processedIndex = listProcess.indexWhere((word) => (word as Word).processed == false);
      wordMain = listProcess[processedIndex] as Word;
      audioPlay(wordMain.id);
      wordMain.processed = true;
      listProcess[processedIndex] = wordMain;
      setProcessed = Set();
      setProcessed.add(wordMain);
      listProcess.forEach((word) {
        setProcessed.add(word as Word);
      });
      List temp = setProcessed.toList().sublist(0,4);
      temp.shuffle();
      setProcessed = (temp as List<Word>).toSet();
      // set word id = syllable position
      listOption1.add(Word(1,wordMain.val1.split('-')[0]));
      listOption2.add(Word(2,wordMain.val1.split('-')[1]));
      listOption3.add(Word(3,wordMain.val1.split('-')[2]));
      listOption4.add(Word(4,wordMain.val1.split('-')[3]));
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
              getOptionTile(listOption1[listPosition], listColor[0]!),
              getOptionTile(listOption2[listPosition], listColor[1]!)
            ],
          ),
        ),
        Flexible(child: getCenterTile(listMain[listPosition])),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption3[listPosition], listColor[2]!),
              getOptionTile(listOption4[listPosition], listColor[3]!)
            ],
          ),
        ),
      ],
    );
  }

  @override
  void correctionLogic(Word wordOption) {
    bool isCorrect = wordMain.val2 == wordOption.id.toString();
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
  }

  @override
  Widget getCenterTile(word) {
    return getTextTile(
      word,
      containsAudio: containsAudio,
      fontSize: mainFontSize,
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color? backgroundColor=Colors.white, Color? borderColor=Colors.white, Color fontColor= Colors.teal, double width=300, double height=200, bool containsAudio=true}) {
    int id = word.id;
    return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: width,
                height: 100,
                alignment: Alignment.center,
                child: getText(word.title,fontSize,Colors.deepOrange),
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue,
                size: 40,
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57401, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 40,
              ),
            ), // second icon to "paint" previous transparent icon
          ],
        )
    );
  }

  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: fontSize,
        ),
      ),
    );
  }

}
