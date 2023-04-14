import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'baseModule.dart';
import 'word.dart';
import 'globals.dart';

class LessonClock extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonClock> {

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    int hr = int.parse(wordMain.title.substring(0,2));
    int mn = int.parse(wordMain.title.substring(3,5));
    playTime(hr, mn);
    return AnalogClock(
      decoration: BoxDecoration(
          border: Border.all(width: 10.0, color: Colors.teal),
          color: Colors.transparent,
          shape: BoxShape.circle),
      width: 300.0,
      isLive: false,
      hourHandColor: Colors.deepOrange,
      minuteHandColor: Colors.black,
      showSecondHand: false,
      numberColor: Colors.teal,
      showNumbers: true,
      showAllNumbers: true,
      textScaleFactor: 1.0,
      showTicks: false,
      showDigitalClock: false,
      datetime: DateTime(2019, 1, 1, hr, mn, 00),
    );
  }

  playTime(int hr, [int min=0]) {
    String strHr = (400+hr).toString();
    String strHrEnding = "horas";
    String strMin = (600+min).toString();
    if (min == 0) {
      if (hr == 1) strHrEnding = "hora";
      if (hr >  1) strHrEnding = "horas";
      audioPlayer.open(
        Playlist(
            audios: [
              Audio("assets/audios/$strHr.mp3"),
              Audio("assets/audios/$strHrEnding.mp3")
            ]
        ),
      );
    } else {
      if (hr == 1) strHrEnding = "hora_e";
      if (hr >  1) strHrEnding = "horas_e";
      audioPlayer.open(
        Playlist(
            audios: [
              Audio("assets/audios/$strHr.mp3"),
              Audio("assets/audios/$strHrEnding.mp3"),
              Audio("assets/audios/$strMin.mp3"),
              Audio("assets/audios/minutos.mp3"),
            ]
        ),
      );
    }
  }

}