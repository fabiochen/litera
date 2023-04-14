import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';

class ModuleSyllablesWord extends BaseOptionTiles {
  @override
  _ModuleSyllablesWordState createState() => _ModuleSyllablesWordState();
}

class _ModuleSyllablesWordState extends BaseOptionTilesState<ModuleSyllablesWord> {

  Widget getMainTile() {
    listProcess.shuffle();
    listProcess.sort((a, b) => (a as Word).processed?1:0);
    int i= Random().nextInt(4);
    wordMain = listProcess[i] as Word;
    wordMain.processed = true;
    listProcess[i] = wordMain;
    return super.getMainTile();
  }

  Widget getCenterTile(word) {
    //audioPlay(wordMain.id);
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white
            ),
            child: getImage(word.id,100)),
        SizedBox(width: 50),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "__" + word.title.substring(2),
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
  Widget getOptionValue(Word word, [double fontSize=50]) {
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