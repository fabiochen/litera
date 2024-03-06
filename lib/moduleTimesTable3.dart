import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:roulette/roulette.dart';
import 'package:widget_spinning_wheel/widget_spinning_wheel.dart';

class ModuleTimesTable3 extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModuleTimesTable3> with SingleTickerProviderStateMixin {

  late int _selectedMultiplier;
  late int _selectedBase;
  int _selectedResultLeft = 0;
  int _selectedResultRight = 0;

  List<String> listDigits = ['0','1','2','3','4','5','6','7','8','9'];

  FixedExtentScrollController controllerResultLeft  = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController controllerResultRight = FixedExtentScrollController(initialItem: 0);

  PieChart pc = PieChart(
    data: [0,1,2,3,4,5,6,7,8,9,10],
    labels: ['1','2','3','4','5','6','7','8','9','10'],
    customColours: [Colors.red[100]!,Colors.red],
    textStyle: TextStyle(),
    angleOffset: 9,
  );

  final items = <String>[
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  @override
  Widget getMainTile() {
    listProcess.shuffle();
    wordMain = listProcess[listPosition] as Word;
    final List<String> wordSplit = wordMain.title.split('x');
    debugPrint("word: ${wordMain.title}");
    debugPrint("base: ${wordSplit[0]}");
    debugPrint("mult: ${wordSplit[1]}");
    _selectedBase       = int.parse(wordSplit[0]);
    _selectedMultiplier = int.parse(wordSplit[1]);

    final StreamController _dividerController = StreamController<int>();

    late int val;

    // return  SpinningWheel(
    //   image: Image.asset('assets/icon/unitas.jpg'),
    //   width: 310,
    //   height: 310,
    //   initialSpinAngle: 0.0,
    //   spinResistance: 0.6,
    //   canInteractWhileSpinning: true,
    //   dividers: 8,
    //   onUpdate: _dividerController.add,
    //   onEnd: (val) {
    //     debugPrint("end val: $val");
    //     _dividerController.add;
    //   },
    //   secondaryImage: Image.asset('assets/icon/unitas.jpg'),
    //   secondaryImageHeight: 110,
    //   secondaryImageWidth: 110,
    // );

    // final units = [
    //   RouletteUnit.noText(color: Colors.red),
    //   RouletteUnit.noText(color: Colors.green),
    //   // ...other units
    // ];
    //
    // // Initialize controller
    // final controller = RouletteController(
    //   group: RouletteGroup(units),
    //   vsync: this, // TickerProvider, usually from SingleTickerProviderStateMixin
    // );
    //
    //
    // return Column(
    //   children: [
    //     ElevatedButton(
    //         onPressed: () async {
    //       // Spin to index 2
    //       await controller.rollTo(1);
    //       // Do something after settled
    //     },
    //     child: Text('Roll!'),
    //     ),
    //     Expanded(child: Roulette(
    //       controller: controller,
    //       style: RouletteStyle(
    //         // Customize appearance
    //       ),
    //     ))
    //   ],
    // );

    WidgetSpinningWheel wswMultiplier = WidgetSpinningWheel(
        labels: listDigits,
        textStyle: TextStyle(
          fontSize: 40,
        ),
        defaultSpeed: 0.05,
        colours: [Colors.lightGreen, Colors.green],
        onSpinComplete: (String label) {
          debugPrint("spin: $label");
        },
        size: 450
    );
    WidgetSpinningWheel wswBase = WidgetSpinningWheel(
        labels: listDigits,
        textStyle: TextStyle(
          fontSize: 20,
        ),
        defaultSpeed: 0.5,
        colours: [Colors.red[200]!, Colors.red],
        onSpinComplete: (String label) {
        },
        size: 200
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        wswMultiplier,  // result
        wswBase,  // multiplier
        Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: Text(
            "${listPosition+1} x",
            style: TextStyle(
              fontSize: 30
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(50))
          ),
        )  // base
      ],
    );

    // StreamController<int> selected = StreamController<int>();
    // return GestureDetector(
    //   onTap: () {
    //     setState(() {
    //       selected.add(
    //         Fortune.randomInt(0, items.length),
    //       );
    //     });
    //   },
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: FortuneWheel(
    //           selected: selected.stream,
    //           duration: Duration(milliseconds: 500),
    //           indicators: [
    //             FortuneIndicator(
    //               child: Icon(
    //                 Icons.arrow_circle_up_rounded,
    //                 size: 100,
    //                 color: Colors.white,
    //               ),
    //             )
    //           ],
    //           items: [
    //             for (var it in items) FortuneItem(
    //                 child: RotatedBox(
    //                   quarterTurns: 1,
    //                   child: Text(
    //                     it,
    //                     style: TextStyle(
    //                         fontSize: 30
    //                     ),
    //                   ),
    //                 )),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void correctionLogic(Word wordOption) {
    int result = _selectedMultiplier*_selectedBase;
    int option = _selectedResultLeft*10+_selectedResultRight;
    bool isCorrect = result == option;
    audioPlay(isCorrect);
    if (type == ModuleType.TEST) {
      if (isCorrect) {
        flagCorrect.value = 1;
        correctCount++;
      } else {
        flagWrong.value = 1;
        wrongCount++;
      }
      controllerResultLeft.animateToItem(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
      controllerResultRight.animateToItem(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
      Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    } else {
      if (isCorrect) Timer(Duration(milliseconds: 1000), () async {
        next();
      });
    }
  }

}
