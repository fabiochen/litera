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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.green,
                      width: 5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.green,
                      width: 5,
                    ),
                  ),
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
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => audioPlay(Globals().listOnsetConsonants[_selectedConsonant].id),
                    style: Globals().buttonStyle(),
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/images/voice-onset.png'),
                          width: 80,
                          gaplessPlayback: true,
                        ),
                        Positioned(
                          bottom: 11, right: 1,
                          child: Icon(
                            IconData(57400, fontFamily: 'LiteraIcons'),
                            color: Colors.green,
                            size: 38,
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
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.red,
                      width: 5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.red,
                      width: 5,
                    ),
                  ),
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
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => audioPlay(Globals().listVowels[_selectedVowel].id),
                    style: Globals().buttonStyle(),
                    child: Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/images/voice-onset.png'),
                          width: 80,
                          gaplessPlayback: true,
                        ),
                        Positioned(
                          bottom: 11, right: 1,
                          child: Icon(
                            IconData(57400, fontFamily: 'LiteraIcons'),
                            color: Colors.red,
                            size: 38,
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
            style: Globals().buttonStyle(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  IconData(57400, fontFamily: 'LiteraIcons'),
                  color: Colors.blue,
                  size: 69,
                ),
                Icon(
                  IconData(57401, fontFamily: 'LiteraIcons'),
                  color: Colors.white,
                  size: 70,
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
