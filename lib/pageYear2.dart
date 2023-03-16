import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';

class PageYear2 extends BaseModule {
  @override
  _PageYear2State createState() => _PageYear2State();
}

class _PageYear2State extends BaseModuleState<PageYear2> {

  String title = "Litera: 2º Ano";
  Color backgroundColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    useNavigation = false;
    useProgressBar = false;
    year = 2;
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
                prefs.setInt('expandedId',1);
              }
              return ListTile(
                  title: Text(
                      'Português',
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
                      int moduleIndex = ModulesYear2Portuguese.Words_Lesson_Words.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          getAssetsVocab('WORDS'),
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonWords',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + getAssetsVocab('WORDS'),
                                'list':alphabet,
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
                  ), // lesson: words
                  Container(
                    child: () {
                      int moduleIndex = ModulesYear2Portuguese.Words_Lesson_WordsOnset.index;
                      String title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('WORDS');
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonOnset2Words',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'mode': 'lesson',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': listOnsetConsonants
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // lesson: onset 2 words
                  Container(
                    child: () {
                      String title = getAssetsVocab('WORD') + " / " + getAssetsVocab('ONSETS');
                      int moduleIndex = ModulesYear2Portuguese.Words_Lesson_WordOnsets.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonWord2Onsets',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'mode': 'lesson',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'list': listWordOnset.where((word) => word.title.length <=6).toList(),
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
                  ), // lesson: word 2 onsets
                  Container(
                    child: () {
                      String title = getAssetsVocab('CONSONANTS') + " / " + getAssetsVocab('VOWELS');
                      int moduleIndex = ModulesYear2Portuguese.Words_Lesson_ConsonantsVowels.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/LessonWordsConsonantsVowels',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + title,
                                'list': mapWordMatch,
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
                  ), // lesson: consonants & vowels
                  Container(
                    child: () {
                      String title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
                      int moduleIndex = ModulesYear2Portuguese.Words_Exercise_WordsPicture.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleWords2Picture',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': listVocab.where((word) => word.title.length <=5).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise 1: words to picture
                  Container(
                    child: () {
                      String title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
                      int moduleIndex = ModulesYear2Portuguese.Words_Exercise_WordPictures.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleWord2Pictures',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + title,
                                'mode': 'exercise',
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
                  ), // exercise 2: word to pictures
                  Container(
                    child: () {
                      int moduleIndex = ModulesYear2Portuguese.Words_Exercise_Spelling1.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          getAssetsVocab('SPELLING') + ' 1',
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSpelling01',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + getAssetsVocab('SPELLING') + " 1",
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': alphabet.where((word) => word.title.length <=6).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise 3: spelling 1
                  Container(
                    child: () {
                      int moduleIndex = ModulesYear2Portuguese.Words_Exercise_Spelling2.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getExerciseIcon(),
                        title: Text(
                          getAssetsVocab('SPELLING') + ' 2',
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSpelling02',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('EXERCISE') + ": " + getAssetsVocab('SPELLING') + " 2",
                                'mode': 'exercise',
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': alphabet.where((word) => word.title.length <=6).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // exercise 4: spelling 2
                  Container(
                    child: () {
                      String title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
                      int moduleIndex = ModulesYear2Portuguese.Words_Test_WordsPicture.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleWords2Picture',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': listVocab.where((word) => word.title.length <=5).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test: words to picture
                  Container(
                    child: () {
                      String title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
                      int moduleIndex = ModulesYear2Portuguese.Words_Test_WordPictures.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleWord2Pictures',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + title,
                                'mode': 'test',
                                'numberQuestions': 20,
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
                  ), // test: word to pictures
                  Container(
                    child: () {
                      int moduleIndex = ModulesYear2Portuguese.Words_Test_Spelling1.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          getAssetsVocab('SPELLING') + ' 1',
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSpelling01',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + getAssetsVocab('SPELLING') + " 1",
                                'mode': 'test',
                                'numberQuestions': 20,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': alphabet.where((word) => word.title.length <=6 && word.title.length >3).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                          });
                        },
                      );
                    } (),
                  ), // test: spelling 1
                  Container(
                    child: () {
                      int moduleIndex = ModulesYear2Portuguese.Words_Test_Spelling2.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,1);
                      return ListTile(
                        leading: getTestIcon(),
                        title: Text(
                          getAssetsVocab('SPELLING') + ' 2',
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/ModuleSpelling02',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('TEST') + ": " + getAssetsVocab('SPELLING') + " 2",
                                'mode': 'test',
                                'numberQuestions': 20,
                                'year': year,
                                'subject': expandedId,  // whichever panel is expanded is the subject matter
                                'moduleIndex': moduleIndex,
                                'list': alphabet.where((word) => word.title.length <=6).toList()
                              }).then((_) {
                            // This block runs when you have returned back to the 1st Page from 2nd.
                            setState(() {
                              // Call setState to refresh the page.
                            });
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    } (),
                  ), // test: spelling 2
                ],
              ),
            ),
          ),  // Português
          ExpansionPanelRadio(
            value: 2,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (isExpanded) {
                expandedId = 2;
                prefs.setInt('expandedId',2);
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
                      String _title = "1 - 10 (extenso)";
                      int moduleIndex = ModulesYear2Math.Numbers_Lesson_1_10_Full.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          _title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonNumbersFull',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + _title,
                                'list': listNumber1t10,
                                'moduleIndex': moduleIndex
                              });
                        },
                      );
                    } (),
                  ),  // lesson: numbers 1-10
                  Container(
                    child: () {
                      String _title = "11 - 20 (extenso)";
                      int moduleIndex = ModulesYear2Math.Numbers_Lesson_11_20_Full.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          _title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonNumbersFull',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + _title,
                                'list': listNumber11t20,
                                'moduleIndex': moduleIndex
                              });
                        },
                      );
                    } (),
                  ),  // lesson: numbers 11-20
                  Container(
                    child: () {
                      String _title = "30 - 100 (extenso)";
                      int moduleIndex = ModulesYear2Math.Numbers_Lesson_11_20_Full.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          _title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonNumbersFull',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + _title,
                                'list': listNumber30t100,
                                'moduleIndex': moduleIndex
                              });
                        },
                      );
                    } (),
                  ),  // lesson: numbers 30-100
                  Container(
                    child: () {
                      String _title = "1 - 10 (ordinais)";
                      int moduleIndex = ModulesYear2Math.Numbers_Lesson_1_10_Ordinals.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          _title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonNumbersFull',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + _title,
                                'list': listNumber1t10Ordinal,
                                'moduleIndex': moduleIndex
                              });
                        },
                      );
                    } (),
                  ),  // lesson: numbers 1-10 ordinais
                  Container(
                    child: () {
                      String _title = "20 - 100 (ordinais)";
                      int moduleIndex = ModulesYear2Math.Numbers_Lesson_20_100_Ordinals.index;
                      bool isModuleLocked = moduleIndex > getUnlockModuleIndex(year,2);
                      return ListTile(
                        leading: getLessonIcon(),
                        title: Text(
                          _title,
                          style: getModuleStyle(isModuleLocked),
                        ),
                        trailing: getLockIcon(isModuleLocked),
                        onTap: () {
                          if (!isModuleLocked) Navigator.pushNamed(context, '/lessonNumbersFull',
                              arguments: <String, Object>{
                                'title': getAssetsVocab('LESSON') + ": " + _title,
                                'list': listNumber20t100Ordinal,
                                'moduleIndex': moduleIndex
                              });
                        },
                      );
                    } (),
                  ),  // lesson: numbers 20-100 ordinais
                ],
              ),
            ),
          ),  // Matemática
        ],
      ),
    );
  }

}