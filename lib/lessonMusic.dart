import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

import 'baseModule.dart';
import 'globals.dart';

class LessonMusic extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonMusic> {

  final _midiPro = MidiPro();
  final String _sf2Path = 'assets/audios/FlorestanPiano.sf2';

  @override
  void initState() {
    _midiPro.loadSoundfont(sf2Path: _sf2Path);
    super.initState();
  }

  @override
  void audioPlay(id) async {
    int note = int.parse(wordMain.val1);
    await Future.delayed(const Duration(milliseconds: 1000));
    _midiPro.playMidiNote(midi: note, velocity: 127);
  }

  @override
  String getMainLabel(text) {
    return text.toUpperCase();
  }

  @override
  Padding getImage(int id, [double width=100, double padding=15]) {
    Globals().printDebug("title: $title");
    if (title == 'Lição: Cores')
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: width,
          height: width,
          decoration: new BoxDecoration(
            border: Border.all(),
            color: Color(int.parse(wordMain.val1)),
            shape: BoxShape.circle,
          ),
        ));
    return super.getImage(id,width,padding);
  }

}
