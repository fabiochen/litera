import 'package:flutter/material.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseOptionTiles.dart';

final correctCount = ValueNotifier<int>(0);
final wrongCount = ValueNotifier<int>(0);

class ModuleColors extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleColors> {

  @override
  Widget getCenterTile(word) {
    audioPlay(word.id);
    return getSoundTile(word);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(int.parse(word.val1)),
          shape: BoxShape.circle,
          border: Border.all(color: Globals().appColor)
        ),
    ));
  }

}