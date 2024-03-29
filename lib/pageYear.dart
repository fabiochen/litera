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
    useNavigation = false;
    useProgressBar = false;
    backgroundColor = Globals().appColorDark;
    _year = this.widget.year;
    _yearIndex = _year.id.index;
    Globals().printDebug("test 1 yearIndex $_yearIndex");
    title = Globals().appTitle + ": " + (_yearIndex+1).toString() +"º Ano";
    bannerAd.load();
  }

  @override
  Widget getMainTile() {
    Globals().printDebug("test 1.5 yearIndex $_yearIndex");
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        initialOpenPanelValue: (!Globals().firstTime) ? Globals().prefs.getInt('expandedId-$_yearIndex') : null,
        expandIconColor: Colors.white,
        dividerColor: Colors.white,
        children: _getListExpansionPanelRadio(),
      ),
    );
  }

  List <ExpansionPanelRadio> _getListExpansionPanelRadio() {
    Globals().printDebug("test 1.6");
    List<ExpansionPanelRadio> listExpansionPanelRadio = [];
    _year.subjects.forEach((subject) {
      listExpansionPanelRadio.add(ExpansionPanelRadio(
        value: subject.id.index,
        headerBuilder: (BuildContext context, bool isExpanded) {
          if (isExpanded) {
            Globals().expandedId[_yearIndex] = subject.id.index;
            Globals().printDebug("test 2 yearIndex $_yearIndex subject ${subject.id.index}");
            Globals().prefs.setInt('expandedId-$_yearIndex',subject.id.index);
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: subject.image,
                title: Text(
                    subject.value,
                    textAlign: TextAlign.left,
                    style: Globals().getModuleStyle(false)
                )
            ),
          );},
        canTapOnHeader: true,
        backgroundColor: Globals().appColorDark,
        body: Container(
          color: Globals().appColor,
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
    int _moduleStatus = _modulePos.compareTo(Globals().getUnlockModuleIndex(_yearIndex,_subjectIndex));
    Icon iconModuleType = Globals().getIcon(_module.type);
    //Globals().printDebug("$_yearIndex module: " + getUnlockModuleIndex(_yearIndex,_subjectIndex).toString());

    return ListTile(
      leading: iconModuleType,
      title: (_moduleStatus > 0) ? Text(
        _moduleTitle,
        style: Globals().getModuleStyle(true),
      ): (_moduleStatus == 0) ? AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            _moduleTitle,
            textStyle: TextStyle(
              fontSize: 20.0,
              color: Globals().appFontColorLight,
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
        style: Globals().getModuleStyle(false),
      ),
      trailing: Globals().getLockIcon(_moduleStatus > 0),
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