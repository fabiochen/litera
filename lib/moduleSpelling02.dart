import 'dart:async';

import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

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
    wordMain = listProcess[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 200.0,
          padding: EdgeInsets.all(12),
          child: TextField(
            controller: userInputTextField,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.black
            ),
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(
                      color: Colors.teal)),
              hintText: getAssetsVocab('TYPE-WORD'),
            ),
          ),
        ), // textfield
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
        ButtonTheme(
          minWidth: 50.0,
          height: 50.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            onPressed: () => _correction(),
            child: Text(
              getAssetsVocab('CHECK'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _correction() {
    bool isCorrect = (userInputTextField.text.toLowerCase() == wordMain.title);
    audioPlay(isCorrect);
    if (isCorrect) {
      flagCorrect.value = 1;
    } else {
      flagWrong.value = 1;
    }
    t2 = Timer(Duration(milliseconds: 1000), () {
      next();
    });
  }

  @override
  void next() {
    userInputTextField.text = '';
    super.next();
  }

  @override
  void previous() {
    userInputTextField.text = '';
    super.previous();
  }

}