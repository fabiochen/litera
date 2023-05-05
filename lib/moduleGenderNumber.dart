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
    if (listPosition == 0 || listPosition >= listOption1.length) {
      List<Word> listGenderNumber = (listProcess[listPosition] as List<Word>);
      int i= Random().nextInt(4);
      wordMain = listGenderNumber[i];
      listOption1.add(listGenderNumber[0]);
      listOption2.add(listGenderNumber[1]);
      listOption3.add(listGenderNumber[2]);
      listOption4.add(listGenderNumber[3]);
      listMain.add(wordMain);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(listOption1[listPosition]),
            getOptionTile(listOption2[listPosition])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCenterTile(listMain[listPosition]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(listOption3[listPosition]),
            getOptionTile(listOption4[listPosition])
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
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        Globals().enumGenderNumber[int.parse(word.val1)],
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
