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
    Word wordMas = (listProcess[listPosition] as List<Word>)[(mainFieldType as List<int>)[0]];
    Word wordFem = (listProcess[listPosition] as List<Word>)[(mainFieldType as List<int>)[1]];
    Globals().audioPlayer.open(
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
        Expanded(child:getImageTile(wordMas.id, imageSize: 100)), // image
        getMainText(wordMas,50), // words
        Expanded(child:getImageTile(wordFem.id, imageSize: 100)), // image
        getMainText(wordFem,50), // words
      ],
    );
  }

  @override
  String getMainLabel(word) {
    return super.getMainLabel(word);
  }

}
