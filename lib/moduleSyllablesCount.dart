import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/word.dart';
import 'package:litera/baseOptionTiles.dart';

class ModuleSyllablesCount extends BaseOptionTiles {
  @override
  _State createState() => _State();
}

class _State extends BaseOptionTilesState<ModuleSyllablesCount> {

  int syllableOption=0;

  @override
  Widget getMainTile() {
    print("moduleSyllablesCount: getMainTile");
    syllableOption = 0;
    listProcess.shuffle();
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      wordMain = listProcess[0] as Word;
      listMain.add(wordMain);
      List<String> listSyllables = wordMain.val1.split('-');
      print("word: " + wordMain.title);
      print("syllable #: " + listSyllables.length.toString());
      switch (listSyllables.length) {
        case 1:
          listOption1.add(listProcess[0] as Word);
          listOption2.add(listProcess[1] as Word);
          listOption3.add(listProcess[2] as Word);
          listOption4.add(listProcess[3] as Word);
          break;
        case 2:
          listOption1.add(listProcess[1] as Word);
          listOption2.add(listProcess[0] as Word);
          listOption3.add(listProcess[2] as Word);
          listOption4.add(listProcess[3] as Word);
          break;
        case 3:
          listOption1.add(listProcess[1] as Word);
          listOption2.add(listProcess[2] as Word);
          listOption3.add(listProcess[0] as Word);
          listOption4.add(listProcess[3] as Word);
          break;
        case 4:
          listOption1.add(listProcess[1] as Word);
          listOption2.add(listProcess[2] as Word);
          listOption3.add(listProcess[3] as Word);
          listOption4.add(listProcess[0] as Word);
          break;
      }
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption3[listPosition]),
              getOptionTile(listOption4[listPosition])
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget getCenterTile(word) {
    return getTextTile(word);
  }

  ElevatedButton getTextTile(Word word, [double fontSize=50, Color color= Colors.teal, double width=300, bool containsAudio=true]) {
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
                child: getText(word.title,40,Colors.deepOrange),
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
    syllableOption++;
    if (syllableOption > 4) syllableOption = 1;
    print("number of syllables: $syllableOption");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        syllableOption.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 30,
        ),
      ),
    );
  }

}
