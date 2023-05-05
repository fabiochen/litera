import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class ModuleClock extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleClock> {

  int hr = 1;
  int mn = 0;
  int centerTile = 1;

  @override
  Widget getCenterTile(word) {
    return Globals().getClock(word.title);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 30,
        ),
      ),
    );
  }

}
