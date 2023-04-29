import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonWordPairs extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonWordPairs> {

  // criteria placeholder, not used
  Comparator<Object> criteria = (a, b) => ((a as List<Word>)[0].id).compareTo((b as List<Word>)[0].id);

  Widget getMainTile() {
    Word wordMas = (listProcess[listPosition] as List<Word>)[(fieldTypeMain as List<int>)[0]];
    Word wordFem = (listProcess[listPosition] as List<Word>)[(fieldTypeMain as List<int>)[1]];
    audioPlayer.open(
        Playlist(
            audios: [
              Audio("assets/audios/" + wordMas.id.toString() + ".mp3"),
              Audio("assets/audios/" + wordFem.id.toString() + ".mp3")
            ]
        ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 50),
            getImageTile(wordMas.id, 100), // image
            SizedBox(width: 50),
            getMainText(wordMas,50), // words
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 50),
            getImageTile(wordFem.id, 100), // image
            SizedBox(width: 50),
            getMainText(wordFem,50), // words
          ],
        )
      ],
    );
  }

  @override
  String getMainLabel(word) {
    return super.getMainLabel(word);
  }

}
