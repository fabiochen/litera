import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'baseModule.dart';
import 'word.dart';
import 'globals.dart';

class LessonClockDigital extends BaseModule {
  @override
  _State createState() => _State();
}

class _State extends BaseModuleState<LessonClockDigital> {

  int _selectedHour = 0;
  int _selectedMinute = 0;

  Widget getMainTile() {
    Globals().printDebug("hour: $_selectedHour");
    Globals().printDebug("min: $_selectedMinute");
    Word hr = Globals().listTimeHour.elementAt(_selectedHour);
    Word mn = Globals().listTimeMinutes.elementAt(_selectedMinute);
    playTime(hr.title + ":" + mn.title);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 40),
        Flexible(child: Globals().getClock(hr.title + ":" + mn.title, 5)),
        Flexible(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 100,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                children: [
                  ...Globals().listTimeHour.map((word) {
                    String title = word.title;
                    return Text(
                      title,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.deepOrange,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {_selectedHour = value;});
                },
              ),
            ),  // hour
            Container(
              width:50,
              alignment: Alignment.center,
              child: Text(
                ":",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.green,
                ),
              )),  // :
            Container(
              width: 150,
              height: 100,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 60,
                children: [
                  ...Globals().listTimeMinutes.map((word) {
                    String title = word.title;
                    return Text(
                      title,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.green,
                      ),
                    );
                  }).toList(),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {_selectedMinute = value;});
                },
              ),
            ),  // minutes
          ],
        )),  // consonant/vowel text
      ],
    );
  }

}