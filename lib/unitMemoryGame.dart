import 'package:flutter/material.dart';
import 'package:litera/globals.dart';

import 'baseModule.dart';
import 'word.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UnitMemoryGame extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<UnitMemoryGame> {

  Word? selectedWord1;
  Word? selectedWord2;
  int selectedIndex1 = -1;
  int selectedIndex2 = -1;
  List<Word> listGame = [];
  Color sColor = Colors.orange[100]!;
  bool isLocked = false;
  int listStart = 0;
  int listEnd = 0;
  Color cardColor = Colors.blue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listEnd = listProcess.length~/numberQuestions;
    initGame();
  }

  void initGame() {
    listGame = [];
    if (listEnd > listProcess.length) listEnd = listProcess.length;
    listProcess.sublist(listStart,listEnd).forEach((element) {
      String label = '';
      label = Globals().getLabelFromFieldType(element as Word, mainFieldType);
      Word card1 = Word(element.id, label);
      listGame.add(card1);
      label = Globals().getLabelFromFieldType(element, optionFieldType);
      Word card2 = Word(element.id, label);
      listGame.add(card2);
    });
    listGame.shuffle();
    selectedWord1 = null;
    selectedWord2 = null;
    selectedIndex1 = -1;
    selectedIndex2 = -1;
    isLocked = false;
  }

  Widget getMainTile() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
          itemCount: listGame.length,
          itemBuilder: (BuildContext ctx, index) {
            Word word = listGame[index];
            bool unmatched = true;
            bool isSelected = false;
            try {
              unmatched = word.val3 == "unmatched";
            } catch (e) {
              unmatched = true;
            }
            try {
              //Globals().printDebug("selectedIndex1: $selectedIndex1");
              isSelected = selectedIndex1 == index || selectedIndex2 == index;
              //Globals().printDebug("isSelected: $isSelected");
            } catch (e) {
              isSelected = false;
            }
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (isSelected) ? sColor : cardColor, // Background color
                disabledBackgroundColor: (!unmatched || isSelected) ? optionColors[word.id%10] : cardColor,
                surfaceTintColor: cardColor,
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    )
                ),
              ),
              onPressed: (unmatched && !isLocked) ? () {
                int duration = 500;
                if (optionTileType == TileType.AUDIO && isNumeric(word.title)) {
                  audioPlay(word.id);
                  // give time to play previous audio
                  duration = 3000;
                }
                if (selectedWord1 == null) {
                  selectedWord1 = word;
                  selectedIndex1 = index;
                  // prevent selecting the same card
                  selectedWord1?.val3 = "matched";
                }
                else {
                  selectedWord2 = word;
                  selectedIndex2 = index;
                  // prevent selecting the same card
                  selectedWord2?.val3 = "matched";
                  if (gameOver()) {
                    Future.delayed(Duration(milliseconds: 2000), () {
                      audioPlay("cheer");
                    });
                    Future.delayed(Duration(milliseconds: 4000), () {
                      next();
                    });
                  } else {
                    Future.delayed(Duration(milliseconds: duration), () {
                      audioPlay(selectedWord1?.id == selectedWord2?.id);
                    });
                  }
                  if (selectedWord1?.id == selectedWord2?.id) {
                    selectedWord1?.val3 = "matched";
                    selectedWord2?.val3 = "matched";
                    duration = 500;
                  }
                  else {
                    selectedWord1?.val3 = "unmatched";
                    selectedWord2?.val3 = "unmatched";
                    // extra time to remember cards
                    duration = 3000;
                  }
                  isLocked = true;
                  listGame[selectedIndex1] = selectedWord1!;
                  listGame[selectedIndex2] = selectedWord2!;
                  Future.delayed(Duration(milliseconds: duration), () {
                    selectedWord1 = null;
                    selectedWord2 = null;
                    selectedIndex1 = -1;
                    selectedIndex2 = -1;
                    isLocked = false;
                    setState(() {});
                  });
                }
                gameOver();
                setState(() {});
              } : null,
              child: getCardType(word),
            );
          }),
    );
  }

  Widget getCardType(word) {
    Globals().printDebug("getCardType: " + word.title);
    if (optionTileType == TileType.AUDIO && isNumeric(word.title)) {
      return Icon(
        IconData(57400, fontFamily: 'LiteraIcons'),
        color: cardColor,
      );
    }
    return AutoSizeText(
      word.title,
      textAlign: TextAlign.center,
      wrapWords: false,
      softWrap: false,
      style: TextStyle(
        color: cardColor,
        fontSize: 60
      ),
    );
  }

  bool isNumeric(String s) {
    return int.tryParse(s) != null;
  }

  bool gameOver() {
    bool gameOver = true;
    listGame.forEach((card) {
      try {
        if (card.val3 == "unmatched") gameOver = false;
      } catch (e) {
        gameOver = false;
      }
    });
    return gameOver;
  }

  @override
  void next([bool refresh=true]) {
    super.next(refresh);
    int diff = listEnd - listStart;
    listStart = listEnd;
    listEnd = listStart + diff;
    initGame();
  }

  @override
  void previous([bool refresh=true]) {
    super.previous(refresh);
    if (listStart>0) {
      int diff = listEnd - listStart;
      listEnd = listStart;
      listStart = listEnd - diff;
      initGame();
    }
  }

}