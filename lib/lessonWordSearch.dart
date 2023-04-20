import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'word.dart';

import 'package:word_search_safety/word_search_safety.dart';

class LessonWordSearch extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonWordSearch> {

  final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];

  List<Object> listWords = [];
  final int puzzleWidth = 10;
  final int puzzleHeight = 7;
  List<Color> listColors = [
    Colors.red.shade100,
    Colors.orange.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.brown.shade100
  ];

  // Create the puzzle object
  WSSettings? ws;

  // Create new instance of the WordSearch class
  final WordSearchSafety wordSearch = WordSearchSafety();
  late WSNewPuzzle newPuzzle;

  final Set<int> selectedIndexes = Set<int>();
  Map<int,Color> selectedIndexColor = {};
  Set<int> selectedTempIndexes = Set<int>();
  List<Set<int>> listWordIndexes = [];
  final key = GlobalKey();
  final Set<_Foo> _trackTaped = Set<_Foo>();
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
        // WSOrientation.diagonal,
      ]),
    );
    newPuzzle = wordSearch.newPuzzle(listString, ws!);
    strPuzzle = newPuzzle.toString().replaceAll(' ', '').replaceAll('\n', '');
  }

  @override
  Widget getBody() {
    /// Check if there are errors generated while creating the puzzle
    if (newPuzzle.errors!.isEmpty) {
      // The puzzle output
      print('Puzzle 2D List');
      print(newPuzzle.toString());

      // Solve puzzle for given word list
      final WSSolved solved =
      wordSearch.solvePuzzle(newPuzzle.puzzle!, ['dart', 'word']);
      // All found words by solving the puzzle
      print('Found Words!');
      solved.found!.forEach((element) {
        print('word: ${element.word}, orientation: ${element.orientation}');
        print('x:${element.x}, y:${element.y}');
      });

      // All words that could not be found
      print('Not found Words!');
      solved.notFound!.forEach((element) {
        print('word: ${element}');
      });
    } else {
      // Notify the user of the errors
      newPuzzle.errors!.forEach((error) {
        print(error);
      });
    }
    return Column(
      children: [
        Flexible(
          flex: 2,
            child: Listener(
              onPointerDown: _detectTapedItem,
              onPointerMove: _detectTapedItem,
              onPointerUp: _checkSelection,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    return Foo(
                      index: index,
                      child: Container(
                        alignment: Alignment.center,
                        color: selectedIndexes.contains(index) ? selectedIndexColor[index] : Colors.white,
                        child: Text(
                          strPuzzle.characters.elementAt(index),
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
        Flexible(
            flex: 1,
            child: GridView.builder(
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    listString[index],
                    style: TextStyle(
                      decoration: listWordsDone.contains(listString[index])?TextDecoration.lineThrough:TextDecoration.none,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _Foo && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
          selectedWord = selectedWord + strPuzzle.characters.elementAt(target.index);
          print("char: " + strPuzzle.characters.elementAt(target.index));
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
      print("listString: $listString");
      print("selectedWord: $selectedWord");
      if (!listString.contains(selectedWord)) {
        removeIndexes(selectedTempIndexes);
      } else {
        listWordIndexes.add(selectedTempIndexes);
        listWordsDone.add(selectedWord);
        if (listWordsDone.length == listWords.length) {
          audioPlay("cheer");
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
        selectedIndexColor[int] = listColors[index];
      });
    });
  }

  void removeIndexes(Set<int> set) {
    set.forEach((element) {
      print("element: $element");
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

class Foo extends SingleChildRenderObjectWidget {
  final int index;

  Foo({required Widget child, required this.index, Key? key}) : super(child: child, key: key);

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo(index);
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject..index = index;
  }
}

class _Foo extends RenderProxyBox {
  int index;
  _Foo(this.index);
}
