import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleSyllablesCount extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleSyllablesCount> {

  int numberOfSyllables=0;

  @override
  Widget getMainTile() {
    numberOfSyllables = 0;
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= option1.length) {
      wordMain = listProcess[0] as Word;
      optionMain.add(wordMain);
      List<String> listSyllables = wordMain.syllables.split('-');
      print("word: " + wordMain.title);
      print("syllable #: " + listSyllables.length.toString());
      switch (listSyllables.length) {
        case 1:
          option1.add(listProcess[0] as Word);
          option2.add(listProcess[1] as Word);
          option3.add(listProcess[2] as Word);
          option4.add(listProcess[3] as Word);
          break;
        case 2:
          option1.add(listProcess[1] as Word);
          option2.add(listProcess[0] as Word);
          option3.add(listProcess[2] as Word);
          option4.add(listProcess[3] as Word);
          break;
        case 3:
          option1.add(listProcess[1] as Word);
          option2.add(listProcess[2] as Word);
          option3.add(listProcess[0] as Word);
          option4.add(listProcess[3] as Word);
          break;
        case 4:
          option1.add(listProcess[1] as Word);
          option2.add(listProcess[2] as Word);
          option3.add(listProcess[3] as Word);
          option4.add(listProcess[0] as Word);
          break;
      }
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

  @override
  Widget getCenterTile(word) {
    print("center tile word: " + word.title);
    return getTextTile(word);
  }

  ElevatedButton getTextTile(Word word, [double fontSize=50, Color color= Colors.teal]) {
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
                width: 300,
                height: 100,
                alignment: Alignment.center,
                child: getText(word.title,40,Colors.deepOrange),
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
    numberOfSyllables++;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        numberOfSyllables.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 30,
        ),
      ),
    );
  }

}
