import 'dart:math';
import 'package:flutter/material.dart';

import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

final correctCount = ValueNotifier<int>(0);
final wrongCount = ValueNotifier<int>(0);

class ModuleWord2Pictures extends BaseOptionTiles {
  @override
  _ModuleWord2PicturesState createState() => _ModuleWord2PicturesState();
}

class _ModuleWord2PicturesState extends BaseOptionTilesState<ModuleWord2Pictures> {

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    wordMain = listProcess[Random().nextInt(4)] as Word;
    return super.getMainTile();
  }

  @override
  Widget getCenterTile(word) {
    return getMainText(word, 50);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Image(
        image: AssetImage('assets/images/' + word.id.toString() + '.png'),
        gaplessPlayback: true,
      ),
    );
  }

}