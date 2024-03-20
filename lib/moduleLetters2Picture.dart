import 'package:flutter/material.dart';
import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class ModuleLetters2Picture extends BaseOptionTiles {
  @override
  _ModuleLetters2PictureState createState() => _ModuleLetters2PictureState();
}

class _ModuleLetters2PictureState extends BaseOptionTilesState<ModuleLetters2Picture> {

  @override
  Widget getImageTile(int id, {double imageSize=200, Color borderColor=Colors.white, Color backgroundColor=Colors.white}) {
    return super.getImageTile(
      id,
      imageSize: imageSize,
      borderColor: Globals().appColor
    );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.title.substring(0,1),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: fontSize,
        ),
      ),
    );
  }

}