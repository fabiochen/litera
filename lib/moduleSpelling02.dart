import 'dart:async';

import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class ModuleSpelling02 extends BaseModule {
  @override
  _ModuleSpelling02State createState() => _ModuleSpelling02State();
}

class _ModuleSpelling02State extends BaseModuleState<ModuleSpelling02> {

  final userInputTextField = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.shuffle();
  }

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                clipBehavior: Clip.antiAlias,
                child: TextField(
                  controller: userInputTextField,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Globals().appFontColorDark
                  ),
                  decoration: InputDecoration(
                    hintText: Globals().getAssetsVocab('TYPE-WORD'),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey
                    )
                  ),
                ),
              ),
            ), // textfield
            ButtonTheme(
              minWidth: 50.0,
              height: 50.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: ElevatedButton(
                style: Globals().buttonStyle(
                  backgroundColor: Globals().appButtonColor
                ),
                onPressed: () => _correction(),
                child: Text(
                  Globals().getAssetsVocab('CHECK'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Globals().appButtonFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
        getImageTile(wordMain.id),
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
      ],
    );
  }

  void _correction() {
    bool isCorrect = (userInputTextField.text.toLowerCase().trim() == wordMain.title);
    Globals().printDebug("isCorrect: $isCorrect");
    audioPlay(isCorrect);
    if (type == ModuleType.TEST) {
      if (isCorrect) {
        flagCorrect.value = 1;
        correctCount++;
      } else {
        flagWrong.value = 1;
        wrongCount++;
      }
      Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    }
  }

  @override
  void next([bool refresh=true]) {
    userInputTextField.text = '';
    super.next(refresh);
  }

  @override
  void previous([bool refresh=true]) {
    userInputTextField.text = '';
    super.previous(refresh);
  }

}