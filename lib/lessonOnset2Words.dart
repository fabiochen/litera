import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:litera/word.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseOptionTiles.dart';

//import 'package:audioplayers/audioplayers.dart';

class LessonOnset2Words extends BaseOptionTiles {
  @override
  _LessonOnset2WordsState createState() => _LessonOnset2WordsState();
}

class _LessonOnset2WordsState extends BaseOptionTilesState<LessonOnset2Words> {
  late int _testWordId;

  @override
  Widget getMainTile() {
    Word onset = listOriginal[listPosition] as Word;
    print("onset0: " + onset.title);
    listProcess = listVocab.where((word) => word.title.startsWith(onset.title)).toList();
    printList(listProcess);
    return super.getMainTile();
  }

  @override
  ButtonTheme getOptionTile(Word word, [double _width=150, double _height=100]) {
    print("tile word: " + word.title);
    return ButtonTheme(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _playTileAudio(word.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image(
                        image: AssetImage('assets/images/' + word.id.toString() + '.png'),
                        width: 80,
                        gaplessPlayback: true,
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Icon(
                        IconData(57400, fontFamily: 'LiteraIcons'),
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Icon(
                        IconData(57401, fontFamily: 'LiteraIcons'),
                        color: Colors.white,
                        size: 30,
                      ),
                    ), // second icon to "paint" previous transparent icon
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      word.title.substring(0,1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      word.title.substring(1),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ],
      )
    );
  }

  @override
  Widget getCenterTile(onset) {
    Word onset = listProcess[listPosition] as Word;
    print("onset1: " + onset.title);
    audioPlayOnset(onset.title.substring(0,1));
    return getOnsetTile(onset);
  }

  void _playTileAudio(Object itemId) {
    Word onset = listProcess[listPosition] as Word;
    print("onset2: " + onset.title);
    Word testWord = alphabetOnsetList.firstWhere((word) => word.title.startsWith(onset.title.substring(0,1)));
    _testWordId = testWord.id;
    audioStop();
    audioPlayer.open(
      Playlist(
          audios: [
            Audio("assets/audios/$_testWordId.mp3"),
            Audio("assets/audios/$itemId.mp3")
          ]
      ),
    );
  }

}
