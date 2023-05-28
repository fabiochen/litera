import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

class LessonSyllablesConsonantsVowels extends BaseModule {
  @override
  _LessonSyllablesConsonantsVowelsState createState() => _LessonSyllablesConsonantsVowelsState();
}

class _LessonSyllablesConsonantsVowelsState extends BaseModuleState<LessonSyllablesConsonantsVowels> {

  int _selectedConsonant = 0;
  int _selectedVowel = 0;

  @override
  Widget getMainTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 60,
                      scrollController: FixedExtentScrollController(initialItem: 0),
                      children: [
                        ...Globals().listOnsetConsonants.map((value) {
                          return Text(
                            value.title,
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.green,
                            ),
                          );
                        }).toList(),
                      ],
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _selectedConsonant = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                    onPressed: () => audioPlay(Globals().listOnsetConsonants[_selectedConsonant].id),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white
                    ),
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/images/voice-onset.png'),
                          width: 100,
                          gaplessPlayback: true,
                        ),
                        Positioned(
                          bottom: 10, right: 0,
                          child: Icon(
                            IconData(57400, fontFamily: 'LiteraIcons'),
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                        Positioned(
                          bottom: 10, right: 0,
                          child: Icon(
                            IconData(57401, fontFamily: 'LiteraIcons'),
                            color: Colors.white,
                            size: 40,
                          ),
                        ), // second icon to "paint" previous transparent icon
                      ],
                    )
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  color: Colors.red,
                  width: 150,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 60,
                      scrollController: FixedExtentScrollController(initialItem: 0),
                      children: [
                        ...Globals().listVowels.map((value) {
                          return Text(
                            value.title,
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.red,
                            ),
                          );
                        }).toList(),
                      ],
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _selectedVowel = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                    onPressed: () => audioPlay(Globals().listVowels[_selectedVowel].id),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white
                    ),
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/images/voice-onset.png'),
                          width: 100,
                          gaplessPlayback: true,
                        ),
                        Positioned(
                          bottom: 10, right: 0,
                          child: Icon(
                            IconData(57400, fontFamily: 'LiteraIcons'),
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                        Positioned(
                          bottom: 10, right: 0,
                          child: Icon(
                            IconData(57401, fontFamily: 'LiteraIcons'),
                            color: Colors.white,
                            size: 40,
                          ),
                        ), // second icon to "paint" previous transparent icon
                      ],
                    )
                ),
              ],
            ),
          ],
        ),  // consonant/vowel text & audio
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Globals().listOnsetConsonants[_selectedConsonant].title,
              style: TextStyle(
                fontSize: 80,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              Globals().listVowels[_selectedVowel].title,
              style: TextStyle(
                fontSize: 80,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),  // syllable
        SizedBox(height: 10),
        ElevatedButton(
            onPressed: () => _playSyllableAudio(),
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
        )  // syllable audio
      ],
    );
  }

  void _playSyllableAudio() {
    late int itemId;
    String _syllable = Globals().listOnsetConsonants[_selectedConsonant].title + Globals().listVowels[_selectedVowel].title;
    Globals().listSyllables.forEach((element) {
      if (element.title == _syllable) itemId=element.id;
    });
    audioPlay(itemId);
  }

}
