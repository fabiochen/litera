import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/module.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class PageYear1 extends BaseModule {
  @override
  _PageYear1State createState() => _PageYear1State();
}

class _PageYear1State extends BaseModuleState<PageYear1> {

  int year = Year.ONE.index;
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
                children: _getTiles(context, listModulesYear1Por),
              ),
            ),
          ),  // Portuguese
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
              );},
            canTapOnHeader: true,
            backgroundColor: Colors.teal[400],
            body: Container(
              color: Colors.teal[300],
              child: Column(
                children: _getTiles(context, listModulesYear1Mat),
              ),
            ),
          ),  // Math
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

    if (modulePos is ModulePosYear1Por) {
      switch(modulePos) {
        case ModulePosYear1Por.Letters_Lesson_Alphabet:
          if (moduleStatus <= 0) Navigator.pushNamed(
              context, '/lessonAlphabet',
              arguments: <String, Object>{
                'useNavigation':true,
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': alphabet,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index
              }
          ).then((_) {
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
        case ModulePosYear1Por.Letters_Lesson_Vowels:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonLetters',
              arguments: <String, Object>{
                'list': listVowels,
                'title': getAssetsVocab('LESSON') + ": " + title,
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
        case ModulePosYear1Por.Letters_Exercise_OrderVowels:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleOrder',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': valOrderVowels
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Por.Letters_Exercise_OrderAlphabet:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleOrder',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': valOrderAlphabet
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Por.Letters_Exercise_LettersOnset:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleLetters2Onset',
              arguments: <String, Object>{
                'useNavigation':true,
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': letterOnsetList
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });

          break;
        case ModulePosYear1Por.Letters_Exercise_MatchCase:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleMatchCase',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'isVisibleTarget':true,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': lettersMatchCase
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });

          break;
        case ModulePosYear1Por.Letters_Test_LettersImage:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleLetters2Picture',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'numberQuestions': 20,
                'useNavigation':false,
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
        case ModulePosYear1Por.Letters_Test_LettersOnset:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleLetters2Onset',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'numberQuestions': 20,
                'useNavigation':false,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': letterOnsetList
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });

          break;
        case ModulePosYear1Por.Letters_Test_MatchCase:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleMatchCase',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                //'numberQuestions': 20,
                'isVisibleTarget': true,
                'useNavigation':false,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': lettersMatchCase
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });

          break;
        case ModulePosYear1Por.Syllables_Lesson_Syllables:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/LessonSyllables',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
                'list': listSyllables,
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
        case ModulePosYear1Por.Syllables_Lesson_Consonant_Vowels:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/LessonSyllablesConsonantsVowels',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
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
        case ModulePosYear1Por.Syllables_Lesson_Words:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonSyllables2Words',
              arguments: <String, Object>{
                'title': getAssetsVocab('LESSON') + ": " + title,
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
        case ModulePosYear1Por.Syllables_Exercise_SyllablesSound:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSyllableOnset2Text',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': listSyllables
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Por.Syllables_Exercise_SyllablesWord:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSyllablesWord',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': syllableUnique.where((word) => word.title.length == 4).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Por.Syllables_Test_SyllablesSound:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSyllableOnset2Text',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'numberQuestions': 20,
                'useNavigation': false,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': listSyllables
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Por.Syllables_Test_SyllablesWord:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleSyllablesWord',
              arguments: <String, Object>{
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'test',
                'numberQuestions': 20,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': syllableUnique.where((word) =>
                word.title.length == 4
                ).toList()
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              print("back from module");
              expandedId[year] = 2;
              subject = expandedId[year];
              prefs.setInt('expandedId[year]',expandedId[year]);
              print("expandedId[year]: $expandedId[year]");
              // Call setState to refresh the page.
            });
          });
          break;
      }
    }
    else {
      switch(modulePos) {
      case ModulePosYear1Mat.Numbers_Lesson_1_10:
        if (moduleStatus <= 0) Navigator.pushNamed(context, '/lessonNumbers',
            arguments: <String, Object>{
              'title': getAssetsVocab('LESSON') + ": " + title,
              'list': listNumber1t20.where((word) => word.id <= 154).toList(),
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
      case ModulePosYear1Mat.Numbers_Exercise_NumbersPicture:
        if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Picture',
            arguments: <String, Object>{
              'title': getAssetsVocab('EXERCISE') + ": " + title,
              'mode': 'exercise',
              'list': listNumber1t20.where((word) => word.id <= 154).toList(),
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
        case ModulePosYear1Mat.Numbers_Exercise_OrderNumbers:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleOrderNumeric',
              arguments: <String, Object>{
                // 'useNavigation': false,
                // 'useProgressBar': false,
                'title': getAssetsVocab('EXERCISE') + ": " + title,
                'mode': 'exercise',
                'year': year,
                'subject':expandedId[year],
                'moduleIndex': modulePos.index,
                'list': valOrderNumbers
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Mat.Numbers_Test_NumbersPicture:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleNumbers2Picture',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                'list': listNumber1t20.where((word) => word.id <= 154).toList(),
                'numberQuestions': 20,
                'useNavigation':false,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
              }).then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            setState(() {
              // Call setState to refresh the page.
            });
          });
          break;
        case ModulePosYear1Mat.Numbers_Test_OrderNumbers:
          if (moduleStatus <= 0) Navigator.pushNamed(context, '/ModuleOrderNumeric',
              arguments: <String, Object>{
                'title': getAssetsVocab('TEST') + ": " + title,
                'mode': 'test',
                // 'useNavigation': false,
                // 'useProgressBar': false,
                'year': year,
                'subject': expandedId[year],  // whichever panel is expanded is the subject matter
                'moduleIndex': modulePos.index,
                'list': valOrderNumbers
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