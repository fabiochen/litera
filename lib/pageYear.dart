import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/module.dart';
import 'package:litera/year.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class PageYear extends BaseModule {

  final Year year;

  PageYear(this.year);

  @override
  _PageYearState createState() => _PageYearState();
}

class _PageYearState extends BaseModuleState<PageYear> {

  late Year _year;
  late int _yearIndex;

  @override
  void initState() {
    super.initState();
    backgroundColor = Colors.teal;
    useNavigation = false;
    useProgressBar = false;
    _year = this.widget.year;
    _yearIndex = _year.id.index;
    print("test 1 yearIndex $_yearIndex");
    title = "$appTitle: " + (_yearIndex+1).toString() +"º Ano";
    bannerAd.load();
  }

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
    print("test 1.5 yearIndex $_yearIndex");
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: expandedId[_yearIndex],
        children: _getListExpansionPanelRadio(),
      ),
    );
  }

  List <ExpansionPanelRadio> _getListExpansionPanelRadio() {
    List<ExpansionPanelRadio> listExpansionPanelRadio = [];
    _year.subjects.forEach((subject) {
      listExpansionPanelRadio.add(ExpansionPanelRadio(
        value: subject.id.index,
        headerBuilder: (BuildContext context, bool isExpanded) {
          if (isExpanded) {
            expandedId[_yearIndex] = subject.id.index;
            print("test 2 yearIndex $_yearIndex");
            prefs.setInt('expandedId-$_yearIndex',expandedId[_yearIndex]);
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
    int _moduleStatus = _modulePos.compareTo(getUnlockModuleIndex(_yearIndex,_subjectIndex));
    Icon iconModuleType = getIcon(_module.type);
    //print("$_yearIndex module: " + getUnlockModuleIndex(_yearIndex,_subjectIndex).toString());

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
        if (_moduleStatus < 0) _onTap(_context, _module);
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