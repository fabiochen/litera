import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleNumbers2Word extends BaseOptionTiles {
  @override
  _ModuleNumbers2WordState createState() => _ModuleNumbers2WordState();
}

class _ModuleNumbers2WordState extends BaseOptionTilesState<ModuleNumbers2Word> {

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    wordMain = listProcess[Random().nextInt(4)];
    return super.getMainTile();
  }

  @override
  Widget getCenterTile() {
    return getTextTile(wordMain);
  }

  ElevatedButton getTextTile(Word word) {
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
                child: getText(word.title),
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

  Text getText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.deepOrange,
        fontSize: 40,
      ),
    );
  }

  Widget getOptionValue(Word word) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 30,
        ),
      ),
    );
  }

}
