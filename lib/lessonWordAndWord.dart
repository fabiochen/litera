import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonWordAndWord extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonWordAndWord> {

  @override
  void didChangeDependencies() {
    mainFieldType = FieldType.VAL1;
    optionFieldType = FieldType.TITLE;
    mainFontSize = 58;
    optionFontSize = 100;
    super.didChangeDependencies();
  }

  Widget getMainTile() {
    Word word = listProcess[listPosition] as Word;
    if (containsAudio) audioPlay(word.id);
    String text = Globals().getLabelFromFieldType(word, mainFieldType);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child:getTextTile(word,
            fontSize: mainFontSize,
            fontColor: Colors.teal,
            borderColor: optionColors[listPosition%10],
            width: mainWidth,
            containsAudio: containsAudio)),
        getTextVal(text), // words
      ],
    );
  }

  Widget getTextVal(text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: optionFontSize,
        fontFamily: 'mynerve',
        shadows: <Shadow>[
          Shadow(
            offset: Offset(3,3),
            blurRadius: 3.0,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color? backgroundColor=Colors.white, Color? borderColor=Colors.white, Color? fontColor= Colors.teal, double width=250, double height=200, bool containsAudio=true}) {
    int id = word.id;
    String text = Globals().getLabelFromFieldType(word, optionFieldType);
    if (containsAudio) {
      return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: Globals().buttonStyle(
          backgroundColor: optionColors[word.id%10]!
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: width,
                height: 200,
                alignment: Alignment.center,
                child: getText(text, fontSize, fontColor!),
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue,
                size: 40,
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57401, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 40,
              ),
            ), // second icon to "paint" previous transparent icon
          ],
        )
      );
    } else {
      return ElevatedButton(
        onPressed: () => null,
        style: Globals().buttonStyle(
          backgroundColor: optionColors[word.id%10]!
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: width,
            height: 200,
            alignment: Alignment.center,
            child: getText(text, fontSize, fontColor!),
          ),
        ),

      );
    }
  }

}