import 'package:flutter/material.dart';
import 'package:litera/word.dart';

import 'baseModule.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

class UnitPiano extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<UnitPiano> {

  int _noteId = 801;
  int _noteFrequency = 60;
  String _noteName = 'dó';

  @override void didChangeDependencies() {
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
  }

  @override
  void initState() {
    backgroundColor = Colors.white;
    super.initState();
  }

  @override
  Widget getMainTile() {
    audioPlay(_noteId);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 200,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 5 ),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Image.asset('assets/images/$_noteId.png'),
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      _noteName.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 80,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,20),
              child: VirtualPiano(
                noteRange: const RangeValues(60, 72),
                highlightedNoteSets: [
                  HighlightedNoteSet({_noteFrequency}, Colors.orange),
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
                      setState(() {
                        processNoteFromFrequency(note);
                      });
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  void processNoteFromFrequency(freq) {
    listProcess.forEach((element) {
      Word word = element as Word;
      if (int.parse(word.val1) == freq) {
        _noteName = word.title;
        _noteId = word.id;
        _noteFrequency = freq;
      };
    });
  }

}