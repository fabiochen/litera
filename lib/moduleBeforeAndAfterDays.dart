import 'dart:math';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class ModuleBeforeAndAfterDays extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleBeforeAndAfterDays> {

  List<int> listRel = [];

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    wordMain = listProcess[Random().nextInt(4)] as Word;
    return super.getMainTile();
  }

  @override
  Widget getCenterTile(word) {
    return getTextTile(word);
  }

  ElevatedButton getTextTile(Word word, [double fontSize=50, Color color= Colors.teal]) {
    int id = word.id;
    print("listPosition: $listPosition option1.length: " + listOption1.length.toString());
    if (listPosition == 0 || listPosition >= listOption1.length-1) {
      // rand 1 or 2.  If 1 rel = -1, if 2 rel = 1
      int rel = pow(-1,Random().nextInt(2)).toInt();
      print("title: " + word.title);
      if (word.title == 'Domingo') rel = 1;
      if (word.title == 'Sábado') rel = -1;
      if (word.title == 'Janeiro') rel = 1;
      if (word.title == 'Dezembro') rel = -1;
      if (word.title == 'Primavera') rel = 1;
      if (word.title == 'Inverno') rel = -1;
      listRel.add(rel);
    }
    _playAudio();
    String wordShow = getWordById(id+listRel[listPosition]).title;
    return ElevatedButton(
        onPressed: () => _playAudio(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 300,
                height: 100,
                alignment: Alignment.center,
                child: getText(wordShow,40,Colors.deepOrange),
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

  void _playAudio() {
    String rel = (listRel[listPosition] > 0)?"antes":"depois";
    audioPlayer.open(
      Playlist(
          audios: [
            Audio("assets/audios/$rel.mp3"),
            Audio("assets/audios/" + (getWordById(listMain[listPosition].id + listRel[listPosition]).id).toString() + ".mp3")
          ]
      ),
    );
  }

  @override
  ButtonTheme getOptionTile(Word wordOption, [double _width=150, double _height=100]) {
    return super.getOptionTile(wordOption,250);
  }
  
  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        word.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 30,
        ),
      ),
    );
  }

}