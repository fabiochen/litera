import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleNumbers2Picture extends BaseOptionTiles {
  @override
  _ModuleNumbers2PictureState createState() => _ModuleNumbers2PictureState();
}

class _ModuleNumbers2PictureState extends BaseOptionTilesState<ModuleNumbers2Picture> {

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    wordMain = listProcess[Random().nextInt(4)];
    return super.getMainTile();
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
