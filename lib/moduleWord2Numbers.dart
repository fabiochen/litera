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
    return getTextTile(word);
  }

  ElevatedButton getTextTile(Word word, [double _fontSizeDefault=50, Color _color= Colors.teal, double _width=250, bool _containsAudio=true]) {
    int id = word.id;
    print("contains audio 2: $containsAudio");
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
                width: widthMain,
                height: 100,
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
            width: widthMain,
            height: 100,
            alignment: Alignment.center,
            child: getText(word.title, fontSizeMain, _color),
          )
      );
  }

  @override
  ButtonTheme getOptionTile(Word wordOption, [double _width=150, double _height=100]) {
    return super.getOptionTile(wordOption, widthOption);
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