import 'dart:async';
import 'package:eval_ex/expression.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class ModuleExpressionEval extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModuleExpressionEval> {

  late int valLeft;
  late int valRight;
  late int result;
  int _selectedResultLeft = 0;
  int _selectedResultRight = 0;
  late String op;
  final double fontSizeMin = 100;

  List<int> listDigits = [0,1,2,3,4,5,6,7,8,9];

  FixedExtentScrollController controllerResultLeft  = FixedExtentScrollController(initialItem: 9);
  FixedExtentScrollController controllerResultRight = FixedExtentScrollController(initialItem: 8);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    misc = 'h';
    super.didChangeDependencies();
    if ((type == ModuleType.EXERCISE || type == ModuleType.TEST)) useNavigation = false;
    debugPrint("************************************************************* mainFontSize1: $mainFontSize");
    mainFontSize = 120;
    debugPrint("************************************************************* mainFontSize2: $mainFontSize");
    listProcess.shuffle();
    Timer(Duration(milliseconds: 500), () async {
      controllerResultLeft.animateToItem(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
      controllerResultRight.animateToItem(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
    });
  }

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    op = wordMain.title.replaceAll(new RegExp(r"\d"), "");
    final List<String> wordSplit = wordMain.title.split(op);
    debugPrint("word: ${wordMain.title}");
    debugPrint("base: ${wordSplit[0]}");
    debugPrint("mult: ${wordSplit[1]}");
    debugPrint("op: ${op}");
    valLeft  = int.parse(wordSplit[0]);
    valRight = int.parse(wordSplit[1]);
    String exp = wordMain.title;
    exp = exp.replaceAll('x', '*');
    exp = exp.replaceAll('÷', '/');
    Expression expression = Expression(exp);
    result = int.parse(expression.eval().toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height:30),
        (misc == 'h') ? Expanded(
          flex: 1,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              valLeft.toString(),
              minFontSize: fontSizeMin,
              style: TextStyle(
                  fontSize: mainFontSize,
                  fontFamily: 'Mynerve',
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontFeatures: [
                    FontFeature.tabularFigures()
                  ],
                  height: 1
              ),
            ),
            getImage(op,backgroundColor: Colors.transparent),
            AutoSizeText(
              valRight.toString(),
              minFontSize: fontSizeMin,
              style: TextStyle(
                  fontSize: mainFontSize,
                  fontFamily: 'Mynerve',
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontFeatures: [
                    FontFeature.tabularFigures()
                  ],
                  height: 1
              ),
            )
          ],
        )) : Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        valLeft.toString(),
                        textAlign: TextAlign.right,
                        minFontSize: fontSizeMin,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          fontFamily: 'Mynerve',
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontFeatures: [
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              )),
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: getImage(op,backgroundColor: Colors.transparent))
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        valRight.toString(),
                        textAlign: TextAlign.right,
                        minFontSize: fontSizeMin,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          fontFamily: 'Mynerve',
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontFeatures: [
                            FontFeature.tabularFigures()
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ))  // op + second number
            ],
          )
        ),  // expression
        (misc == 'h') ? getImage('=', backgroundColor: Colors.transparent) : SizedBox(
          child: getImage('line', backgroundColor: Colors.transparent, width:300),
        ), // divider, equal sign
        Expanded(
          flex: 1,
          child: Column(
            children: [
            Expanded(child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: (misc == 'h') ? MainAxisAlignment.center : MainAxisAlignment.end,
                      children: (type == ModuleType.LESSON) ? [AutoSizeText(
                        result.toString(),
                        minFontSize: fontSizeMin,
                        style: TextStyle(
                            fontSize: mainFontSize,
                            fontFamily: 'Mynerve',
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontFeatures: [
                              FontFeature.tabularFigures()
                            ],
                            height: 1
                        ),
                      )] : [
                        SizedBox(
                          width: 70,
                          height: 120,
                          child: CupertinoPicker(
                            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                              capStartEdge: false,
                              capEndEdge: false,
                              background: Colors.transparent,
                            ),
                            itemExtent: mainFontSize+30,
                            scrollController: controllerResultLeft,
                            children: [
                              ...listDigits.map((value) {
                                return AutoSizeText(
                                  value.toString(),
                                  minFontSize: fontSizeMin,
                                  style: TextStyle(
                                    fontSize: mainFontSize,
                                    fontFamily: 'Mynerve',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontFeatures: [
                                      FontFeature.tabularFigures()
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                            onSelectedItemChanged: (value) {
                              _selectedResultLeft = value;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 120,
                          child: CupertinoPicker(
                            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                              capStartEdge: false,
                              capEndEdge: false,
                              background: Colors.transparent,
                            ),
                            itemExtent: mainFontSize+30,
                            scrollController: controllerResultRight,
                            children: [
                              ...listDigits.map((value) {
                                return AutoSizeText(
                                  value.toString(),
                                  minFontSize: fontSizeMin,
                                  style: TextStyle(
                                    fontSize: mainFontSize,
                                    fontFamily: 'Mynerve',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontFeatures: [
                                      FontFeature.tabularFigures()
                                    ],
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
                    )),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ))
          ],
        )),  // answer
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
        Visibility(
          visible: !(type == ModuleType.LESSON),
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
                child: AutoSizeText(
                  "acertei?",
                  minFontSize: 30,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ),
        )),  // acertei?
      ],
    );
  }

  void correctionLogic(Word wordOption) {
    String exp = wordOption.title;
    exp = exp.replaceAll('x', '*');
    exp = exp.replaceAll('÷', '/');
    Expression expression = Expression(exp);
    int result = int.parse(expression.eval().toString());
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
