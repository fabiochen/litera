import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/module.dart';
import 'package:litera/year.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class PageYear extends BaseModule {

  Year year;

  PageYear(this.year);

  @override
  _PageYearState createState() => _PageYearState();
}

class _PageYearState extends BaseModuleState<PageYear> {

  late Year year;

  @override
  void initState() {
    super.initState();
    backgroundColor = Colors.teal;
    useNavigation = false;
    useProgressBar = false;
    year = this.widget.year;
    yearIndex = year.id.index;
    title = "$appTitle: " + (yearIndex+1).toString() +"º Ano";
    bannerAd.load();
  }

  @override
  PreferredSizeWidget getAppBar() {
    return AppBar(
      backgroundColor: appBarColor,
      title: Text(title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget getMainTile() {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: expandedId[yearIndex],
        children: _getListExpansionPanelRadio(),
      ),
    );
  }

  List <ExpansionPanelRadio> _getListExpansionPanelRadio() {
    List<ExpansionPanelRadio> listExpansionPanelRadio = [];
    year.subjects.forEach((subject) {
      listExpansionPanelRadio.add(ExpansionPanelRadio(
        value: subject.id.index,
        headerBuilder: (BuildContext context, bool isExpanded) {
          if (isExpanded) {
            expandedId[yearIndex] = subject.id.index;
            prefs.setInt('expandedId-$yearIndex',expandedId[yearIndex]);
          }
          return ListTile(
              title: Text(
                  subject.value,
                  textAlign: TextAlign.left,
                  style: getModuleStyle(false)
              )
          );},
        canTapOnHeader: true,
        backgroundColor: Colors.teal[400],
        body: Container(
          color: Colors.teal[300],
          child: Column(
            children: _getListListTiles(context, subject.modules),
          ),
        ),
      ));
    });
    return listExpansionPanelRadio;
  }
  
  List<ListTile> _getListListTiles(context, List<Module> listModules) {
    List<ListTile> listTemp = [];
    listModules.forEach((_module) { listTemp.add(_getListTile(context, _module));});
    return listTemp;
  }

  ListTile _getListTile(dynamic _context, Module _module) {
    String _moduleTitle = _module.title;
    var _modulePos = _module.pos;
    int _subjectIndex = _module.subject.index;
    int _moduleStatus = _modulePos.compareTo(getUnlockModuleIndex(yearIndex,_subjectIndex));

    Icon iconModuleType = getIcon(_module.type);

    return ListTile(
      leading: iconModuleType,
      title: (_moduleStatus > 0) ? Text(
        _moduleTitle,
        style: getModuleStyle(true),
      ): (_moduleStatus == 0) ? AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            _moduleTitle,
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
        _moduleTitle,
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