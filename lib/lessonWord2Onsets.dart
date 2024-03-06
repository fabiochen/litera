import 'package:flutter/material.dart';
import 'package:litera/globals.dart';

import 'package:litera/word.dart';
import 'package:litera/baseModule.dart';

class LessonWord2Onsets extends BaseModule {
  @override
  _LessonWord2OnsetsState createState() => _LessonWord2OnsetsState();
}

class _LessonWord2OnsetsState extends BaseModuleState<LessonWord2Onsets> {

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(child: getImageTile(wordMain.id)),
        Flexible(child: getMainText(wordMain, 70,
          backgroundColor: optionColors[wordMain.id%10]!,
        )),
        Flexible(child: _getOnsetsTile()), // letters
      ],
    );
  }

  Widget _getOnsetsTile() {
    Word word = listProcess[listPosition] as Word;
    audioPlay(word.id);
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: word.title.characters.toList().length,
        itemBuilder: (context, i) {
          return _loadCharacter(word.title.characters.elementAt(i));
        },
      ),
    );
  }

  Padding _loadCharacter(String char) {
    //if (char != ' ') char = '[' + char + ']';
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: () => audioPlayOnset(char),
        style: Globals().buttonStyle(),
        child: Stack(
          children: [
            Container(
              width: 45,
              alignment: Alignment.center,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white)
              ),
              child: Text(
                char.toUpperCase(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.teal,
                ),
              ),
            ), // onset letter
            Positioned(
              bottom: 0, right: 0,
              child: (char != ' ') ? Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue,
                size: 20,
              ) : Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 20,
              ),
            ), // first icon
            Positioned(
              bottom: 0, right: 0,
              child: (char != ' ') ? Icon(
                IconData(57401, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 20,
              ) : Icon(
                IconData(57401, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 20,
              ),
            ), // second icon to "paint" previous transparent icon
          ],
        ),
      ),
    );
  }

}
