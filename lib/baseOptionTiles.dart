import 'dart:async';
import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';

class BaseOptionTiles extends BaseModule {
  @override
  BaseOptionTilesState createState() => BaseOptionTilesState();
}

class BaseOptionTilesState<T extends BaseOptionTiles> extends BaseModuleState<T> {

  @override
  Widget getMainTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(0),
            getOptionTile(1)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCenterTile(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getOptionTile(2),
            getOptionTile(3)
          ],
        ),
      ],
    );
  }

  Widget getCenterTile() {
    return getImageTile(wordMain.id);
  }

  ButtonTheme getOptionTile(int pos) {
    Word wordOption = listProcess[pos];
    return ButtonTheme(
        child: Expanded(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: flagCorrect,
                builder: (context, value, widget) {
                  saveCorrectionValues();
                  return SizedBox.shrink();
                },
              ),
              ValueListenableBuilder(
                valueListenable: flagWrong,
                builder: (context, value, widget) {
                  saveCorrectionValues();
                  return SizedBox.shrink();
                },
              ),
              SizedBox(
                width: 150,
                height: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                  ),
                  onPressed: () {
                    if (mode == 'test') {
                      if (wordMain.id == wordOption.id) {
                        flagCorrect.value = 1;
                        correctCount++;
                      } else {
                        flagWrong.value = 1;
                        wrongCount++;
                      }
                    }
                    audioPlay(wordMain.id == wordOption.id);
                    Timer(Duration(milliseconds: 1000), () async {
                      next();
                    });
                  },
                  child: getOptionValue(wordOption),
                ),
              ),
            ],
          )
        )
    );
  }

  Widget getOptionValue(Word word) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title.substring(0,1),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 50,
        ),
      ),
    );
  }

}
