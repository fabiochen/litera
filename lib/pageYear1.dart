import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

class PageYear1 extends BaseModule {
  @override
  _PageYear1State createState() => _PageYear1State();
}

class _PageYear1State extends BaseModuleState<PageYear1> {

  String title = "Litera: 1º Ano";
  Color backgroundColor = Colors.teal;
  
  @override
  void initState() {
    super.initState();
    useNavigation = false;
    useProgressBar = false;
    year = 1;
    bannerAd.load();
  }

  @override
  Widget getMainTile() {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: expandedId,
        children: [
          ExpansionPanelRadio(
            value: 1,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (isExpanded) {
                expandedId = 1;
                subject = expandedId;
                prefs.setInt('expandedId',expandedId);
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
                children: [
                  Container(
                    child: () {
                      String title = getAssetsVocab('ALPHABET');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Lesson_Alphabet.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/lessonAlphabet',
                              arguments: <String, Object>{
                                'useNavigation':true,
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'list': alphabet,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex
                              }
                          ).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              print("year 1 page: $moduleIndex");
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // lesson 1: alphabet
                  Container(
                    child: () {
                      String title = getAssetsVocab('VOWELS');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Lesson_Vowels.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonLetters',
                              arguments: <String, Object>{
                                'list' : listVowels,
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // lesson 2: vowels
                  Container(
                    child: () {
                      String title = getAssetsVocab('ORDER-VOWELS');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Exercise_OrderVowels.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleOrder',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': valOrderVowels
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise #1: vowel order
                  Container(
                    child: () {
                      String title = getAssetsVocab('ORDER-ALPHABET');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Exercise_OrderAlphabet.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleOrder',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': valOrderAlphabet
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise #2: consonant order
                  Container(
                    child: () {
                      String title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('LETTERS');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Exercise_LettersOnset.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleLetters2Onset',
                              arguments: <String, Object>{
                                'useNavigation':true,
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': letterOnsetList
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise #3: letter 2 audio
                  Container(
                    child: () {
                      String title = getAssetsVocab('MATCH-CASE');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Exercise_MatchCase.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleMatchCase',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'isVisibleTarget':true,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': lettersMatchCase
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise #4: match case
                  Container(
                    child: () {
                      String title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('LETTERS');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Test_LettersImage.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleLetters2Picture',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
                                'useNavigation':false,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': alphabet
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test #1: letter 2 picture
                  Container(
                    child: () {
                      String title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('LETTERS');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Test_LettersOnset.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleLetters2Onset',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
                                'useNavigation':false,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': letterOnsetList
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test #2: letter 2 audio
                  Container(
                    child: () {
                      String title = getAssetsVocab('MATCH-CASE');
                      int moduleIndex = ModulesYear1Portuguese.Letters_Test_MatchCase.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleMatchCase',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                //'numberQuestions': 20,
                                'isVisibleTarget': true,
                                'useNavigation':false,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': lettersMatchCase
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test #3: match case
                  Divider(
                    color: Colors.teal,
                  ),
                  Container(
                    child: () {
                      String title = getAssetsVocab('SYLLABLES');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Lesson_Syllables.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked)
                            Navigator.pushNamed(context, '/LessonSyllables',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('LESSON') + ": " + title,
                                  'list': listSyllables,
                                  'year': year,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': moduleIndex
                                }).then((_) {
                              // This block runs when you have returned back to the 1st Page from 2nd.
                              setState(() {
                                // Call setState to refresh the page.
                              });
                            });
                        },
                      );
                    } (),
                  ), // lesson: syllable
                  Container(
                    child: () {
                      String title = getAssetsVocab('CONSONANTS') + " / " + getAssetsVocab('VOWELS');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Lesson_Consonant_Vowels.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/LessonSyllablesConsonantsVowels',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // lesson: consonants / vowels
                  Container(
                    child: () {
                      String title = getAssetsVocab('SYLLABLES')  + " / " + getAssetsVocab('WORDS');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Lesson_Words.index;
                      print("ModuleIndex: $moduleIndex");
                      print("unlockModuleIndex: ${getUnlockModuleIndex(year,1)}");
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonSyllables2Words',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // lesson: syllables / words
                  Container(
                    child: () {
                      String title = getAssetsVocab('SOUND') + " / " + getAssetsVocab('SYLLABLES');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Exercise_SyllablesSound.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSyllableOnset2Text',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': listSyllables
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise 1
                  Container(
                    child: () {
                      String title = getAssetsVocab('WORD') + " / " + getAssetsVocab('SYLLABLES');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Exercise_SyllablesWord.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSyllableWord',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': syllableUnique.where((word) => word.title.length == 4).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise 2
                  Container(
                    child: () {
                      String title = getAssetsVocab('SOUND')  + " / " + getAssetsVocab('SYLLABLES');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Test_SyllablesSound.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSyllableOnset2Text',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
                                'useNavigation': false,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': listSyllables
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test 1
                  Container(
                    child: () {
                      String title = getAssetsVocab('WORD') + " / " + getAssetsVocab('SYLLABLES');
                      int moduleIndex = ModulesYear1Portuguese.Syllables_Test_SyllablesWord.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSyllableWord',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': syllableUnique.where((word) =>
                                    word.title.length == 4
                                ).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test 2
                ],
              ),
            ),
          ),  // Portuguese
          ExpansionPanelRadio(
            value: 2,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (isExpanded) {
                expandedId = 2;
                subject = expandedId;
                prefs.setInt('expandedId',expandedId);
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
                children: [
                  Container(
                    child: () {
                      String title = "1 - 10";
                      int moduleIndex = ModulesYear1Math.Numbers_Lesson_1_10.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonNumbers',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'list': listNumber1t10,
                                'year': year,
                                'subject': expandedId,
                                'moduleIndex': moduleIndex
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ),  // lesson: numbers
                  Container(
                    child: () {
                      String title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
                      int moduleIndex = ModulesYear1Math.Numbers_Exercise_NumbersPicture.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleNumbers2Picture',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject':expandedId,
                                'moduleIndex': moduleIndex,
                                'list': listNumber1t10
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ),  // exercise
                  Container(
                    child: () {
                      String title = getAssetsVocab('ORDER-NUMBERS');
                      int moduleIndex = ModulesYear1Math.Numbers_Exercise_OrderNumbers.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleOrderNumeric',
                              arguments: <String, Object>{
                                // 'useNavigation': false,
                                // 'useProgressBar': false,
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject':expandedId,
                                'moduleIndex': moduleIndex,
                                'list': valOrderNumbers
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ),  // exercise: numerical order
                  Container(
                    child: () {
                      String title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
                      int moduleIndex = ModulesYear1Math.Numbers_Test_NumbersPicture.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleNumbers2Picture',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
                                'useNavigation':false,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': listNumber1t10
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ),  // test
                  Container(
                    child: () {
                      String title = getAssetsVocab('ORDER-NUMBERS');
                      int moduleIndex = ModulesYear1Math.Numbers_Test_OrderNumbers.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleOrderNumeric',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                // 'useNavigation': false,
                                // 'useProgressBar': false,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': valOrderNumbers
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ),  // test: numbers
                ],
              ),
            ),
          ),  // Math
        ],
      ),
    );
  }

  // Widget getMenu() {
  //   return Menu();
  // }

}