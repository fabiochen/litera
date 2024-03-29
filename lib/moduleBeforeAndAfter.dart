import 'dart:math';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:litera/baseOptionTiles.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ModuleBeforeAndAfter extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleBeforeAndAfter> {

  List<int> listRel = [];

  int maxLines = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      maxLines = int.parse(misc.toString());
    } catch (e) {
    }
  }

  @override
  Widget getCenterTile(word) {
    Globals().printDebug("listPosition: $listPosition option1.length: " + listOption1.length.toString());
    if (listPosition == 0 || listPosition >= listOption1.length-1) {
      int rel = pow(-1,Random().nextInt(2)).toInt();
      Globals().printDebug("value: " + word.val1);
      // set endpoint rel values
      switch (mainFieldType) {
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
    Globals().printDebug("contains audio: $containsAudio");
    if (containsAudio) return getSoundTile(word);
    return getTextTile(word);
  }

  Widget getText(String text, [double fontSize = 100, Color color = Colors.teal, String fontFamily = 'LiteraIcons']) {
    String rel = (listRel[listPosition] > 0)?"Antes":"Depois";
    text = Globals().getCategoryFromId(listProcess, listMain[listPosition].id + listRel[listPosition]).title;
    text = rel + " de $text";
    return super.getText(text, fontSize, Colors.red, fontFamily);
  }

  ElevatedButton getSoundTile(Word word, {Color borderColor=Colors.white}) {
    _playAudio();
    return ElevatedButton(
        onPressed: () => _playAudio(),
        style: Globals().buttonStyle(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              IconData(57400, fontFamily: 'LiteraIcons'),
              color: Colors.blue,
              size: 99,
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
    Globals().printDebug("rel: $rel");
    Globals().audioPlayer.open(
      Playlist(
          audios: [
            Audio("assets/audios/$rel.mp3"),
            Audio("assets/audios/" + (Globals().getCategoryFromId(listProcess, listMain[listPosition].id + listRel[listPosition]).id).toString() + ".mp3")
          ]
      ),
    );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    String text = '';
    switch(mainFieldType) {
      case FieldType.TITLE:
        text = word.title;
        break;
      case FieldType.VAL1:
        text = word.val1.substring(0,1);
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        minFontSize: 20,
        maxLines: maxLines,
        style: TextStyle(
          color: Colors.teal,
          fontSize: optionFontSize,
        ),
      ),
    );
  }

}