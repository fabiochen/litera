import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:share/share.dart';

class Menu extends BaseModule {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends BaseModuleState<Menu> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor:
                  menuColor, //This will change the drawer background.
              //other styles
            ),
            child: Drawer(
                child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Divider(
                          color: Colors.white
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          appTitle.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 20
                          ),
                        ),
                      ),
                      Divider(
                          color: Colors.white
                      )
                    ],
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                      IconData(59403, fontFamily: 'LiteraIcons'),
                      color: Colors.white,
                    ),
                    title: Text(
                        getAssetsVocab('ABOUT')),
                    onTap: () {
                      Navigator.pushNamed(context, '/pageAbout');
                    },
                  ),
                ),
                // about
                Container(
                  child: ListTile(
                    leading: Icon(
                      IconData(57574, fontFamily: 'LiteraIcons'),
                      color: Colors.white,
                    ),
                    title: Text(
                        getAssetsVocab('CONTACT')),
                    onTap: () {
                      Navigator.pushNamed(context, '/pageContact');
                    },
                  ),
                ),
                // contact
                Container(
                  child: ListTile(
                    leading: Icon(
                      IconData(59405, fontFamily: 'LiteraIcons'),
                      color: Colors.white,
                    ),
                    title: Text(
                        getAssetsVocab('SHARE')),
                    onTap: () => Share.share('*$appTitle*\n\nhttps://play.google.com/store/apps/details?id=net.unitasoft.litera.portuguese'),
                  ),
                ),
                // share
                Container(
                  child: ListTile(
                    leading: Icon(
                      IconData(59576, fontFamily: 'LiteraIcons'),
                      color: Colors.white,
                    ),
                    title: Text(
                        getAssetsVocab('SETTINGS')),
                    onTap: () {
                      Navigator.pushNamed(context, '/pageConfigure');
                    },
                  ),
                ),
                // settings

                ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  leading: getReportIcon(),
                  title: Text("Relatório - 1º Ano"),
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Português",
                        style: TextStyle(
                            fontWeight: FontWeight. bold
                        )
                      ),
                    ),  // português
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('LETTERS');
                        int _moduleIndex = ModulePosYear1Por.Letters_Test_LettersImage.index;
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            int size = alphabet.length;
                            printDebug("list length: $size");
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'year': Year.ONE.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': _moduleIndex,
                                  'list': alphabet
                                });
                          },
                        );
                      } (),
                    ),  // letters 1
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('ONSET') + " / " + getAssetsVocab('LETTERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportLetters2Onset',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'mode': 'report',
                                  'year': Year.ONE.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear1Por.Letters_Test_LettersOnset.index,
                                  'list': alphabetOnsetList
                                });
                          },
                        );
                      } (),
                    ),  // letters 2
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('MATCH-CASE');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              getAssetsVocab('MATCH-CASE')
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/reportMatchCase',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'mode': 'report',
                                  'year': Year.ONE.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear1Por.Letters_Test_MatchCase.index,
                                  'list': lettersMatchCase,
                                });
                          },
                        );
                      } (),
                    ),  // letters 3
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('SOUND')  + " / " + getAssetsVocab('SYLLABLES');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportSyllableSound2Text',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'mode': 'report',
                                  'year': Year.ONE.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear1Por.Syllables_Test_SyllablesSound.index,
                                  'list': listSyllables
                                });
                          },
                        );
                      } (),
                    ),  // syllables 1
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('WORD')  + " / " + getAssetsVocab('SYLLABLES');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'mode': 'report',
                                  'year': Year.ONE.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear1Por.Syllables_Test_SyllablesWord.index,
                                  'list': syllableUnique.where((word) => word.title.length == 4).toList()
                                });
                          },
                        );
                      } (),
                    ),  // syllables 2
                    Divider(
                      color: Colors.grey,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                          "Matemática",
                          style: TextStyle(
                              fontWeight: FontWeight. bold
                          )
                      ),
                    ),  // matematica
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              _moduleTitle
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportNumbers2Picture',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'mode': 'report',
                                  'year': Year.ONE.index,
                                  'subject': Subject.MATH.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear1Mat.Numbers_Test_NumbersPicture.index,
                                  'list': listNumber1t20.where((word) => word.id <= 154).toList(),
                                });
                          },
                        );
                      } (),
                    ),  // numbers 1
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('ORDER-NUMBERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              getAssetsVocab('ORDER-NUMBERS')
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/reportMatchCase',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": $_moduleTitle",
                                  'list': valOrderNumbers,
                                  'mode': 'report',
                                  'year': Year.ONE.index,
                                  'subject': Subject.MATH.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear1Mat.Numbers_Test_OrderNumbers.index,
                                });
                          },
                        );
                      } (),
                    ),  // numbers 2
                  ],
                ),
                ExpansionTile(
                  onExpansionChanged: () {
                    year = Year.TWO.index;
                  } (),
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  leading: getReportIcon(),
                  title: Text("Relatório - 2º Ano"),
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                          "Português",
                          style: TextStyle(
                              fontWeight: FontWeight. bold
                          )
                      ),
                    ),  // português
                    Container(
                      child: () {
                        String _moduleTitle = "Alfabeto (extenso)";
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'list': alphabet,
                                  'mode':'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear2Por.Words_Test_WordsPicture.index,
                                });
                          },
                        );
                      } (),
                    ),  // words 1
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'mode': 'report',
                                  'list': alphabet,
                                  'year': Year.TWO.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear2Por.Words_Test_WordPictures.index,
                                });
                          },
                        );
                      } (),
                    ),  // words 2
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('SPELLING') + ' 1';
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'list': alphabet.where((word) => word.title.length <=6).toList(),
                                  'mode': 'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear2Por.Words_Test_Spelling1.index,
                                });
                          },
                        );
                      } (),
                    ),  // words 3
                    Container(
                      child: () {
                        String _moduleTitle = getAssetsVocab('SPELLING') + ' 2';
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'list': alphabet,
                                  'mode': 'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.PORTUGUESE.index,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulePosYear2Por.Words_Test_Spelling2.index,
                                });
                          },
                        );
                      } (),
                    ),  // words 4

                    Divider(
                      color: Colors.grey,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                          "Matemática",
                          style: TextStyle(
                              fontWeight: FontWeight. bold
                          )
                      ),
                    ),  // matematica
                    Container(
                      child: () {
                        String _moduleTitle = '1-20 (extenso)';
                        int moduleIndex = ModulePosYear2Mat.Numbers_Test_WordNumbers1_20.index;
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'mode': 'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.MATH.index,
                                  'moduleIndex': moduleIndex,
                                  'list': listNumber1t20,
                                }).then((_) {
                              // This block runs when you have returned back to the 1st Page from 2nd.
                              setState(() {
                                // Call setState to refresh the page.
                              });
                            });
                          },
                        );
                      } (),
                    ),  // test: words / number
                    Container(
                      child: () {
                        String _moduleTitle = "30-100 (extenso)";
                        int moduleIndex = ModulePosYear2Mat.Numbers_Test_WordNumbers30_100.index;
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'mode': 'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.MATH.index,
                                  'moduleIndex': moduleIndex,
                                  'list': listNumber30t100,
                                }).then((_) {
                              // This block runs when you have returned back to the 1st Page from 2nd.
                              setState(() {
                                // Call setState to refresh the page.
                              });
                            });
                          },
                        );
                      } (),
                    ),  // test: words / number
                    Container(
                      child: () {
                        String _moduleTitle = "1-10 (ordinais)";
                        int moduleIndex = ModulePosYear2Mat.Numbers_Test_1_10_Ordinals.index;
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'mode': 'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.MATH.index,
                                  'moduleIndex': moduleIndex,
                                  'list': listNumber1t10Ordinal,
                                }).then((_) {
                              // This block runs when you have returned back to the 1st Page from 2nd.
                              setState(() {
                                // Call setState to refresh the page.
                              });
                            });
                          },
                        );
                      } (),
                    ),  // test: words / number
                    Container(
                      child: () {
                        String _moduleTitle = "20-100 (ordinais)";
                        int moduleIndex = ModulePosYear2Mat.Numbers_Test_20_100_Ordinals.index;
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _moduleTitle,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('REPORT') + ": " + _moduleTitle,
                                  'mode': 'report',
                                  'year': Year.TWO.index,
                                  'subject': Subject.MATH.index,
                                  'moduleIndex': moduleIndex,
                                  'list': listNumber20t100Ordinal,
                                }).then((_) {
                              // This block runs when you have returned back to the 1st Page from 2nd.
                              setState(() {
                                // Call setState to refresh the page.
                              });
                            });
                          },
                        );
                      } (),
                    ),  // test: words / number
                  ],
                ),
              ],
            )),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Icon getLessonIcon() {
    return Icon(
      IconData(59404, fontFamily: 'LiteraIcons'),
      color: Colors.blue.shade300,
    );
  }

  Icon getExerciseIcon() {
    return Icon(
      IconData(58740, fontFamily: 'LiteraIcons'),
      color: Colors.yellow.shade200,
    );
  }

  Icon getTestIcon() {
    return Icon(
      IconData(59485, fontFamily: 'LiteraIcons'),
      color: Colors.red.shade200,
    );
  }

  Icon getReportIcon() {
    return Icon(
      IconData(59484, fontFamily: 'LiteraIcons'),
      color: Colors.white,
    );
  }

}
