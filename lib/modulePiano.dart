import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'dart:async';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

import 'word.dart';

class ModulePiano extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModulePiano> {

  final _midiPro = MidiPro();
  final String _sf2Path = 'assets/audios/FlorestanPiano.sf2';

  int _start = 5;
  bool doCountdown = true;

  int _noteFrequencyPlayed = 0;
  int _audioDelay = 0;
  bool isPressed = false;

  Color _keyColor = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // preload for performance
    precacheImage(AssetImage('assets/images/801.png'),context);
    precacheImage(AssetImage('assets/images/802.png'),context);
    precacheImage(AssetImage('assets/images/803.png'),context);
    precacheImage(AssetImage('assets/images/804.png'),context);
    precacheImage(AssetImage('assets/images/805.png'),context);
    precacheImage(AssetImage('assets/images/806.png'),context);
    precacheImage(AssetImage('assets/images/807.png'),context);
    precacheImage(AssetImage('assets/images/808.png'),context);
    listProcess.shuffle();
  }

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    debugPrint("************** maintile audio ${wordMain.val1}");
    _audioDelay = 3500;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getImageTile(
                    801,
                    imageSize: 100,
                    borderColor: Colors.orange
                  ),
                  ValueListenableBuilder(
                    valueListenable: flagCorrect,
                    builder: (context, value, widget) {
                      saveCorrectionValues();
                      return SizedBox.shrink();
                    },
                  ),
                  (bool.parse(misc.toString())) ? getImageTile(wordMain.id, imageSize: 100, borderColor: Colors.blue) : getSoundTile(wordMain,Colors.blue),
                  ValueListenableBuilder(
                    valueListenable: flagWrong,
                    builder: (context, value, widget) {
                      saveCorrectionValues();
                      return SizedBox.shrink();
                    },
                  ),
                  Text("?",
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )
                  ),  // question mark
                ],
              ),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: VirtualPiano(
                noteRange: const RangeValues(60, 72),
                highlightedNoteSets: [
                  HighlightedNoteSet({60}, Colors.orange),
                  HighlightedNoteSet({_noteFrequencyPlayed}, _keyColor),
                ],
                onNotePressed: (note, pos) {
                  switch (note) {
                    case 60:
                    case 62:
                    case 64:
                    case 65:
                    case 67:
                    case 69:
                    case 71:
                    case 72:
                    processNoteFromFrequency(note);
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  void startCountdown() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            doCountdown = false;
            useNavigation = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void processNoteFromFrequency(freq) async {
    listProcess.forEach((element) {
      Word word = element as Word;
      if (int.parse(word.val1) == freq) {
        _noteFrequencyPlayed = freq;
        audioPlay(word.id);
      };
    });
    bool isCorrect = _noteFrequencyPlayed == int.parse(wordMain.val1);
    setState(() {
      if (type == ModuleType.TEST) {
        if (isCorrect) {
          flagCorrect.value = 1;
          correctCount++;
        } else {
          flagWrong.value = 1;
          wrongCount++;
        }
      }
      if (isCorrect) {
        _keyColor = Colors.green;
      } else {
        _keyColor = Colors.red;
      }
    });
    Globals().t2 = Timer(Duration(milliseconds: 2000), () {
      audioPlay(isCorrect);
      setState(() {
        _keyColor = Colors.white;
        if (isCorrect || (type == ModuleType.TEST)) {
          Globals().t3 = Timer(Duration(milliseconds: 1000), () {
            next();
          });
        }
      });
    });
  }

}