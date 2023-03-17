import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class ModuleSyllableWord extends BaseOptionTiles {
  @override
  _ModuleSyllableWordState createState() => _ModuleSyllableWordState();
}

class _ModuleSyllableWordState extends BaseOptionTilesState<ModuleSyllableWord> {

  Widget getMainTile() {
    listProcess.shuffle();
    listProcess.sort((a, b) => (a as Word).processed?1:0);
    int i= Random().nextInt(4);
    wordMain = listProcess[i];
    wordMain.processed = true;
    listProcess[i] = wordMain;
    return super.getMainTile();
  }

  Widget getCenterTile() {
    //audioPlay(wordMain.id);
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white
            ),
            child: getImage(wordMain.id,100)),
        SizedBox(width: 50),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "__" + wordMain.title.substring(2),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.teal,
              fontSize: 50,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget getOptionValue(Word word) {
    print(word.title);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title.substring(0,2),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 50,
        ),
      ),
    );
  }

}