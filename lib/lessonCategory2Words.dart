import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'word.dart';
import 'baseModule.dart';
import 'globals.dart';

class LessonCategory2Words extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonCategory2Words> {

  int _selectedSyllable = 0;
  int _selectedWord = 0;
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = FixedExtentScrollController(initialItem: 0);
  }

  @override
  Widget getBody() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 60,
                      scrollController: FixedExtentScrollController(initialItem: 0),
                      children: [
                        ...(listProcess as List<Map<String, List<Word>>>).map((value) {
                          Map<String,List<Word>> map = value;
                          String text = map.keys.first.toString();
                          text = Globals().getCategoryFromId(listProcess2, int.parse(text)).title;
                          return Text(
                            text,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.green,
                            ),
                          );
                        }).toList(),
                      ],
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _selectedSyllable = value;
                          controller.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () => _audioPlayCategory(),
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
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 60,
                      scrollController: controller,
                      children: [
                        ...(listProcess as List<Map<String, List<Word>>>).elementAt(_selectedSyllable).values.first.map((word) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20,0,0,0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    word.title.substring(0,2),
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    word.title.substring(2),
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _selectedWord = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () => _audioPlayWord(),
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
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _audioPlayWord() {
    List<Word> listWord = (listProcess as List<Map<String, List<Word>>>).elementAt(_selectedSyllable).values.first;
    int itemId = listWord[_selectedWord].id;
    audioPlay(itemId);
  }

  void _audioPlayCategory() {
    Map<String,List> map = (listProcess as List<Map<String,List<Word>>>).elementAt(_selectedSyllable);
    String _syllable = map.keys.first.toString();
    Word word = Globals().getCategoryFromId(listProcess2, int.parse(_syllable));
    audioPlay(word.id);
  }

}
