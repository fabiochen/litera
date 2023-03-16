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
                  margin: EdgeInsets.all(0),
                  child: Text(''),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icon/icon.png"),
                        fit: BoxFit.fitWidth),
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
                    onTap: () => Share.share('*Litera Português*\n\nhttps://play.google.com/store/apps/details?id=net.unitasoft.litera.portuguese'),
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
                        String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('LETTERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': _title,
                                  'year': 1,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Portuguese.Letters_Test_LettersImage.index,
                                  'list': alphabet
                                });
                          },
                        );
                      } (),
                    ),  // letters 1
                    Container(
                      child: () {
                        String _title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('LETTERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportLetters2Onset',
                                arguments: <String, Object>{
                                  'title': _title,
                                  'mode': 'report',
                                  'year': 1,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Portuguese.Letters_Test_LettersOnset.index,
                                  'list': alphabetOnsetList
                                });
                          },
                        );
                      } (),
                    ),  // letters 2
                    Container(
                      child: () {
                        String _title = getAssetsVocab('MATCH-CASE');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              getAssetsVocab('MATCH-CASE')
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/reportMatchCase',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('LETTERS') + ": " + _title,
                                  'mode': 'report',
                                  'year': 1,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Portuguese.Letters_Test_MatchCase.index,
                                  'list': lettersMatchCase,
                                });
                          },
                        );
                      } (),
                    ),  // letters 3

                    Container(
                      child: () {
                        String _title = getAssetsVocab('SOUND')  + " / " + getAssetsVocab('SYLLABLES');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportSyllableSound2Text',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('SYLLABLES'),
                                  'mode': 'report',
                                  'year': 1,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Portuguese.Syllables_Test_SyllablesSound.index,
                                  'list': listSyllables
                                });
                          },
                        );
                      } (),
                    ),  // syllables 1

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
                        String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              _title
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportNumbers2Picture',
                                arguments: <String, Object>{
                                  'title': _title,
                                  'mode': 'report',
                                  'year': 1,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Math.Numbers_Test_NumbersPicture.index,
                                  'list': listNumber1t10
                                });
                          },
                        );
                      } (),
                    ),  // numbers 1
                    Container(
                      child: () {
                        String _title = getAssetsVocab('ORDER-NUMBERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              getAssetsVocab('ORDER-NUMBERS')
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/reportMatchCase',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('NUMBERS') + ": " + _title,
                                  'mode': 'report',
                                  'year': 1,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Math.Numbers_Test_OrderNumbers.index,
                                  'list': valOrderNumbers,
                                });
                          },
                        );
                      } (),
                    ),  // numbers 2

                  ],
                ),
                ExpansionTile(
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
                        String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('WORD') + ": " + _title,
                                  'mode':'report',
                                  'year': 2,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear2Portuguese.Words_Test_WordsPicture.index,
                                  'list': listVocab.where((word) => word.title.length <=5).toList()
                                });
                          },
                        );
                      } (),
                    ),  // words 1
                    Container(
                      child: () {
                        String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('WORD') + ": " + _title,
                                  'mode': 'report',
                                  'year': 2,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear2Portuguese.Words_Test_WordPictures.index,
                                  'list': alphabet
                                });
                          },
                        );
                      } (),
                    ),  // words 2
                    Container(
                      child: () {
                        String _title = getAssetsVocab('SPELLING') + ' 1';
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('WORDS') + ": " + _title,
                                  'mode': 'report',
                                  'year': 2,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear2Portuguese.Words_Test_Spelling1.index,
                                  'list': alphabet.where((word) => word.title.length <=6).toList()
                                });
                          },
                        );
                      } (),
                    ),  // words 3
                    Container(
                      child: () {
                        String _title = getAssetsVocab('SPELLING') + ' 2';
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                            _title,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/BaseReport',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('WORDS') + ": " + _title,
                                  'mode': 'report',
                                  'year': 2,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear2Portuguese.Words_Test_Spelling2.index,
                                  'list': alphabet
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
                        String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              _title
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/ReportNumbers2Picture',
                                arguments: <String, Object>{
                                  'title': _title,
                                  'mode': 'report',
                                  'year': 2,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Math.Numbers_Test_NumbersPicture.index,
                                  'list': listNumber1t10
                                });
                          },
                        );
                      } (),
                    ),  // numbers 1
                    Container(
                      child: () {
                        String _title = getAssetsVocab('ORDER-NUMBERS');
                        return ListTile(
                          leading: getReportIcon(),
                          title: Text(
                              getAssetsVocab('ORDER-NUMBERS')
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/reportMatchCase',
                                arguments: <String, Object>{
                                  'title': getAssetsVocab('NUMBERS') + ": " + _title,
                                  'mode': 'report',
                                  'year': 2,
                                  'subject': expandedId,  // whichever panel is expanded is the subject matter
                                  'moduleIndex': ModulesYear1Math.Numbers_Test_OrderNumbers.index,
                                  'list': valOrderNumbers,
                                });
                          },
                        );
                      } (),
                    ),  // numbers 2

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
