import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/module.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class PageYear2 extends BaseModule {
  @override
  _PageYear2State createState() => _PageYear2State();
}

class _PageYear2State extends BaseModuleState<PageYear2> {

  int year = Year.TWO.index;
  String title;
  Color backgroundColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    useNavigation = false;
    useProgressBar = false;
    title = "$appTitle: " + (year+1).toString() +"º Ano";
    bannerAd.load();
  }

  @override
  Widget getMainTile() {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: expandedId[year],
        children: [
          ExpansionPanelRadio(
            value: 0,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (isExpanded) {
                subject = Subject.PORTUGUESE.index;
                expandedId[year] = 0;
                prefs.setInt('expandedId-$year',expandedId[year]);
              }
              return ListTile(
                  title: Text(
                      'Português',
                      textAlign: TextAlign.left,
                      style: getModuleStyle(false)
                  )
              );
            },
            canTapOnHeader: true,
            backgroundColor: Colors.teal[400],
            body: Container(
              color: Colors.teal[300],
              child: Column(
                children: _getTiles(context, listModulesYear2Por),
              ),
            ),
          ),  // Portugues
          ExpansionPanelRadio(
            value: 1,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (isExpanded) {
                subject = Subject.MATH.index;
                expandedId[year] = 1;
                prefs.setInt('expandedId-$year',expandedId[year]);
              }
              return ListTile(
                  title: Text(
                      'Matemática',
                      textAlign: TextAlign.left,
                      style: getModuleStyle(false)
                  )
              );
            },
            canTapOnHeader: true,
            backgroundColor: Colors.teal[400],
            body: Container(
              color: Colors.teal[300],
              child: Column(
                children: _getTiles(context, listModulesYear2Mat),
              ),
            ),
          ),  // Matemática
        ],
      ),
    );
  }

  List<ListTile> _getTiles(context, List<Module> list) {
    List<ListTile> listTemp = [];
    list.forEach((_module) { listTemp.add(_getListTile(context, _module));});
    return listTemp;
  }

  ListTile _getListTile(dynamic context, Module _module) {
    String title = _module.title;
    var modulePos = _module.id;
    moduleIndex = modulePos.index;
    int subjectIndex = _module.subject.index;
    int _moduleStatus = moduleIndex.compareTo(getUnlockModuleIndex(year,subjectIndex));
    // printDebug("_getListTile");
    // printDebug("year: $year");
    // printDebug("subject: $subjectIndex");
    // print("moduleIndex: $moduleIndex");

    Icon iconModuleType;
    switch (_module.type) {
      case ModuleType.LESSON:
        iconModuleType = getLessonIcon();
        break;
      case ModuleType.EXERCISE:
        iconModuleType = getExerciseIcon();
        break;
      case ModuleType.TEST:
        iconModuleType = getTestIcon();
        break;
    }
    return ListTile(
        leading: iconModuleType,
        title: (_moduleStatus > 0) ? Text(
          title,
          style: getModuleStyle(true),
        ): (_moduleStatus == 0) ? AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              title,
              textStyle: const TextStyle(
                fontSize: 20.0,
              ),
              speed: const Duration(milliseconds: 200),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
          onTap: () {
            _onTap(context, modulePos, _moduleStatus, title);
          },
        ) : Text(
          title,
          style: getModuleStyle(false),
        ),
        trailing: getLockIcon(_moduleStatus > 0),
        onTap: () {
          _onTap(context, modulePos, _moduleStatus, title);
        }
    );
  }

  _onTap(dynamic context, var modulePos, int moduleStatus, title) {

    if (modulePos is ModulePosYear2Por) {
      switch (modulePos) {
        case ModulePosYear2Por.Words_Lesson_Words:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonWords',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " +
                    title,
                'list': alphabet,
                'year': year,
                'subject': expandedId[year],
                // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Lesson_WordsOnset:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonOnset2Words',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'mode': 'lesson',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': listOnsetConsonants
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Lesson_WordOnsets:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonWord2Onsets',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'mode': 'lesson',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'list': listWordOnset.where((word) => word.title.length <=6).toList(),
                'moduleIndex': modulePos.index
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Lesson_ConsonantsVowels:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/LessonWordsConsonantsVowels',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': mapWordMatch,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Exercise_WordsPicture:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleWords2Picture',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': listVocab.where((word) => word.title.length <=5).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Exercise_WordPictures:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleWord2Pictures',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': alphabet
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Exercise_Spelling1:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSpelling01',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + getAssetsVocab('SPELLING') + " 1",
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': alphabet.where((word) => word.title.length <=6).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Exercise_Spelling2:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSpelling02',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + getAssetsVocab('SPELLING') + " 2",
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': alphabet.where((word) => word.title.length <=6).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Test_WordsPicture:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleWords2Picture',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'numberQuestions': 20,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': listVocab.where((word) => word.title.length <=5).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Test_WordPictures:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleWord2Pictures',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": $title",
                'mode': 'test',
                'numberQuestions': 20,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': alphabet
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Test_Spelling1:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSpelling01',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": $title",
                'mode': 'test',
                'numberQuestions': 20,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': alphabet.where((word) => word.title.length <=6 && word.title.length >3).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Por.Words_Test_Spelling2:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSpelling02',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'numberQuestions': 20,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': alphabet.where((word) => word.title.length <=6).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
            Navigator.of(context).pop();
          });
          break;
      }
    }
    else {
      switch(modulePos) {
        case ModulePosYear2Mat.Numbers_Lesson_1_20_Full:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonNumbersFull',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': listNumber1t20,
                'year': year,
                'subject':expandedId[year],
                'moduleIndex': modulePos.index
              }).then((_) {
            setState(() {
              printDebug("return from module");
              printDebug("year: $year");
              printDebug("subject: $subject");
              printDebug("saved modulePos: " + getUnlockModuleIndex(year, subject).toString());
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Exercise_WordNumbers1_20:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'list': listNumber1t20,
                'year': year,
                'subject':expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Test_WordNumbers1_20:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'list': listNumber1t20,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Lesson_30_100_Full:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonNumbersFull',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': listNumber30t100,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Exercise_WordNumbers30_100:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'list': listNumber30t100,
                'year': year,
                'subject':expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Test_WordNumbers30_100:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'list': listNumber30t100,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Lesson_1_10_Ordinals:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonNumbersFull',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': listNumber1t10Ordinal,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Exercise_1_10_Ordinals:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'list': listNumber1t10Ordinal,
                'year': year,
                'subject':expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Test_1_10_Ordinals:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'list': listNumber1t10Ordinal,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Lesson_20_100_Ordinals:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonNumbersFull',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': listNumber20t100Ordinal,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Exercise_20_100_Ordinals:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'list': listNumber20t100Ordinal,
                'year': year,
                'subject':expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear2Mat.Numbers_Test_20_100_Ordinals:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Word',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'list': listNumber20t100Ordinal,
                'year': year,
                'subject': expandedId[year],
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
      }
    }
  }

}