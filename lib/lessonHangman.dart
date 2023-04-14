import 'package:flutter/material.dart';

import 'baseModule.dart';
import 'word.dart';
import 'globals.dart';

class LessonHangman extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonHangman> {

  List<String> listGoodLetters = [];
  List<String> listBadLetters = [];
  String wordGuessed = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.shuffle();
  }

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: CustomPaint(
                          painter: Hangman(listBadLetters),
                          child: Container(),
                        ),
                      ),
                    )),  // hangman
                Flexible(
                    flex: 1,
                    child: Container(
                      child: getGuessWord(),
                    )),  // word
              ],
        )),
        Flexible(
          flex: 1,
            child: getAlphabetButtons()),  // alphabet buttons
      ],
    );
  }

  Widget getAlphabetButtons() {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        childAspectRatio: 1,
      ),
      itemCount: 26,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextButton(
              onPressed: () => (listBadLetters.length<10 && !isDone())?checkLetterExists(i):null,
              child: Text(
                alphabetLetterList[i].title.toUpperCase(),
                style: TextStyle(
                  color: (!listBadLetters.contains(alphabetLetterList[i].title))?Colors.white:Colors.grey,
                  fontSize: 25,
                ),
              ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.teal; // defer to the defaults
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getGuessWord() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        itemCount: wordMain.title.length,
        itemBuilder: (BuildContext context, int index) {
          String testLetter = wordMain.title.substring(index,index+1);
          String space;
          if (listGoodLetters.contains(testLetter)) {
            space = testLetter;
          } else {
            space = '_';
            if (listBadLetters.length > 9) {
              space = testLetter;
            }
          }
          return Container(
            height: 50,
            width: 50,
            alignment: Alignment.bottomCenter,
            child: Text(
              space,
              style: TextStyle(
                color: listGoodLetters.contains(testLetter)?Colors.teal:Colors.deepOrange,
                fontSize: 80,
                fontFamily: "Chivo-mono"
              ),
            ),
          );
        }
    );
  }

  void checkLetterExists(int i) {
    String chosenLetter = alphabetLetterList[i].title;
    if (wordMain.title.contains(chosenLetter)) {
      // only add once
      if (!listGoodLetters.contains(chosenLetter)) listGoodLetters.add(chosenLetter);
      if (isDone()) {
        audioPlay("cheer");
      } else
      audioPlay("true");
    } else {
      // only add once
      if (!listBadLetters.contains(chosenLetter)) listBadLetters.add(chosenLetter);
      if (listBadLetters.length > 9) {
        audioPlay("moan");
      } else {
        audioPlay("false");
      }
    }
    setState(() {});
  }

  bool isDone() {
    bool done = true;
    wordMain.title.characters.forEach((char) {
      if (!listGoodLetters.contains(char)) done = false;
    });
    return done;
  }

  @override
  next() {
    listGoodLetters = [];
    listBadLetters = [];
    super.next();
  }

  @override
  previous() {
    listGoodLetters = [];
    listBadLetters = [];
    super.previous();
  }

}

class Hangman extends CustomPainter {

  List<String> listBadLetters;

  Hangman(List<String> this.listBadLetters);

  @override
  void paint(Canvas canvas, Size size) {

    print("bad letters count: " + listBadLetters.length.toString());
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    // base
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width/4, size.height);
    canvas.drawPath(path, paint);

    if (listBadLetters.length>0) {
      Path path1 = Path();
      path1.moveTo(size.width/8, size.height);
      path1.lineTo(size.width/8, 0);
      canvas.drawPath(path1, paint);
    }
    if (listBadLetters.length>1) {
      Path path2 = Path();
      path2.moveTo(size.width/8, 0);
      path2.lineTo(size.width/2, 0);
      canvas.drawPath(path2, paint);
    }
    if (listBadLetters.length>2) {
      Path path3 = Path();
      path3.moveTo(size.width/2, 0);
      path3.lineTo(size.width/2, size.height/8);
      canvas.drawPath(path3, paint);
    }
    if (listBadLetters.length>3) {
      canvas.drawCircle(Offset(size.width/2, size.height/4), size.height/8, paint);
    }
    if (listBadLetters.length>4) {
      Path path4 = Path();
      path4.moveTo(size.width/2, size.height/4+size.height/8);
      path4.lineTo(size.width/2, size.height/8*6);
      canvas.drawPath(path4, paint);
    }
    // leg1
    if (listBadLetters.length>5) {
      Path path5 = Path();
      path5.moveTo(size.width/2, size.height/8*6);
      path5.lineTo(size.width/8*3, size.height/8*7);
      canvas.drawPath(path5, paint);
    }
    // leg2
    if (listBadLetters.length>6) {
      Path path6 = Path();
      path6.moveTo(size.width/2, size.height/8*6);
      path6.lineTo(size.width/8*5, size.height/8*7);
      canvas.drawPath(path6, paint);
    }
    // arm1
    if (listBadLetters.length>7) {
      Path path7 = Path();
      path7.moveTo(size.width/2, size.height/8*4);
      path7.lineTo(size.width/8*3, size.height/8*5);
      canvas.drawPath(path7, paint);
    }
    // arm2
    if (listBadLetters.length>8) {
      Path path8 = Path();
      path8.moveTo(size.width/2, size.height/8*4);
      path8.lineTo(size.width/8*5, size.height/8*5);
      canvas.drawPath(path8, paint);
    }
    // face
    if (listBadLetters.length>9) {
      Path path9 = Path();
      path9.moveTo(size.width/32*15, size.height/32*8);
      path9.lineTo(size.width/32*14, size.height/32*7);
      path9.moveTo(size.width/32*15, size.height/32*7);
      path9.lineTo(size.width/32*14, size.height/32*8);

      path9.moveTo(size.width/32*18, size.height/32*8);
      path9.lineTo(size.width/32*17, size.height/32*7);
      path9.moveTo(size.width/32*18, size.height/32*7);
      path9.lineTo(size.width/32*17, size.height/32*8);

      path9.moveTo(size.width/32*15, size.height/32*10);
      path9.lineTo(size.width/32*16, size.height/32*9);
      path9.lineTo(size.width/32*17, size.height/32*10);

      canvas.drawPath(path9, paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}