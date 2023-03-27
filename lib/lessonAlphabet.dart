import 'package:flutter/material.dart';

import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';
import 'package:litera/menu.dart';

class LessonAlphabet extends BaseModule {
  @override
  _LessonAlphabetState createState() => _LessonAlphabetState();
}

class _LessonAlphabetState extends BaseModuleState<LessonAlphabet> {

  Comparator<Object> criteria = (a, b) => (a as Word).title.compareTo((b as Word).title);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.sort(criteria);
  }

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(wordMain.id), // image
        getMainText(60), // letter
        getOnsetTile(wordMain), // image
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar() {
    return AppBar(
      backgroundColor: appBarColor,
      title: Text(title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  String getMainLabel() {
    audioPlay(wordMain.id);
    return wordMain.title.substring(0,1).toUpperCase() + ' ' + wordMain.title.substring(0,1);
  }

}
