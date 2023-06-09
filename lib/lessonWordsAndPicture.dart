import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'baseModule.dart';
import 'globals.dart';

class LessonWordsAndPicture extends BaseModule {
  @override
  _LessonWordsAndPictureState createState() => _LessonWordsAndPictureState();
}

class _LessonWordsAndPictureState extends BaseModuleState<LessonWordsAndPicture> {

  @override
  Padding getImage(int id, [double width=100, double padding=15]) {
    Globals().printDebug("title: $title");
    if (title == 'Lição: Cores')
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: width,
          height: width,
          decoration: new BoxDecoration(
            border: Border.all(),
            color: Color(int.parse(wordMain.val1)),
            shape: BoxShape.circle,
          ),
        ));
    return super.getImage(id,width,padding);
  }

}
