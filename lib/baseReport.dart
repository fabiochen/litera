import 'package:litera/word.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BaseReport extends BaseModule {
  @override
  BaseReportState createState() => BaseReportState();
}

class BaseReportState<T extends BaseReport> extends BaseModuleState<T> {

  Comparator<Object> criteria = (a, b) => (a as Word).id.compareTo((b as Word).id);

  Widget getBody() {
    listProcess.sort(criteria);
    return FutureBuilder(
      future: getPrefs(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          print('project snapshot data is: ${projectSnap.data}');
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
                  itemCount: listProcess == null
                      ? 0
                      : listProcess.length,
                  itemBuilder: (BuildContext context, int index) {
                    wordMain = listProcess[index];
                    int correctCount = projectSnap.data.get(
                        'reports-$yearIndex-$subject-$moduleIndex-' + wordMain.id.toString() + '-correct') ?? 0;
                    print('correct count:' + correctCount.toString());
                    print('id:' + wordMain.id.toString());
                    int wrongCount = projectSnap.data.get(
                        'reports-$yearIndex-$subject-$moduleIndex-' + wordMain.id.toString() + '-wrong') ?? 0;
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
                                  child: _getMainText(),
                                ),
                              )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                children: [
                                  LinearPercentIndicator(
                                    lineHeight: 15.0,
                                    animation: true,
                                    animationDuration: 1000,
                                    percent: correctCount/totalCount,
                                    center: Text((correctCount/totalCount*100).round().toString() + '%'),
                                    progressColor: Colors.green,
                                    backgroundColor: Colors.black,
                                    linearStrokeCap: LinearStrokeCap.butt,
                                  ),
                                  LinearPercentIndicator(
                                    lineHeight: 15.0,
                                    animation: true,
                                    animationDuration: 2000,
                                    percent: wrongCount/totalCount,
                                    center: Text((wrongCount/totalCount*100).round().toString() + '%'),
                                    progressColor: Colors.red,
                                    backgroundColor: Colors.black,
                                    linearStrokeCap: LinearStrokeCap.butt,
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

  String getMainLabel() {
    return wordMain.title;
  }

  Text _getMainText() {
    return super.getMainText(15);
  }
}
