import 'package:flutter/material.dart';
import 'baseOptionTiles.dart';
import 'word.dart';
import 'globals.dart';

class ModuleWord2Numbers extends BaseOptionTiles {
  @override
  _ModuleLetters2PictureState createState() => _ModuleLetters2PictureState();
}

class _ModuleLetters2PictureState extends BaseOptionTilesState<ModuleWord2Numbers> {

  Widget getCenterTile(word) {
    Globals().printDebug("contains audio 1: $containsAudio");
    if (containsAudio) audioPlay(word.id);
    return getTextTile(word,
      containsAudio: containsAudio,
      width: mainWidth,
      height: mainHeight,
      borderColor: Globals().appButtonColor,
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color? backgroundColor=Colors.white, Color? borderColor=Colors.white, Color fontColor= Colors.teal, double width=250, double height=200, bool containsAudio=true}) {
    int id = word.id;
    if (containsAudio)
      return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: Globals().buttonStyle(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                child: getText(word.title, mainFontSize, mainFontColor),
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
          style: Globals().buttonStyle(),
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: getText(word.title, mainFontSize, mainFontColor),
          )
      );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    String text = Globals().getLabelFromFieldType(word, optionFieldType);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: optionFontColor,
          fontSize: optionFontSize,
        ),
      ),
    );
  }

}