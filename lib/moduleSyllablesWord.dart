import 'package:flutter/material.dart';

import 'baseOptionTiles.dart';
import 'word.dart';
import 'globals.dart';

class ModuleSyllablesWord extends BaseOptionTiles {
  @override
  _ModuleSyllablesWordState createState() => _ModuleSyllablesWordState();
}

class _ModuleSyllablesWordState extends BaseOptionTilesState<ModuleSyllablesWord> {

  Widget getCenterTile(word) {
    //audioPlay(wordMain.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    Globals().printDebug(word.title);
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