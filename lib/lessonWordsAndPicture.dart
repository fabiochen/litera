import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:litera/word.dart';

import 'baseModule.dart';
import 'globals.dart';

class LessonWordsAndPicture extends BaseModule {
  @override
  _LessonWordsAndPictureState createState() => _LessonWordsAndPictureState();
}

class _LessonWordsAndPictureState extends BaseModuleState<LessonWordsAndPicture> {

  @override
  Widget getMainText(
      Word word,
      double fontSize,
      {String fontFamily = "Litera-Regular",
        Color fontColor = Colors.teal,
        Color backgroundColor = Colors.white
      }
      ) {
    return SizedBox(
      height: 100,
      child: super.getMainText(word, fontSize,
        backgroundColor: optionColors[listPosition%10]!,
      ),
    );
  }

    @override
  Widget getImage(id, {double width=100, double padding=15, backgroundColor=Colors.white}) {
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
    return super.getImage(id,width:width,padding:padding,backgroundColor: backgroundColor);
  }

}
