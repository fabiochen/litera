import 'package:flutter/material.dart';

import 'word.dart';
import 'baseModule.dart';
import 'globals.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LessonTonic extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonTonic> {

  @override void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.shuffle();
  }

  Widget getMainTile() {
    Globals().printDebug("listProcess count: $listProcess");
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getImageTile(
          wordMain.id,
          backgroundColor: optionColors[wordMain.id%10]!,
        ),
      ],
    );
  }

  @override
  Widget getImage(id, {double width=100, double padding=15, Color backgroundColor=Colors.white}) {
    List listSyllables = wordMain.val1.split('-');
    List<Widget> listWidgets = [];
    Globals().printDebug("# of syllables: " + wordMain.val1.split('-').length.toString());
    Globals().printDebug("accent syllable: " + wordMain.val2);
    for (int i=0; i<listSyllables.length; i++) {
      listWidgets.add(Container(
          alignment: Alignment.center,
          height: mainWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: (wordMain.val2 == (i+1).toString())?Colors.red:Colors.transparent,
                width: 2,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              listSyllables[i],
              style: TextStyle(
                fontSize: mainFontSize,
              ),
            ),
          )
      ));
    }
    Row rowSyllables = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: listWidgets,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: rowSyllables,
    );
  }

}
