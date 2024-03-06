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
              fontSize: mainFontSize,
              fontWeight: FontWeight.bold
            ),
          ), // category
          Expanded(
            child: getImageTile((listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).values.first[_selectedChars].id)
          ),
          SizedBox(height: 20),
          Container(
            width: 250,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: Colors.red,
                width: 5,
              ),
            ),
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
              scrollController: controller,
              children: [
                ...(listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).values.first.map((word) {
                  String label = '';
                  switch (mainFieldType) {
                    case (FieldType.VAL1):
                      label = word.val1.replaceAll((listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).entries.first.key,'');
                      break;
                    default:
                      label = word.title.replaceAll((listProcess as List<Map<String, List<Word>>>).elementAt(listPosition).entries.first.key,'');
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        label,
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
  void next([bool refresh=true]) {
    _selectedChars = 0;
    controller.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
    super.next(refresh);
  }

  @override
  void previous([bool refresh=true]) {
    _selectedChars = 0;
    controller.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
    super.previous(refresh);
  }

}
