import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'globals.dart';
import 'lessonCategory2Words.dart';
import 'lessonWordPairs.dart';
import 'moduleLetters2Picture.dart';
import 'moduleTonicOption.dart';
import 'moduleTonicSyllable.dart';
import 'moduleWord2Pictures.dart';
import 'pageHome.dart';
import 'pageAbout.dart';
import 'pageContact.dart';
import 'pageSettings.dart';
import 'report.dart';
import 'lessonAlphabet.dart';
import 'lessonAlphabetLetters.dart';
import 'lessonAlphabetCursive.dart';
import 'lessonLetters.dart';
import 'lessonImageText.dart';
import 'lessonWords.dart';
import 'lessonWordAndWord.dart';
import 'moduleOrder.dart';
import 'moduleOrderNumeric.dart';
import 'moduleMatchCase.dart';
import 'moduleBeforeAndAfter.dart';
import 'lessonWordsAndPicture.dart';
import 'lessonSyllables.dart';
import 'lessonSyllablesConsonantsVowels.dart';
import 'moduleSound2Words.dart';
import 'moduleSyllablesWord.dart';
import 'lessonOnset2Words.dart';
import 'lessonWord2Onsets.dart';
import 'lessonCategory2Word2Picture.dart';
import 'moduleWords2Picture.dart';
import 'moduleWord2Numbers.dart';
import 'moduleNumbers2Picture.dart';
import 'moduleNumbers2Word.dart';
import 'moduleLetters2Onset.dart';
import 'moduleSpelling01.dart';
import 'moduleSpelling02.dart';
import 'moduleGenderNumber.dart';
import 'lessonClock.dart';
import 'lessonClockDigital.dart';
import 'moduleClock.dart';
import 'lessonHangman.dart';
import 'moduleSyllablesCount.dart';
import 'moduleLeftRight.dart';
import 'lessonWordSearch.dart';
import 'lessonTonic.dart';

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
      future: Globals().init(),
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
                '/LessonAlphabetLetters'     : (context) => LessonAlphabetLetters(),
                '/LessonAlphabetCursive'     : (context) => LessonAlphabetCursive(),
                '/LessonAlphabet'            : (context) => LessonAlphabet(),
                '/LessonLetters'             : (context) => LessonLetters(),
                '/LessonClock'               : (context) => LessonClock(),
                '/LessonClockDigital'        : (context) => LessonClockDigital(),
                '/LessonHangman'             : (context) => LessonHangman(),
                '/ModuleClock'               : (context) => ModuleClock(),
                '/ModuleOrder'               : (context) => ModuleOrder(),
                '/ModuleGenderNumber'        : (context) => ModuleGenderNumber(),
                '/ModuleBeforeAndAfter'      : (context) => ModuleBeforeAndAfter(),
                '/ModuleLetters2Onset'       : (context) => ModuleLetters2Onset(),
                '/ModuleMatchCase'           : (context) => ModuleMatchCase(),
                '/ModuleLetters2Picture'     : (context) => ModuleLetters2Picture(),
                '/LessonSyllables'           : (context) => LessonSyllables(),
                '/LessonSyllablesConsonantsVowels' : (context) => LessonSyllablesConsonantsVowels(),
                '/LessonCategory2Words'     : (context) => LessonCategory2Words(),
                '/ModuleSound2Words'         : (context) => ModuleSound2Words(),
                '/ModuleSyllablesWord'       : (context) => ModuleSyllablesWord(),
                '/LessonImageText'             : (context) => LessonImageText(),
                '/ModuleNumbers2Picture'     : (context) => ModuleNumbers2Picture(),
                '/ModuleOrderNumeric'        : (context) => ModuleOrderNumeric(),
                '/LessonWords'               : (context) => LessonWords(),
                '/LessonWordsAndPicture'     : (context) => LessonWordsAndPicture(),
                '/LessonWordPairs'           : (context) => LessonWordPairs(),
                '/LessonOnset2Words'         : (context) => LessonOnset2Words(),
                '/LessonWord2Onsets'         : (context) => LessonWord2Onsets(),
                '/LessonWordsConsonantsVowels' : (context) => LessonCategory2Word2Picture(),
                '/ModuleWords2Picture'       : (context) => ModuleWords2Picture(),
                '/ModuleWord2Pictures'       : (context) => ModuleWord2Pictures(),
                '/ModuleSpelling01'          : (context) => ModuleSpelling01(),
                '/ModuleSpelling02'          : (context) => ModuleSpelling02(),
                '/LessonWordAndWord'         : (context) => LessonWordAndWord(),
                '/ModuleNumbers2Word'        : (context) => ModuleNumbers2Word(),
                '/ModuleWord2Numbers'        : (context) => ModuleWord2Numbers(),
                '/ModuleSyllablesCount'      : (context) => ModuleSyllablesCount(),
                '/ModuleLeftRight'           : (context) => ModuleLeftRight(),
                '/LessonWordSearch'          : (context) => LessonWordSearch(),
                '/LessonTonic'               : (context) => LessonTonic(),
                '/ModuleTonicSyllable'       : (context) => ModuleTonicSyllable(),
                '/ModuleTonicOption'         : (context) => ModuleTonicOption(),

                '/BaseReport'                : (context) => Report(),
              }
          );
        }
        return Container();
      },
    );
  }

}