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

  ListTile _getListTile(dynamic _context, Module _module) {
    String title = _module.title;
    var _modulePos = _module.id;
    int subjectIndex = _module.subject.index;
    int _moduleStatus = _modulePos.index.compareTo(getUnlockModuleIndex(year,subjectIndex));

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
          _onTap(_context, _module);
        },
      ) : Text(
        title,
        style: getModuleStyle(false),
      ),
      trailing: getLockIcon(_moduleStatus > 0),
      onTap: () {
        _onTap(_context, _module);
      }
    );
  }

  _onTap(dynamic _context, Module _module) {

    Navigator.pushNamed(_context, _module.routeName,
        arguments: _module.arguments
    ).then((_) {
      // This block runs when you have returned back to the 1st Page from 2nd.
      setState(() {
        // Call setState to refresh the page.
      });
    });

  }

}