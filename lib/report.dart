import 'package:litera/word.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Report extends BaseModule {
  @override
  BaseReportState createState() => BaseReportState();
}

class BaseReportState<T extends Report> extends BaseModuleState<T> {

  Widget getBody() {
    Globals().printDebug("************************ Report: getBody");
    listProcess.sort(criteria);
    return FutureBuilder(
      future: Globals().getPrefs(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          Globals().printDebug('project snapshot data is: ${projectSnap.data}');
          return Container(
            color: Colors.black,
            child: Column(
              children: [
                Flexible(child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(
                        color: Colors.grey[800],
                        thickness: 2,
                      ),
                  itemCount: listProcess.length,
                  itemBuilder: (BuildContext context, int index) {
                    wordMain = listProcess[index] as Word;
                    String keyCorrect = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-correct';
                    SharedPreferences pref = projectSnap.data as SharedPreferences;
                    int correctCount = pref.getInt(keyCorrect) ?? 0;
                    Globals().printDebug('correct count:' + correctCount.toString());
                    Globals().printDebug('id:' + wordMain.id.toString());
                    String keyWrong = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-wrong';
                    int wrongCount = pref.getInt(keyWrong) ?? 0;
                    double totalCount = correctCount + wrongCount + 0.0001;
                    return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              flex:1,
                              child: FittedBox(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.all(10),
                                  child: _getMainText(wordMain),
                                ),
                              )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                children: [
                                  LinearPercentIndicator(
                                    lineHeight: 20.0,
                                    animation: true,
                                    animationDuration: 1000,
                                    percent: correctCount/totalCount,
                                    center: Text((correctCount/totalCount*100).round().toString() + '%'),
                                    progressColor: Colors.green,
                                    backgroundColor: Colors.black,
                                  ),
                                  LinearPercentIndicator(
                                    lineHeight: 20.0,
                                    animation: true,
                                    animationDuration: 2000,
                                    percent: wrongCount/totalCount,
                                    center: Text((wrongCount/totalCount*100).round().toString() + '%'),
                                    progressColor: Colors.red,
                                    backgroundColor: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ); // exercise
                  },
                )),
                getAd()
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          child: Text('...'),
        );
      },
    );
  }

  Widget _getMainText(word) {
    return super.getText(word.title,15, Colors.white);
  }

}
