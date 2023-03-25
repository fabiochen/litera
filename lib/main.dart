import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:litera/globals.dart';
import 'package:litera/lessonSyllables2Words.dart';
import 'package:litera/moduleLetters2Picture.dart';
import 'package:litera/moduleWord2Pictures.dart';

import 'package:litera/pageHome.dart';

import 'package:litera/pageAbout.dart';
import 'package:litera/pageContact.dart';
import 'package:litera/pageSettings.dart';

import 'package:litera/report.dart';

import 'package:litera/lessonAlphabet.dart';
import 'package:litera/lessonLetters.dart';
import 'package:litera/lessonNumbers.dart';
import 'package:litera/lessonNumbersFull.dart';
import 'package:litera/moduleOrder.dart';
import 'package:litera/moduleOrderNumeric.dart';
import 'package:litera/moduleMatchCase.dart';
import 'package:litera/lessonWords.dart';
import 'package:litera/lessonSyllables.dart';
import 'package:litera/lessonSyllablesConsonantsVowels.dart';
import 'package:litera/moduleSyllableOnset2Text.dart';
import 'package:litera/moduleSyllablesWord.dart';
import 'package:litera/lessonOnset2Words.dart';
import 'package:litera/lessonWord2Onsets.dart';
import 'package:litera/lessonWordsConsonantsVowels.dart';
import 'package:litera/moduleWords2Picture.dart';
import 'package:litera/moduleNumbers2Picture.dart';
import 'package:litera/moduleNumbers2Word.dart';
import 'package:litera/moduleLetters2Onset.dart';
import 'package:litera/moduleSpelling01.dart';
import 'package:litera/moduleSpelling02.dart';

void main() {
  runApp(
      Phoenix(
        child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.grey[200],
                  textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.black,
                  )
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: {
                '/'                          : (context) => PageHome(),
                '/PageAbout'                 : (context) => PageAbout(),
                '/PageContact'               : (context) => PageContact(),
                '/PageSettings'              : (context) => PageSettings(),
                '/LessonAlphabet'            : (context) => LessonAlphabet(),
                '/LessonLetters'             : (context) => LessonLetters(),
                '/ModuleOrder'               : (context) => ModuleOrder(),
                '/ModuleLetters2Onset'       : (context) => ModuleLetters2Onset(),
                '/ModuleMatchCase'           : (context) => ModuleMatchCase(),
                '/ModuleLetters2Picture'     : (context) => ModuleLetters2Picture(),
                '/LessonSyllables'           : (context) => LessonSyllables(),
                '/LessonSyllablesConsonantsVowels' : (context) => LessonSyllablesConsonantsVowels(),
                '/LessonSyllables2Words'     : (context) => LessonSyllables2Words(),
                '/ModuleSyllableOnset2Text'  : (context) => ModuleSyllableOnset2Text(),
                '/ModuleSyllablesWord'       : (context) => ModuleSyllablesWord(),
                '/LessonNumbers'             : (context) => LessonNumbers(),
                '/ModuleNumbers2Picture'     : (context) => ModuleNumbers2Picture(),
                '/ModuleOrderNumeric'        : (context) => ModuleOrderNumeric(),
                '/LessonWords'               : (context) => LessonWords(),
                '/LessonOnset2Words'         : (context) => LessonOnset2Words(),
                '/LessonWord2Onsets'         : (context) => LessonWord2Onsets(),
                '/LessonWordsConsonantsVowels' : (context) => LessonWordsConsonantsVowels(),
                '/ModuleWords2Picture'       : (context) => ModuleWords2Picture(),
                '/ModuleWord2Pictures'       : (context) => ModuleWord2Pictures(),
                '/ModuleSpelling01'          : (context) => ModuleSpelling01(),
                '/ModuleSpelling02'          : (context) => ModuleSpelling02(),
                '/LessonNumbersFull'         : (context) => LessonNumbersFull(),
                '/ModuleNumbers2Word'        : (context) => ModuleNumbers2Word(),

                '/BaseReport'                : (context) => Report(),
              }
          );
        }
        return Container();
      },
    );
  }

}