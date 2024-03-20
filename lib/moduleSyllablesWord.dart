import 'package:flutter/material.dart';

import 'baseOptionTiles.dart';
import 'word.dart';
import 'globals.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            style: Globals().buttonStyle(),
            child: getImage(word.id,width:100)),
        SizedBox(width: 20),
        Expanded(child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: AutoSizeText(
            "__" + word.title.substring(2),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(3,3),
                  blurRadius: 3.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ))
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