import 'dart:math';

import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleLeftRight extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleLeftRight> {

  int numberOfSyllables=0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    numberQuestions = args?['numberQuestions']??numberQuestions;
  }

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      int i= Random().nextInt(2);
      wordMain = listProcess[i] as Word;
      listOption1.add(listProcess[0] as Word);
      listOption2.add(listProcess[1] as Word);
      listMain.add(wordMain);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption1[listPosition]),
              getOptionTile(listOption2[listPosition])
            ],
          ),
        ),
        Flexible(child: getCenterTile(listMain[listPosition])),
      ],
    );
  }

  @override
  Widget getCenterTile(word) {
    print("center tile word: " + word.title);
    return getTextTile(word);
  }

  ElevatedButton getTextTile(Word word, [double fontSize=50, Color color= Colors.teal, double width=300, bool containsAudio=true]) {
    int id = word.id;
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
                height: 100,
                alignment: Alignment.center,
                child: getText(word.title,40,Colors.deepOrange),
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
  }

  @override
  ButtonTheme getOptionTile(Word wordOption, [double _width=150, _height=100]) {
    return super.getOptionTile(wordOption,200,150);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Image(
        image: AssetImage('assets/images/' + word.id.toString() + '.png'),
        gaplessPlayback: true,
      ),
    );
  }

}
