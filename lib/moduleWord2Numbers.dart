import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';

class ModuleWord2Numbers extends BaseOptionTiles {
  @override
  _ModuleLetters2PictureState createState() => _ModuleLetters2PictureState();
}

class _ModuleLetters2PictureState extends BaseOptionTilesState<ModuleWord2Numbers> {

  Widget getCenterTile(word) {
    print("contains audio 1: $containsAudio");
    if (containsAudio) audioPlay(word.id);
    return getTextTile(word,
      containsAudio: containsAudio,
      width: widthMain,
      height: heightMain
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color color= Colors.teal, double width=250, double height=200, bool containsAudio=true}) {
    int id = word.id;
    if (containsAudio)
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
                height: height,
                alignment: Alignment.center,
                child: getText(word.title, fontSizeMain, colorMain),
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
    else
      return ElevatedButton(
          onPressed: () => null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white
          ),
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: getText(word.title, fontSizeMain, colorMain),
          )
      );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    String text = getFieldTypeValue(word, fieldTypeOption);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorOption,
          fontSize: fontSizeOption,
        ),
      ),
    );
  }

}