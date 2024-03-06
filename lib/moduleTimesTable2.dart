import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class ModuleTimesTable2 extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModuleTimesTable2> {

  late int _selectedMultiplier;
  late int _selectedBase;
  int _selectedResultLeft = 0;
  int _selectedResultRight = 0;
  late String op;

  List<int> listDigits = [0,1,2,3,4,5,6,7,8,9];

  FixedExtentScrollController controllerResultLeft  = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController controllerResultRight = FixedExtentScrollController(initialItem: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    op = misc.toString();
    listProcess.shuffle();
  }
  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    final List<String> wordSplit = wordMain.title.split(op);
    debugPrint("word: ${wordMain.title}");
    debugPrint("base: ${wordSplit[0]}");
    debugPrint("mult: ${wordSplit[1]}");
    _selectedBase       = int.parse(wordSplit[0]);
    _selectedMultiplier = int.parse(wordSplit[1]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                _selectedBase.toString(),
                style: TextStyle(
                    fontSize: 100,
                    color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                op,
                style: TextStyle(
                    fontSize: 100,
                    color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                _selectedMultiplier.toString(),
                style: TextStyle(
                    fontSize: 100,
                    color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                ),
              ),
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                scrollController: controllerResultLeft,
                children: [
                  ...listDigits.map((value) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.blue,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  _selectedResultLeft = value;
                },
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                ),
              ),
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                scrollController: controllerResultRight,
                children: [
                  ...listDigits.map((value) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.blue,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  _selectedResultRight = value;
                },
              ),
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: flagCorrect,
          builder: (context, value, widget) {
            saveCorrectionValues();
            return SizedBox.shrink();
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
                color: Colors.green
            ),
            borderRadius: BorderRadius.all(
                const Radius.circular(5.0)),
          ),
          child: TextButton(
              onPressed: () {
                correctionLogic(listProcess[listPosition] as Word);
              },
              child: Text(
                "acertei?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              )),
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

  void correctionLogic(Word wordOption) {
    int result = _selectedBase*_selectedMultiplier;
    if (op == '÷') result = _selectedBase~/_selectedMultiplier;
    debugPrint("result: $result");
    int option = _selectedResultLeft*10+_selectedResultRight;
    bool isCorrect = result == option;
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
        controllerResultLeft.animateToItem(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
        controllerResultRight.animateToItem(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
        controllerResultLeft.animateToItem(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
        controllerResultRight.animateToItem(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
      });
    }
  }

}
