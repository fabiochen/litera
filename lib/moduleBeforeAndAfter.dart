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
  Widget getCenterTile(word) {
    print("listPosition: $listPosition option1.length: " + listOption1.length.toString());
    if (listPosition == 0 || listPosition >= listOption1.length-1) {
      int rel = pow(-1,Random().nextInt(2)).toInt();
      print("value: " + word.val1);
      // set endpoint rel values
      switch (fieldTypeMain) {
        case FieldType.TITLE:
          if (word.title == 'Domingo') rel = 1;
          if (word.title == 'Sábado') rel = -1;
          if (word.title == 'Janeiro') rel = 1;
          if (word.title == 'Dezembro') rel = -1;
          if (word.title == 'Primavera') rel = 1;
          if (word.title == 'Inverno') rel = -1;
          if (word.title == 'Mercúrio') rel = 1;
          if (word.title == 'Netuno') rel = -1;
          break;
        case FieldType.VAL1:
          if (word.val1.substring(0,1) == 'a') rel = 1;
          if (word.val1.substring(0,1) == 'z') rel = -1;
          if (word.val1.substring(0,1) == '1') rel = 1;
          if (word.val1.substring(0,1) == '9') rel = -1;
          break;
      }
      listRel.add(rel);
    }
    print("contains audio: $containsAudio");
    if (containsAudio) return getSoundTile(word);
    return getTextTile(word);
  }

  Text getText(String text, [double fontSize = 100, Color color = Colors.teal]) {
    String rel = (listRel[listPosition] > 0)?"Antes":"Depois";
    text = getWordById(listMain[listPosition].id + listRel[listPosition]).title;
    text = rel + " de $text";
    return super.getText(text, fontSize, Colors.red);
  }

  ElevatedButton getSoundTile(Word word) {
    _playAudio();
    return ElevatedButton(
        onPressed: () => _playAudio(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Icon(
              IconData(57400, fontFamily: 'LiteraIcons'),
              color: Colors.blue,
              size: 100,
            ),
            Icon(
              IconData(57401, fontFamily: 'LiteraIcons'),
              color: Colors.white,
              size: 100,
            ), // second icon to "paint" previous transparent icon
          ],
        )
    );
  }

  void _playAudio() {
    String rel = (listRel[listPosition] > 0)?"antes":"depois";
    Globals().audioPlayer.open(
      Playlist(
          audios: [
            Audio("assets/audios/$rel.mp3"),
            Audio("assets/audios/" + (getWordById(listMain[listPosition].id + listRel[listPosition]).id).toString() + ".mp3")
          ]
      ),
    );
  }

  @override
  Widget getOptionValue(Word word) {
    String text = '';
    switch(fieldTypeMain) {
      case FieldType.TITLE:
        text = word.title;
        break;
      case FieldType.VAL1:
        text = word.val1.substring(0,1);
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: fontSizeOption,
        ),
      ),
    );
  }

}