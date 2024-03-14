import 'package:flutter/material.dart';
import 'dart:async';

import 'baseOptionTiles.dart';
import 'word.dart';

class ModuleSound2Images extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleSound2Images> {

  int _start = 5;
  bool firstTime = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            firstTime = false;
            useNavigation = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Widget getCenterTile(word) {
    audioPlay(word.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (bool.parse(misc.toString())) getImageTile(801, imageSize: 100, borderColor: Colors.orange),
        getSoundTile(word),
      ],
    );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return getImage(word.id);
  }

}