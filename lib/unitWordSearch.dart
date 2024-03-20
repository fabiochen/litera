import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'baseModule.dart';
import 'globals.dart';
import 'word.dart';

import 'package:word_search_safety/word_search_safety.dart';

class UnitWordSearch extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<UnitWordSearch> {

  final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];

  List<Object> listWords = [];
  final int puzzleWidth = 10;
  final int puzzleHeight = 7;

  // Create the puzzle object
  WSSettings? ws;

  // Create new instance of the WordSearch class
  final WordSearchSafety wordSearch = WordSearchSafety();
  late WSNewPuzzle newPuzzle;

  Set<int> selectedIndexes = Set<int>();
  Map<int,Color> selectedIndexColor = {};
  Set<int> selectedTempIndexes = Set<int>();
  List<Set<int>> listWordIndexes = [];
  final key = GlobalKey();
  final Set<_WordSearch> _trackTaped = Set<_WordSearch>();
  String strPuzzle = '';
  String selectedWord = '';
  List<String> listString = [];
  List<String> listWordsDone = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    listString = [];
    strPuzzle = '';
    selectedWord = '';

    listWordsDone = [];
    listString = [];

    selectedIndexes = Set<int>();
    selectedIndexColor = {};
    selectedTempIndexes = Set<int>();
    listWordIndexes = [];

    listProcess.shuffle();
    listWords = (listProcess).sublist(0,6).toList();
    listWords.forEach((word) {
      listString.add((word as Word).title);
    });
    // Create a new puzzle
    ws = WSSettings(
      width: puzzleWidth,
      height: puzzleHeight,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.vertical,
        WSOrientation.horizontalBack,
        WSOrientation.verticalUp
        // WSOrientation.diagonal,
      ]),
    );
    newPuzzle = wordSearch.newPuzzle(listString, ws!);
    strPuzzle = newPuzzle.toString().replaceAll(' ', '').replaceAll('\n', '');
  }

  @override
  Widget getMainTile() {
    /// Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors!.isEmpty) {
      // The puzzle output
      Globals().printDebug('Puzzle 2D List');
      Globals().printDebug(newPuzzle.toString());

      // Solve puzzle for given word list
      final WSSolved solved =
      wordSearch.solvePuzzle(newPuzzle.puzzle!, ['dart', 'word']);
      // All found words by solving the puzzle
      Globals().printDebug('Found Words!');
      solved.found!.forEach((element) {
        Globals().printDebug('word: ${element.word}, orientation: ${element.orientation}');
        Globals().printDebug('x:${element.x}, y:${element.y}');
      });

      // All words that could not be found
      Globals().printDebug('Not found Words!');
      solved.notFound!.forEach((element) {
        Globals().printDebug('word: ${element}');
      });
    } else {
      // Notify the user of the errors
      newPuzzle.errors!.forEach((error) {
        Globals().printDebug(error);
      });
    }
    bool hideWord = false;
    try {
      hideWord = misc as bool;
    } catch (e) {
      hideWord = false;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 3,
            child: Listener(
              onPointerDown: _detectTapedItem,
              onPointerMove: _detectTapedItem,
              onPointerUp: _checkSelection,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: GridView.builder(
                  key: key,
                  itemCount: puzzleWidth*puzzleHeight,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemBuilder: (context, index) {
                    return WordSearch(
                      index: index,
                      child: Container(
                        alignment: Alignment.center,
                        color: selectedIndexes.contains(index) ? selectedIndexColor[index] : Colors.white,
                        child: AutoSizeText(
                          _removeDiacritics(strPuzzle.characters.elementAt(index).toUpperCase()),
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
        hideWord ? Flexible(child: Text(listWordsDone.length.toString() + " de " + listWords.length.toString(),
          style: TextStyle(
            color: Globals().appFontColorDark,
            fontSize: 30,
          ),
        )) :
        Flexible(
            flex: 1,
            child: GridView.builder(
              itemCount: listWords.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3.0,
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    listString[index],
                    style: TextStyle(
                      decoration: listWordsDone.contains(listString[index])?TextDecoration.lineThrough:TextDecoration.none,
                      fontSize: 30,
                      color: Colors.teal,
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }

  String _removeDiacritics(String str) {

    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;

  }

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _WordSearch && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
          selectedWord = selectedWord + strPuzzle.characters.elementAt(target.index);
          Globals().printDebug("char: " + strPuzzle.characters.elementAt(target.index));
        }
      }
    }
  }

  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
      selectedTempIndexes.add(index);
    });
  }

  void _checkSelection(PointerUpEvent event) {
    _trackTaped.clear();
    setState(() {
      Globals().printDebug("listString: $listString");
      Globals().printDebug("selectedWord: $selectedWord");
      if (!listString.contains(selectedWord)) {
        removeIndexes(selectedTempIndexes);
      } else {
        listWordIndexes.add(selectedTempIndexes);
        listWordsDone.add(selectedWord);
        if (listWordsDone.length == listWords.length) {
          audioPlay("cheer");
          Future.delayed(Duration(milliseconds: 3000), () {
            didChangeDependencies();
            setState(() {});
          });
        } else {
          audioPlay("true");
        }
      }
      refreshIndexes();
    });
    selectedWord = '';
    selectedTempIndexes = Set<int>();
  }

  void refreshIndexes() {
    listWordIndexes.asMap().forEach((index,set) {
      set.forEach((int) {
        selectedIndexes.add(int);
        selectedIndexColor[int] = optionColors[index]!;
      });
    });
  }

  void removeIndexes(Set<int> set) {
    set.forEach((element) {
      Globals().printDebug("element: $element");
      selectedIndexes.remove(element);
    });
  }

  Text getTextString() {
    String text = '';
    listWords.forEach((word) {
      text = text + " " + (word as Word).title;
    });
    Text txt = Text(
      text,
      style: TextStyle(
        fontSize: 30,
        fontFamily: "Chivo-mono",
        color: Colors.black,
      ),
    );
    return txt;
  }

  List<Widget> getLetters(index) {
    List<Widget> listText = [];
    newPuzzle.toString().replaceAll(' ', '').split("\n").forEach((line) {
      line.characters.forEach((char) {
        listText.add(
            Center(
              child: Text(
          char,
          style: TextStyle(
              fontSize: 30,
              fontFamily: "Chivo-mono",
              color: Colors.black,
          ),
        ),
            )
        );
      });
    });
    return listText;
  }

}

class WordSearch extends SingleChildRenderObjectWidget {
  final int index;

  WordSearch({required Widget child, required this.index, Key? key}) : super(child: child, key: key);

  @override
  _WordSearch createRenderObject(BuildContext context) {
    return _WordSearch(index);
  }

  @override
  void updateRenderObject(BuildContext context, _WordSearch renderObject) {
    renderObject..index = index;
  }
}

class _WordSearch extends RenderProxyBox {
  int index;
  _WordSearch(this.index);
}
