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
    Globals().printDebug("moduleSyllablesCount: getMainTile");
    listProcess.shuffle();
    syllableOption = 0;
    Globals().printDebug("moduleSyllablesCount: getMainTile syllable option: $syllableOption");
    // get new random number only going forward.  going back gets value from stored list.
    if (listPosition == 0 || listPosition >= listOption1.length) {
      wordMain = listProcess[0] as Word;
      listMain.add(wordMain);
      List<String> listSyllables = wordMain.val1.split('-');
      Globals().printDebug("word: " + wordMain.title);
      Globals().printDebug("syllable #: " + listSyllables.length.toString());
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
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption1[listPosition], optionColors[0]!),
              getOptionTile(listOption2[listPosition], optionColors[1]!)
            ],
          ),
        ),
        Flexible(child: getCenterTile(listMain[listPosition])),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getOptionTile(listOption3[listPosition], optionColors[2]!),
              getOptionTile(listOption4[listPosition], optionColors[3]!)
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

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color? backgroundColor=Colors.white, Color? borderColor=Colors.white, Color fontColor= Colors.teal, double width=300, double height=200, bool containsAudio=true}) {
    int id = word.id;
    return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: Globals().buttonStyle(),
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
    Globals().printDebug("number of syllables: $syllableOption");
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        syllableOption.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal,
          fontSize: 40,
        ),
      ),
    );
  }

}
