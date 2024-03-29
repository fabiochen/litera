import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'word.dart';
import 'baseModule.dart';
import 'globals.dart';

class UnitCategory2Words extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<UnitCategory2Words> {

  int _selectedSyllable = 0;
  int _selectedWord = 0;
  late FixedExtentScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = FixedExtentScrollController(initialItem: 0);
  }

  @override
  Widget getMainTile() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
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
              Container(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => _audioPlayCategory(),
                      style: Globals().buttonStyle(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            IconData(57400, fontFamily: 'LiteraIcons'),
                            color: Colors.blue,
                            size: 49,
                          ),
                          Icon(
                            IconData(57401, fontFamily: 'LiteraIcons'),
                            color: Colors.white,
                            size: 50,
                          ), // second icon to "paint" previous transparent icon
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 220,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
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
              Container(
                height:80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => _audioPlayWord(),
                      style: Globals().buttonStyle(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            IconData(57400, fontFamily: 'LiteraIcons'),
                            color: Colors.blue,
                            size: 49,
                          ),
                          Icon(
                            IconData(57401, fontFamily: 'LiteraIcons'),
                            color: Colors.white,
                            size: 50,
                          ), // second icon to "paint" previous transparent icon
                        ],
                      )
                  ),
                ),
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
