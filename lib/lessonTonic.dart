import 'package:flutter/material.dart';

import 'word.dart';
import 'baseModule.dart';

class LessonTonic extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonTonic> {

  @override void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.shuffle();
  }

  @override
  Widget getMainTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 50),
        Flexible(child: getSyllablesTile()),
        SizedBox(height: 50),
      ],
    );
  }

  Widget getSyllablesTile() {
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    List listSyllables = wordMain.val1.split('-');
    List<Widget> listWidgets = [];
    List<Widget> listOrder = [];
    print("# of syllables: " + wordMain.val1.split('-').length.toString());
    print("accent syllable: " + wordMain.val2);
    for (int i=0; i<listSyllables.length; i++) {
      listOrder.add(Container(
          alignment: Alignment.center,
          width: widthMain,
          height: widthMain,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: (wordMain.val2 == (i+1).toString())?Colors.red:Colors.transparent,
                width: 2,
              )
          ),
          child: getText((listSyllables.length-i).toString(),fontSizeMain-15,Colors.blue)
      ));
      listWidgets.add(Container(
              alignment: Alignment.center,
              width: widthMain,
              height: widthMain,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: (wordMain.val2 == (i+1).toString())?Colors.red:Colors.transparent,
                    width: 2,
                  )
              ),
              child: getText(listSyllables[i],fontSizeMain)
          ));
    }
    Row row1 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listWidgets,
    );
    // Row row2 = Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: listOrder,
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // row2,
        // SizedBox(height: 30),
        row1,
      ],
    );
  }
}
