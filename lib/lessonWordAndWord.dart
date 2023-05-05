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
    fieldTypeMain = FieldType.VAL1;
    fieldTypeOption = FieldType.TITLE;
    fontSizeMain = 50;
    fontSizeOption = 100;
    super.didChangeDependencies();
  }

  Widget getMainTile() {
    Word word = listProcess[listPosition] as Word;
    if (containsAudio) audioPlay(word.id);
    String text = getFieldTypeValue(word, fieldTypeMain);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getTextTile(word,
            fontSize: fontSizeMain,
            color: Colors.deepOrange,
            width: widthMain,
            containsAudio: containsAudio),
        getText(text, fontSizeOption), // words
      ],
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color color= Colors.teal, double width=250, double height=200, bool containsAudio=true}) {
    int id = word.id;
    String text = getFieldTypeValue(word, fieldTypeOption);
    if (containsAudio) {
      return ElevatedButton(
          onPressed: () => audioPlay(id),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: width,
                  height: 200,
                  alignment: Alignment.center,
                  child: getText(text, fontSize, color),
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
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: width,
            height: 200,
            alignment: Alignment.center,
            child: getText(text, fontSize, color),
          ),
        ),

      );
    }
  }

}