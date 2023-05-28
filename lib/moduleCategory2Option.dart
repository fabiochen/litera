import 'package:flutter/material.dart';
import 'word.dart';
import 'baseOptionTiles.dart';
import 'globals.dart';

class ModuleCategory2Option extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleCategory2Option> {

  @override
  Widget getMainTile() {
    Globals().printDebug("moduleCategoryOption: getMainTile");
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      List<int> listCategories = [];
      listProcess2.forEach((map) {
        listCategories.add(int.parse((map as Map).keys.first));
      });
      Set<int> setOptions = Set();
      int processedIndex = listProcess.indexWhere((word) => (word as Word).processed == false);
      wordMain = listProcess[processedIndex] as Word;
      wordMain.processed = true;
      listProcess[processedIndex] = wordMain;
      List<Word> temp = [];
      listMain.add(wordMain);
      listCategories.shuffle();
      // use Set class for unique category values
      setOptions.add(int.parse(wordMain.val3));
      setOptions.add(listCategories[0]);
      setOptions.add(listCategories[1]);
      // setOptions.add(listCategories[2]);
      if (setOptions.length == 3) setOptions.add(listCategories[3]);
      Word wordTemp = wordMain;
      temp.add(wordTemp);
      wordTemp = Globals().getWordFromId(setOptions.elementAt(1));
      wordTemp.val3 = setOptions.elementAt(1).toString();
      temp.add(wordTemp);
      // wordTemp = Globals().getWordFromId(setOptions.elementAt(2));
      // wordTemp.val3 = setOptions.elementAt(2).toString();
      // temp.add(wordTemp);
      // wordTemp = Globals().getWordFromId(setOptions.elementAt(3));
      // wordTemp.val3 = setOptions.elementAt(3).toString();
      // temp.add(wordTemp);
      temp.shuffle();
      listOption1.add(temp[0]);
      listOption2.add(temp[1]);
      // listOption3.add(temp[2]);
      // listOption4.add(temp[3]);
    }
    wordMain = listMain[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption1[listPosition]),
              getOptionTile(listOption2[listPosition])
            ],
          ),
        ),
        Flexible(child: getCenterTile(listMain[listPosition])),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       getOptionTile(listOption3[listPosition]),
        //       getOptionTile(listOption4[listPosition])
        //     ],
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget getCenterTile(word) {
    return getTextTile(word);
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color? backgroundColor=Colors.white, Color? borderColor=Colors.white, Color fontColor= Colors.teal, double width=300, double height=200, bool containsAudio=true}) {
    int id = word.id;
    return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: width,
                height: 100,
                alignment: Alignment.center,
                child: getText(word.val1,60,Colors.deepOrange),
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue,
                size: 40,
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57401, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 40,
              ),
            ), // second icon to "paint" previous transparent icon
          ],
        )
    );
  }

  @override
  Widget getOptionValue(Word word, [double fontSize=50]) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        Globals().getWordFromId(int.parse(word.val3)).title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 30,
        ),
      ),
    );
  }

}