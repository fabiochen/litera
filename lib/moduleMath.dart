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
//  double tileSize = 130;
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
      children: <Widget>[
        Flexible(child: getMathWidgetsV(wordMain.title)),
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

  Widget getGridImages(String val) {
    Word word = Globals().getWordFromField(Globals().listNumber1t20,FieldType.VAL1,1.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Globals().appButtonColor,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: GridView.builder(
          padding: const EdgeInsets.all(1),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: sqrt(int.parse(val)).ceil(),
            childAspectRatio: 1.5,
          ),
          itemCount: int.parse(val),
          itemBuilder: (BuildContext context, int i) {
            return getImage(word.id,width:100,padding:0);
          },
        )
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
        // width: tileSize,
        // height: tileSize,
      );
      listImages.add(Flexible(flex: 3, fit: FlexFit.tight, child: gv));
      listNumbers.add(Flexible(flex: 3, fit: FlexFit.tight, child: getText(val)));
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
        alignment: Alignment.topRight,
        // height: tileSize,
        // width: tileSize/2,
        child: getText(operation,100,Colors.blue)));

    // divider
    Padding div = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 5,
        // width: tileSize*1.5,
        color: Colors.blue,
      ),
    );
    listNumbers.add(Flexible(flex: 1, child: div));
    if (!showCountingImages) div = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 5,
        // width: tileSize,
        color: Colors.transparent,
      ),
    );
    listImages.add(Flexible(flex:  1, child: div));
    // total
    listNumbers.add(Flexible(flex: 2, child: TextField(
      controller: userInputTextField,
      textAlign: TextAlign.right,
      textAlignVertical: TextAlignVertical.top,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.number,
      onChanged: (String string){
        userInputTextField.selection = TextSelection.fromPosition(TextPosition(offset: 0));
      },
      decoration: InputDecoration(
        border: new OutlineInputBorder(
            borderSide: new BorderSide(
                color: Colors.red)),
        // hintText: Globals().getAssetsVocab('TYPE-WORD'),
      ),
      style: TextStyle(
          fontSize: 100.0,
          color: Colors.red
      ),
    )));
    // listImages.add(getGridImages(expression.eval().toString()));
    listImages.add(Flexible(flex: 2, child: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ElevatedButton(
          style: Globals().buttonStyle(
            backgroundColor: Globals().appButtonColor,
          ),
          onPressed: () => _correction(wordMain.title),
          child: Text(
            Globals().getAssetsVocab('CHECK'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: Globals().appButtonFontSize,
            ),
          ),
        ),
      ),
    )));
    Column colImages = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listImages,
    );
    Column colNumbers = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: listNumbers,
    );
    Column colOperations = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listOperations,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: colOperations),  // operation
        Flexible(
          flex: 2,
          child: colNumbers),  // numbers
        Flexible(
          flex: 2,
          child: colImages),  // images
      ],
    );
  }

  void _correction(String exp) {
    exp = exp.replaceAll('x', '*');
    exp = exp.replaceAll('÷', '/');
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
  void next([bool refresh=true]) {
    userInputTextField.text = '';
    super.next(refresh);
  }

  @override
  void previous([bool refresh=true]) {
    userInputTextField.text = '';
    super.previous(refresh);
  }

}