import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'word.dart';

class LessonCategory2Word2Picture extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonCategory2Word2Picture> {

  int _selectedChars = 0;
  late FixedExtentScrollController controller;

  Comparator<Object> criteria = (a, b) => ((a as Map<String, List<Word>>).length).compareTo((b as Map<String, List<Word>>).length);

  @override
  void initState() {
    super.initState();
    controller = FixedExtentScrollController(initialItem: 0);
  }

  Widget getMainTile() {
    String category = (listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).entries.first.key;
    category = Globals().getCategoryFromId(listProcess2,int.parse(category)).title;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            category.toUpperCase(),
            style: TextStyle(
              color: Globals().appBarColorDark,
              fontSize: fontSizeMain,
              fontWeight: FontWeight.bold
            ),
          ), // category
          Expanded(child: getImage((listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).values.first[_selectedChars].id, widthMain)),
          Container(
            width: 250,
            height: 100,
            child: CupertinoPicker(
              backgroundColor: Colors.white,
              itemExtent: 60,
              scrollController: controller,
              children: [
                ...(listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).values.first.map((word) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        word.title.replaceAll((listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).entries.first.key,''),
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
          )
        ],
      ),
    );
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
