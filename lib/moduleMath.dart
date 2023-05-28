import 'dart:async';
import 'dart:math';
import 'package:eval_ex/expression.dart';

import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';

class ModuleMath extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModuleMath> {

  final userInputTextField = TextEditingController();
  double tileSize = 120;
  bool showCountingImages = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listProcess.shuffle();
    Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    showCountingImages = args?['misc'] as bool;
  }

  Widget getMainTile() {
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        getMathWidgetsV(wordMain.title),
        ValueListenableBuilder(
          valueListenable: flagCorrect,
          builder: (context, value, widget) {
            saveCorrectionValues();
            return SizedBox.shrink();
          },
        ),
        ValueListenableBuilder(
          valueListenable: flagWrong,
          builder: (context, value, widget) {
            saveCorrectionValues();
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  bool isNumeric(String string) {
    final numericRegex =
    RegExp(r'^-?(([0-9])|(([0-9])\.([0-9])))$');
    //Globals().printDebug("$string is Numeric: " + numericRegex.hasMatch(string).toString());
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

  Widget getMathWidgetsV(String exp) {
    List<Widget> listImages = [];
    List<Widget> listNumbers = [];
    List<Widget> listOperations = [];
    String operation = '+';
    for (int j=0; j<exp.length; j++) {
      if (!isNumeric(exp[j])) {
        operation = exp[j];
        //Globals().printDebug("op: $operation");
      }
    }
    List<String> listValues = exp.split(operation);
    for (int i=0; i<listValues.length; i++) {
      String val = listValues[i];
      Widget? gv;
      //Globals().printDebug("val: $val");
      gv = getGridImages(val);
      if (!showCountingImages) gv = Container(
        width: tileSize,
        height: tileSize,
      );
      listImages.add(gv);
      listNumbers.add(Container(
        alignment: Alignment.centerRight,
        height: tileSize,
        width: tileSize,
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

    // divider
    Padding div = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 5,
        width: tileSize,
        color: Colors.teal,
      ),
    );
    listNumbers.add(div);
    if (!showCountingImages) div = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 5,
        width: tileSize,
        color: Colors.transparent,
      ),
    );
    listImages.add(div);
    // total
    listNumbers.add(Container(
      width: tileSize,
      height: tileSize,
      padding: EdgeInsets.all(12),
      child: TextField(
        controller: userInputTextField,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        keyboardType: TextInputType.number,
        onChanged: (String string){
          userInputTextField.selection = TextSelection.fromPosition(TextPosition(offset: 0));
        },
        style: TextStyle(
            fontSize: 50.0,
            color: Colors.red
        ),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.red)),
          // hintText: Globals().getAssetsVocab('TYPE-WORD'),
        ),
      ),
    ));
    // listImages.add(getGridImages(expression.eval().toString()));
    listImages.add(Container(
      width: tileSize,
      height: tileSize,
      child: Center(
        child: ButtonTheme(
          minWidth: 50.0,
          height: 50.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            onPressed: () => _correction(wordMain.title),
            child: Text(
              Globals().getAssetsVocab('CHECK'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    ));
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
        colImages,
        Expanded(child: Container()),
      ],
    );
  }

  void _correction(String exp) {
    Expression expression = Expression(exp);
    Globals().printDebug("textfield: " + userInputTextField.text);
    Globals().printDebug("eval: " + expression.eval().toString());
    bool isCorrect = (int.parse(userInputTextField.text).toString() == expression.eval().toString());
    Globals().printDebug("isCorrect: $isCorrect");
    audioPlay(isCorrect);
    if (type == ModuleType.TEST) {
      if (isCorrect) {
        flagCorrect.value = 1;
        correctCount++;
      } else {
        flagWrong.value = 1;
        wrongCount++;
      }
      Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    }
  }

  @override
  void next() {
    userInputTextField.text = '';
    super.next();
  }

  @override
  void previous() {
    userInputTextField.text = '';
    super.previous();
  }

}