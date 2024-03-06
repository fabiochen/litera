import 'dart:math';
import 'package:eval_ex/expression.dart';

import 'package:flutter/material.dart';

import 'baseModule.dart';
import 'word.dart';
import 'globals.dart';

class LessonMath extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonMath> {

  double tileSize = 120;
  bool showCountingImages = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    showCountingImages = args?['misc'] as bool;
  }

  @override
  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getMathWidgetsH(wordMain.title),
      ],
    );
  }

  bool isNumeric(String string) {
    final numericRegex =
    RegExp(r'^-?(([0-9])|(([0-9])\.([0-9])))$');
    Globals().printDebug("$string is Numeric: " + numericRegex.hasMatch(string).toString());
    return numericRegex.hasMatch(string);
  }

  Container getGridImages(String val) {
    Word word = Globals().getWordFromField(Globals().listNumber1t20,FieldType.VAL1,1.toString());
    return Container(
      alignment: Alignment.center,
      width: tileSize,
      height: tileSize,
      child: GridView.builder(
        padding: const EdgeInsets.all(1),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: sqrt(int.parse(val)).ceil(),
          childAspectRatio: 1,
        ),
        itemCount: int.parse(val),
        itemBuilder: (BuildContext context, int i) {
          return getImage(word.id, tileSize, 0);
        },
      ),
    );
  }

  Widget getMathWidgetsH(String exp) {
    List<Widget> list = [];
    for (int i=0; i<exp.length; i++) {
      String val = exp[i];
      if (isNumeric(val)) {
        list.add(getText(val));
      }
      else {
        Column colOp = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (showCountingImages) Container(
                height: 200,
                alignment: Alignment.center,
                child: getText(val)),
            Container(child: getText(val,100,Colors.blue)),
          ],
        );
        list.add(colOp);
      }
    }
    list.add(getText('=',100,Colors.blue));
    debugPrint("exp: $exp");
    exp = exp.replaceAll('x', '*');
    exp = exp.replaceAll('÷', '/');
    debugPrint("exp: $exp");
    Expression expression = Expression(exp);
    list.add(getText(expression.eval().toString(),100,Colors.red));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list,
    );
  }

  Widget getMathWidgetsV(String exp) {
    List<Widget> listImages = [];
    List<Widget> listNumbers = [];
    List<Widget> listOperations = [];
    String operation = '+';
    for (int j=0; j<exp.length; j++) {
      if (!isNumeric(exp[j])) {
        operation = exp[j];
        if (operation == '/') operation = '÷';
        Globals().printDebug("op: $operation");
      }
    }
    List<String> listValues = exp.split(operation);
    for (int i=0; i<listValues.length; i++) {
      String val = listValues[i];
      Widget? gv;
      Globals().printDebug("val: $val");
      gv = getGridImages(val);
      listImages.add(gv);
      listNumbers.add(Container(
        alignment: Alignment.centerRight,
        height: tileSize,
        width: tileSize*1.5,
        child: getText(val),
      ));
    }
    switch(operation) {
      case '*':
        operation = 'x';
        break;
      case '/':
        operation = '÷';
        break;
    }
    listOperations.add(Container(
        alignment: Alignment.centerRight,
        height: tileSize,
        width: tileSize/2,
        child: getText(operation,100,Colors.blue)));

    Expression expression = Expression(exp);
    debugPrint("total: " + expression.eval().toString());
    // divider
    Padding div = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 5,
        width: tileSize*1.5,
        color: Colors.teal,
      ),
    );
    listNumbers.add(div);
    listImages.add(div);
    // total
    listNumbers.add(Container(
        alignment: Alignment.centerRight,
        height: tileSize,
        width: tileSize*1.5,
        child: getText(expression.eval().toString(),100,Colors.red)));
    listImages.add(getGridImages(expression.eval().toString()));
    Column colImages = Column(
      children: listImages,
    );
    Column colNumbers = Column(
      children: listNumbers,
    );
    Column colOperations = Column(
      children: listOperations,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Container()),
        colOperations,
        colNumbers,
        if (showCountingImages) colImages,
        Expanded(child: Container()),
      ],
    );
  }

}
