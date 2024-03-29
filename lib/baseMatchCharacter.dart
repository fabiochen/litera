import 'dart:async';
import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class BaseMatchCharacter extends BaseModule {
  @override
  BaseMatchCharacterState createState() => BaseMatchCharacterState();
}

class BaseMatchCharacterState<T extends BaseMatchCharacter> extends BaseModuleState<T> {

  late Offset position;
  Map<String, bool> acceptedPositionOriginalMap = Map();
  late List<bool> acceptedPositionTargetList;
  List wordScrambled = [];
  String titleShuffled = '';

  bool isCorrect = false;
  bool isStartPosition = true;
  bool isEndPosition = false;

  bool isVisibleTarget = false;
  bool isFirstTime = true;
  String charTarget = '';

  int crossAxisCount = 5;

  double aspectRatioBig = 1.0;
  double aspectRatioSmall = 1.5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map? args = ModalRoute.of(context)?.settings.arguments as Map;
    Globals().printDebug("args: " + args.toString());
    isVisibleTarget = args['isVisibleTarget'] ?? false;
    listProcess.shuffle();
    load();
  }

  @override
  Widget getMainTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: getMainChildren(),
    );
  }

  List<Flexible> getMainChildren() {
    return [
      Flexible(
        flex: 2,
        child: GridView.builder(
          padding: const EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: wordMain.title.length,
            childAspectRatio: aspectRatioBig,
          ),
          itemCount: wordMain.title.length,
          itemBuilder: (BuildContext context, int i) {
            if (!acceptedPositionOriginalMap[i.toString()]!) {
              return Draggable<List<String>>(
                  feedback: getLetterModel(titleShuffled[i], optionColors[i]!),
                  childWhenDragging: Container(),
                  data: [titleShuffled[i], i.toString()],
                  child: getLetterModel(titleShuffled[i], optionColors[i]!));
            } else {
              return Container();
            }
          },
        ),
      ), // jumbled letters
      Flexible(
        flex: 2,
        child: GridView.builder(
          padding: const EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: wordMain.title.length,
            childAspectRatio: aspectRatioBig,
          ),
          itemCount: wordMain.title.length,
          itemBuilder: (BuildContext context, int i) {
            return DragTarget<List<String>>(
                // condition to accept dragged item
                onWillAccept: (data) {
                  // if (type == ModuleType.TEST) return true;
                  // if (data![0] == wordMain.title[i]) return true;
                  return true;
                },
                onAccept: (List<String> data) {
                  Globals().printDebug('accepted:${data[1]}');
                  Globals().printDebug('data:${data[0]}');
                  setState(() {
                    acceptedPositionOriginalMap[data[1]] = true;
                    acceptedPositionTargetList[i] = true;
                    wordScrambled[i] = data[0];
                  });
                },
//                onLeave: (data) => Globals().printDebug("LEAVE 2!"),
                builder: (context, candidateData,
                    rejectedData) {
                  charTarget = (isVisibleTarget) ? wordMain.title[i].toUpperCase() : '';
                  return acceptedPositionTargetList[i]
                      ? getTargetLetterModel(wordScrambled[i], optionColors[i]!)
                      : getTargetLetterModel(charTarget, Colors.white);
                });
          },
        ), // ordered letters,
      ), // ordered letters
      Flexible(
        flex: 1,
        child: Row(
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
            Flexible(
              flex: 1,
              child: ButtonTheme(
                minWidth: 50.0,
                height: 50.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: ElevatedButton(
                  style: Globals().buttonStyle(
                    backgroundColor: Globals().appButtonColor
                  ),
                  onPressed: () => load(),
                  child: Text(
                    'Recomeçar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Globals().appFontColorLight,
                    ),
                  ),
                ),
              ), // check result button,
            ),  // check button
            Flexible(
              flex: 1,
              child: ButtonTheme(
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
                    style: TextStyle(
                      fontSize: Globals().appButtonFontSize,
                      color: Globals().appFontColorLight,
                    ),
                  ),
                ),
              ), // check result button,
            ),  // check button
            ValueListenableBuilder(
              valueListenable: flagWrong,
              builder: (context, value, widget) {
                saveCorrectionValues();
                return SizedBox.shrink();
              },
            ),
          ],
        ), // image,
      )  // check button
    ];
  }

  Container getLetterModel(String letter, Color color) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Globals().appFontColorDark,
          ),
        ),
      ),
    );
  }

  Container getTargetLetterModel(String letter, Color color) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Globals().appFontColorDark,
          ),
        ),
      ),
    );
  }

  @override
  void next([bool refresh=true]) {
    super.next(refresh);
    load();
  }

  @override
  void previous([bool refresh=true]) {
    super.previous(refresh);
    load();
  }

  void _correction() {
    var concatenate = StringBuffer();
    wordScrambled.forEach((item){
      concatenate.write(item);
    });
    Globals().printDebug('concat:' + concatenate.toString());
    isCorrect = wordMain.title == concatenate.toString();
    audioPlay(isCorrect);
    if (type == ModuleType.TEST) {
        if (isCorrect) {
            correctCount++;
            flagCorrect.value = 1;
        } else {
            flagWrong.value = 1;
        }
        Globals().t2 = Timer(Duration(seconds: 1), () {
            next();
        });
    } else { // is exercise
        if (isCorrect) {
            correctCount++;
            Globals().t2 = Timer(Duration(seconds: 1), () {
                next();
            });
        } else {
          Globals().t3 = Timer(Duration(seconds: 1), () {
                load();
            });
        }
    }
  }

  void load() {
    setState(() {
      wordMain = listProcess[listPosition] as Word;
      wordScrambled = [];
      wordScrambled.length = wordMain.title.length;
      for (int i=0; i<wordMain.title.length; i++) {
        acceptedPositionOriginalMap[i.toString()] = false;
      }
      acceptedPositionTargetList   = List.filled(wordMain.title.length, false);
      titleShuffled = _shuffle(wordMain.title);
    });
  }

  String _shuffle(String text) {
    List textList = [];

    for (int i=0; i<text.length; i++) {
      textList.add(text[i]);
    }

    Globals().printDebug('org: ' + text);
    textList.shuffle();

    text = '';

    for (int i=0; i<textList.length; i++) {
      text = text + textList[i];
    }

    Globals().printDebug('shuffled: ' + text);

    return text;
  }

}
