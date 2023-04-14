import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'baseModule.dart';
import 'word.dart';
import 'globals.dart';

class LessonClockDigital extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonClockDigital> {

  int _selectedHour = 0;
  int _selectedMinute = 0;

  Widget getMainTile() {
    print("hour: $_selectedHour");
    print("min: $_selectedMinute");
    Word hr = listTimeHour.elementAt(_selectedHour);
    Word mn = listTimeMinutes.elementAt(_selectedMinute);
    int valHr  = int.parse(hr.title);
    int valMin = int.parse(mn.title);
    print("Hr: " + hr.title);
    print("Mn: " + mn.title);
    playTime(valHr, valMin);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 40),
        Flexible(child: AnalogClock(
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
          datetime: DateTime(2019, 1, 1, valHr, valMin, 00),
        )),
        Flexible(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 100,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                children: [
                  ...listTimeHour.map((word) {
                    String title = word.title;
                    return Text(
                      title,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.deepOrange,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {_selectedHour = value;});
                },
              ),
            ),  // hour
            Container(
              width:50,
              alignment: Alignment.center,
              child: Text(
                ":",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.green,
                ),
              )),  // :
            Container(
              width: 150,
              height: 100,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                children: [
                  ...listTimeMinutes.map((word) {
                    String title = word.title;
                    return Text(
                      title,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.green,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {_selectedMinute = value;});
                },
              ),
            ),  // minutes
          ],
        )),  // consonant/vowel text
      ],
    );
  }

  playTime(int hr, [int min=0]) {
    audioPlayer.stop();
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