import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

class LessonWordsConsonantsVowels extends BaseModule {
  @override
  _LessonWordsConsonantsVowelsState createState() => _LessonWordsConsonantsVowelsState();
}

class _LessonWordsConsonantsVowelsState extends BaseModuleState<LessonWordsConsonantsVowels> {

  int _selectedChars = 0;
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = FixedExtentScrollController(initialItem: 0);
  }

  Widget getMainTile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 60,
                  scrollController: controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          mapWordMatch.elementAt(listPosition).entries.first.key,
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    )
                  ],
                  onSelectedItemChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Container(
                width: 180,
                height: 100,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 60,
                  scrollController: controller,
                  children: [
                    ...mapWordMatch.elementAt(listPosition).values.first.map((word) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            word.title.replaceAll(mapWordMatch.elementAt(listPosition).entries.first.key,''),
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  onSelectedItemChanged: (value) {
                    setState(() {
                      _selectedChars = value;
                    });
                  },
                ),
              ),
            ],
          ),  // consonant/vowel text
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mapWordMatch.elementAt(listPosition).entries.first.key,
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                mapWordMatch.elementAt(listPosition).values.first[_selectedChars].title.replaceAll(mapWordMatch.elementAt(listPosition).entries.first.key,''),
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),  // syllable
          SizedBox(height: 40),
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
      ),
    );
  }

  void _playSyllableAudio() {
    int itemId = mapWordMatch.elementAt(listPosition).values.first[_selectedChars].id;
    audioPlay(itemId);
  }

  @override
  void next() {
    _selectedChars = 0;
    controller.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
    super.next();
  }

  @override
  void previous() {
    _selectedChars = 0;
    controller.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
    super.previous();
  }

}
