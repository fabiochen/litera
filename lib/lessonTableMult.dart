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
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                clipBehavior: Clip.antiAlias,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 60,
                  useMagnifier: true,
                  magnification: 1.2,
                  scrollController: controllerMultiplier,
                  children: [
                    ...listNumber.map((value) {
                      return Text(
                        value.toString(),
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.green,
                            fontWeight: FontWeight.bold
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
              ),
            )),  // multiplier
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "x",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(
              Globals().listTimesTableBase[listPosition].toString(),
              style: TextStyle(
                fontSize: 70,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),  // base
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "=",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
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
                clipBehavior: Clip.antiAlias,
                child: AbsorbPointer(
                  absorbing: true,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 60,
                    useMagnifier: true,
                    magnification: 1.2,
                    scrollController: controllerResult,
                    children: [
                      ...listNumber.map((value) {
                        int result = value*(listPosition+1);
                        return Text(
                          result.toString(),
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                          ),
                        );
                      }).toList(),
                    ],
                    onSelectedItemChanged: (value) {},
                  ),
                ),
              ),
            )),  // result
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
