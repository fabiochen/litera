import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'dart:async';

import 'baseOptionTiles.dart';
import 'word.dart';

class ModuleSound2Images extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleSound2Images> {

  final _midiPro = MidiPro();
  final String _sf2Path = 'assets/audios/FlorestanPiano.sf2';

  int _start = 5;
  bool firstTime = true;

  @override
  void initState() {
    _midiPro.loadSoundfont(sf2Path: _sf2Path);
    super.initState();
    audioMidi("60",1000);
    startTimer();
  }

  @override
  Widget getMainTile() {
    if (firstTime) return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            getImageTile(801, imageSize: 150), // dó
            Text("DÓ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 80,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        SizedBox(height: 50),
        Text("$_start",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 100,
            color: Colors.red,
          ),
        ),
      ],
    );
    return super.getMainTile();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            firstTime = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Widget getCenterTile(word) {
    audioMidi(word.val1);
    return getSoundTile(word);
  }

  ElevatedButton getSoundTile(Word word) {
    audioMidi(word.val1);
    return ElevatedButton(
        onPressed: () => audioMidi(word.val1),
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

  void audioMidi(String id, [int delay=500]) async {
    int note = int.parse(id);
    await Future.delayed(Duration(milliseconds: delay));
    _midiPro.playMidiNote(midi: note, velocity: 127);
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return getImage(word.id);
  }

}