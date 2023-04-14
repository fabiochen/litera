import 'dart:math';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class ModuleBeforeAndAfter extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleBeforeAndAfter> {

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
    print("listPosition: $listPosition option1.length: " + option1.length.toString());
    if (listPosition == 0 || listPosition >= option1.length-1) {
      int rel = pow(-1,Random().nextInt(2)).toInt();
      print("value: " + word.value);
      if (word.value == 'a') rel = 1;
      if (word.value == 'z') rel = -1;
      listRel.add(rel);
    }
    _playAudio();
    String wordShow = (listRel[listPosition] > 0)? '__ ' + getWordById(id+listRel[listPosition]).value: getWordById(id+listRel[listPosition]).value + ' __';
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
                child: getText(wordShow,50,Colors.deepOrange),
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
            Audio("assets/audios/" + (getWordById(optionMain[listPosition].id + listRel[listPosition]).id).toString() + ".mp3")
          ]
      ),
    );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        word.value.substring(0,1),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: fontSize,
        ),
      ),
    );
  }

}