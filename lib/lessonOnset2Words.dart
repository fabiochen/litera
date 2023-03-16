import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:litera/word.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseOptionTiles.dart';

import 'package:audioplayers/audioplayers.dart';

class LessonOnset2Words extends BaseOptionTiles {
  @override
  _LessonOnset2WordsState createState() => _LessonOnset2WordsState();
}

class _LessonOnset2WordsState extends BaseOptionTilesState<LessonOnset2Words> {
  int _testWordId;

  @override
  ButtonTheme getOptionTile(int optionId, [int type=0]) {
    Word onset = listProcess[listPosition];
    List<Word> filteredList = listVocab.where((word) => word.title.startsWith(onset.title)).toList();
    Word word = filteredList[optionId];

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
  Widget getCenterTile() {
    Word onset = listProcess[listPosition];
    audioPlayOnset(onset.title);
    return getOnsetTile(onset);
  }

  void _playTileAudio(Object itemId) {
    Word onset = listProcess[listPosition];
    Word testWord = alphabetOnsetList.firstWhere((word) => word.title.startsWith(onset.title));
    _testWordId = testWord.id;
    AudioCache audioCache = AudioCache();
    if (Platform.isIOS)
      audioCache.fixedPlayer?.notificationService?.startHeadlessService();
    audioStop();
    audioPlay(_testWordId);
    t2 = Timer(Duration(milliseconds: 1000), () async {
      audioPlayer = await audioCache.play('audios/$itemId.mp3');
    });
  }

}
