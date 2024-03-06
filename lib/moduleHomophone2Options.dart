import 'dart:async';
import 'package:flutter/material.dart';
import 'word.dart';
import 'baseOptionTiles.dart';
import 'globals.dart';

class ModuleHomophone2Options extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleHomophone2Options> {

  List<String> listHomophones = [];

  List<Object> listTemp = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listHomophones = misc.toString().split('|');
    debugPrint("Homophone 1: ${listHomophones[0]}");
    debugPrint("Homophone 2: ${listHomophones[1]}");
    // listHomophones.forEach((element) {
    //   listTemp =  listTemp..addAll(listProcess.where((word) => (word as Word).title.contains(element)).toList());
    //   debugPrint("list length: ${listTemp.length}");
    // });
    // listProcess = listTemp;
    // numberQuestions = listProcess.length;
    listProcess.shuffle();
  }

  @override
  Widget getMainTile() {
    Globals().printList(listProcess);
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: getHomophoneButtons(),
        ),
        getCenterTile(wordMain)
      ],
    );
  }

  List<Widget> getHomophoneButtons() {
    List<Widget> listButtons = [];
    listHomophones.asMap().keys.forEach((key) {
      Word homophoneWord = Word(0,listHomophones[key]);
      listButtons.add(getOptionTile(homophoneWord,optionColors[key%10]!));
    });
    return listButtons;
  }

  @override
  Widget getCenterTile(word) {
    String tempString = word.title;
    if (isCorrect) {
      return getText(word.title, 80);
    }
    for (String homophone in listHomophones) {
      if (tempString.contains(homophone)) {
        return getText(word.title.replaceAll(homophone, '__'), 80);
      }
    }
    return getText(word.title, 80);
  }

  bool isCorrect = false;

  void correctionLogic(Word wordOption) {
    Globals().printDebug("correctionLogic 1 ");
    isCorrect = wordMain.title.contains(wordOption.title);
    audioPlay(isCorrect);
    if (isCorrect) setState(() {});
    if (type == ModuleType.TEST) {
      Globals().printDebug("correctionLogic 2 ");
      if (isCorrect) {
        Globals().printDebug("correctionLogic 3 ");
        flagCorrect.value = 1;
        correctCount++;
      } else {
        flagWrong.value = 1;
        wrongCount++;
      }
      Globals().printDebug("correctionLogic 4 ");
      Timer(Duration(milliseconds: 1000), () async {
        next();
        isCorrect = false;
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
        isCorrect = false;
      });
    }
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: fontSize,
        ),
      ),
    );
  }

}