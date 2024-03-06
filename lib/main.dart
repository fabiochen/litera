import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:litera/lessonTableMult.dart';
import 'package:litera/lessonTableDiv.dart';
import 'package:litera/unitMemoryGame.dart';
import 'package:litera/unitPiano.dart';

import 'globals.dart';
import 'unitCategory2Words.dart';
import 'lessonMath.dart';
import 'lessonMusic.dart';
import 'lessonWordPairs.dart';
import 'moduleCategory2Option.dart';
import 'moduleCategoryOption.dart';
import 'moduleColors.dart';
import 'moduleHomophone2Options.dart';
import 'moduleLetters2Picture.dart';
import 'moduleMath.dart';
import 'modulePiano.dart';
import 'moduleSound2Images.dart';
import 'moduleTimesTable.dart';
import 'moduleTimesTable2.dart';
import 'moduleTimesTable3.dart';
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
import 'modulePicture2Words.dart';
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
import 'unitHangman.dart';
import 'moduleSyllablesCount.dart';
import 'moduleLeftRight.dart';
import 'unitWordSearch.dart';
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
      future: Globals().init(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: Globals().appBarColorDark,
                  foregroundColor: Globals().appFontColorLight,
                ),
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
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
                '/UnitHangman'               : (context) => UnitHangman(),
                '/ModuleClock'               : (context) => ModuleClock(),
                '/ModuleOrder'               : (context) => ModuleOrder(),
                '/ModuleGenderNumber'        : (context) => ModuleGenderNumber(),
                '/ModuleBeforeAndAfter'      : (context) => ModuleBeforeAndAfter(),
                '/ModuleLetters2Onset'       : (context) => ModuleLetters2Onset(),
                '/ModuleMatchCase'           : (context) => ModuleMatchCase(),
                '/ModuleLetters2Picture'     : (context) => ModuleLetters2Picture(),
                '/LessonSyllables'           : (context) => LessonSyllables(),
                '/LessonSyllablesConsonantsVowels' : (context) => LessonSyllablesConsonantsVowels(),
                '/UnitCategory2Words'        : (context) => UnitCategory2Words(),
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
                '/LessonCategory2Word2Picture' : (context) => LessonCategory2Word2Picture(),
                '/ModulePicture2Words'       : (context) => ModulePicture2Words(),
                '/ModuleWord2Pictures'       : (context) => ModuleWord2Pictures(),
                '/ModuleSpelling01'          : (context) => ModuleSpelling01(),
                '/ModuleSpelling02'          : (context) => ModuleSpelling02(),
                '/LessonWordAndWord'         : (context) => LessonWordAndWord(),
                '/ModuleNumbers2Word'        : (context) => ModuleNumbers2Word(),
                '/ModuleWord2Numbers'        : (context) => ModuleWord2Numbers(),
                '/ModuleSyllablesCount'      : (context) => ModuleSyllablesCount(),
                '/ModuleLeftRight'           : (context) => ModuleLeftRight(),
                '/UnitWordSearch'            : (context) => UnitWordSearch(),
                '/LessonTonic'               : (context) => LessonTonic(),
                '/ModuleTonicSyllable'       : (context) => ModuleTonicSyllable(),
                '/ModuleTonicOption'         : (context) => ModuleTonicOption(),
                '/ModuleCategoryOption'      : (context) => ModuleCategoryOption(),
                '/ModuleCategory2Option'     : (context) => ModuleCategory2Option(),
                '/LessonMath'                : (context) => LessonMath(),
                '/ModuleColors'              : (context) => ModuleColors(),
                '/LessonMusic'               : (context) => LessonMusic(),
                '/ModuleSound2Images'        : (context) => ModuleSound2Images(),
                '/ModuleMath'                : (context) => ModuleMath(),
                '/UnitMemoryGame'            : (context) => UnitMemoryGame(),
                '/LessonTableMult'           : (context) => LessonTableMult(),
                '/LessonTableDiv'            : (context) => LessonTableDiv(),
                '/ModuleTimesTable'          : (context) => ModuleTimesTable(),
                '/ModuleTimesTable2'         : (context) => ModuleTimesTable2(),
                '/ModuleTimesTable3'         : (context) => ModuleTimesTable3(),
                '/UnitPiano'                 : (context) => UnitPiano(),
                '/ModulePiano'               : (context) => ModulePiano(),
                '/ModuleHomophone2Options'    : (context) => ModuleHomophone2Options(),

                '/Report'                    : (context) => Report(),
              }
          );
        }
        return Container();
      },
    );
  }

}