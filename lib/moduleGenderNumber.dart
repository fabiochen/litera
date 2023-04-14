import 'dart:math';
import 'package:flutter/material.dart';
import 'package:litera/globals.dart';

import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleGenderNumber extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleGenderNumber> {

  // criteria placeholder, not used
  Comparator<Object> criteria = (a, b) => ((a as List<Word>)[0].id).compareTo((b as List<Word>)[0].id);

  Widget getMainTile() {
    if (listPosition == 0 || listPosition >= option1.length) {
      List<Word> listGenderNumber = (listProcess[listPosition] as List<Word>);
      int i= Random().nextInt(4);
      wordMain = listGenderNumber[i];
      option1.add(listGenderNumber[0]);
      option2.add(listGenderNumber[1]);
      option3.add(listGenderNumber[2]);
      option4.add(listGenderNumber[3]);
      optionMain.add(wordMain);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(option1[listPosition]),
            getOptionTile(option2[listPosition])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCenterTile(optionMain[listPosition]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(option3[listPosition]),
            getOptionTile(option4[listPosition])
          ],
        ),
      ],
    );
  }

  @override
  Widget getCenterTile(word) {
    return getImageTile(word.id);
  }

  @override
  ButtonTheme getOptionTile(Word wordOption, [double _width=150, double _height=100]) {
    return super.getOptionTile(wordOption,200);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        enumGenderNumber[int.parse(word.value)],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 25,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

}
