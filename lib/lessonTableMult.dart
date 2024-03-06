import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

class LessonTableMult extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonTableMult> {

  int _selectedNumber = 0;

  List<int> listNumber = [1,2,3,4,5,6,7,8,9,10];

  FixedExtentScrollController controllerMultiplier = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController controllerResult = FixedExtentScrollController(initialItem: 0);

  @override
  Widget getMainTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                scrollController: controllerMultiplier,
                children: [
                  ...listNumber.map((value) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.red,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {
                    _selectedNumber = value;
                    debugPrint("$listPosition x $_selectedNumber = ${_selectedNumber*listPosition}");
                    controllerResult.animateToItem(_selectedNumber, duration: Duration(milliseconds: 400), curve: Curves.ease);
                  });
                },
              ),
            ),  // multiplier
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "x",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(
              Globals().listTimesTableBase[listPosition].toString(),
              style: TextStyle(
                fontSize: 50,
                color: Colors.green,
              ),
            ),  // base
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "=",
                style: TextStyle(
                    fontSize: 60,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: 150,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
              child: AbsorbPointer(
                absorbing: true,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 60,
                  scrollController: controllerResult,
                  children: [
                    ...listNumber.map((value) {
                      int result = value*(listPosition+1);
                      return Text(
                        result.toString(),
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.blue,
                        ),
                      );
                    }).toList(),
                  ],
                  onSelectedItemChanged: (value) {},
                ),
              ),
            ),  // result
          ],
        ),
      ],
    );
  }

  @override
  void next([bool refresh=true]) {
    super.next(refresh);
    controllerMultiplier.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
    controllerResult.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  @override
  void previous([bool refresh=true]) {
    super.previous(refresh);
    controllerMultiplier.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
    controllerResult.animateTo(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

}
