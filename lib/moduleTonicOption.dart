import 'dart:async';

import 'package:flutter/material.dart';

import 'word.dart';
import 'baseModule.dart';
import 'globals.dart';

class ModuleTonicOption extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModuleTonicOption> {

  Object? _isRadioSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.shuffle();
  }
  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        SizedBox(height: 30),
        Flexible(child: getTextTile(wordMain)),
        SizedBox(height: 30),
        Container(
          width: widthOption,
          child: Column(
            children: [
              RadioListTile(
                title: Text('Oxítona',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30,
                    ),
                ),
                value: 1,
                groupValue: _isRadioSelected,
                onChanged: (v) {
                  setState(() {
                    _isRadioSelected = v;
                    correctionLogic(wordMain);
                  });
                },
              ),
              RadioListTile(
                title: Text('Paroxítona',
                  style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30,
                  ),
                ),
                value: 2,
                groupValue: _isRadioSelected,
                onChanged: (v) {
                  setState(() {
                    _isRadioSelected = v;
                    correctionLogic(wordMain);
                  });
                },
              ),
              RadioListTile(
                title: Text('Proparoxítona',
                  style: TextStyle(
                  color: Colors.teal,
                  fontSize: 30,
                  ),
                ),
                value: 3,
                groupValue: _isRadioSelected,
                onChanged: (v) {
                  setState(() {
                    _isRadioSelected = v;
                    correctionLogic(wordMain);
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
      ]
    );
  }

  void correctionLogic(Word wordOption) {
    print("isRadioSelected : $_isRadioSelected");
    print("number of syllables: " + wordMain.val1.split('-').length.toString());
    print("wordMain val2: " + wordMain.val2);
    bool isCorrect = _isRadioSelected as int == wordMain.val1.split('-').length-int.parse(wordMain.val2)+1;
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
        _isRadioSelected = null;
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
        _isRadioSelected = null;
      });
    }
  }

}
