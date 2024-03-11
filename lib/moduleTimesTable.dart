import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

class ModuleTimesTable extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<ModuleTimesTable> {

  int _selectedNumber = Random().nextInt(10);
  int _selectedOption = 0;

  List<int> listNumber = [1,2,3,4,5,6,7,8,9,10];

  late FixedExtentScrollController controllerMultiplier;
  FixedExtentScrollController controllerResult = FixedExtentScrollController(initialItem: 0);

  @override
  void initState() {
    super.initState();
    controllerMultiplier = FixedExtentScrollController(initialItem: (_selectedNumber));
  }

  @override
  Widget getMainTile() {
    setState(() {
      controllerMultiplier.animateToItem(_selectedNumber, duration: Duration(milliseconds: 400), curve: Curves.ease);
      debugPrint("selectedNumber: $_selectedNumber");
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8,0,0,0),
              child: Text(
                Globals().listTimesTableBase[listPosition].toString(),
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "x",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                border: Border.all(
                  color: Colors.red,
                  width: 5,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.red,
                  width: 5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AbsorbPointer(
                  absorbing: true,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 60,
                    magnification: 1.2,
                    useMagnifier: true,
                    scrollController: controllerMultiplier,
                    children: [
                      ...listNumber.map((value) {
                        return Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.red,
                          ),
                        );
                      }).toList(),
                    ],
                    onSelectedItemChanged: (value) {
                    },
                  ),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "=",
                style: TextStyle(
                    fontSize: 60,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                    width: 5,
                  ),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.green,
                    width: 5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 60,
                    magnification: 1.2,
                    useMagnifier: true,
                    scrollController: controllerResult,
                    children: [
                      ...listNumber.map((value) {
                        int result = value*(listPosition+1);
                        return Text(
                          result.toString(),
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.green,
                          ),
                        );
                      }).toList(),
                    ],
                    onSelectedItemChanged: (value) {
                      _selectedOption = value;
                    },
                  ),
                ),
              ),
            )),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
                color: Colors.green
            ),
            borderRadius: BorderRadius.all(
                const Radius.circular(5.0)),
          ),
          child: TextButton(
            onPressed: () {
              bool isCorrect = _selectedNumber == _selectedOption;
              audioPlay(isCorrect);
              debugPrint("selectedNumber: $_selectedNumber selectedOption: $_selectedOption");
              debugPrint("Acertei: " + (_selectedNumber == _selectedOption).toString());
              if (isCorrect) {
                setState(() {
                  _selectedNumber = Random().nextInt(10);
                });
              }
            },
            child: Text(
              "acertei?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            )),
        )
      ],
    );
  }

  @override
  void next([bool refresh=true]) {
    super.next(refresh);
    _selectedNumber = Random().nextInt(10);
    controllerMultiplier.animateToItem(_selectedNumber, duration: Duration(milliseconds: 400), curve: Curves.ease);
    controllerResult.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  @override
  void previous([bool refresh=true]) {
    super.previous(refresh);
    _selectedNumber = Random().nextInt(10);
    controllerMultiplier.animateToItem(_selectedNumber, duration: Duration(milliseconds: 400), curve: Curves.ease);
    controllerResult.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

}
