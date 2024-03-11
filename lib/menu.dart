import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/year.dart';
import 'package:litera/module.dart';

import 'package:share/share.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState<T extends Menu> extends State<T> {

  @override
  Widget build(BuildContext context) {
    Globals().printDebug("************* menu: build");
    return Drawer(
      backgroundColor: Globals().appColor,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Globals().appFontColorLight,
        ),
        child: ListView(
          children: getWidgets(),
        ),
      )
    );
  }

  List<Widget> getWidgets() {
    List<Widget> listWidgets = [];
    listWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Divider(),
          Container(
            alignment: Alignment.center,
            child: Text(
              Globals().appTitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 20
              ),
            ),
          ),
          Divider()
        ],
      ),
    ));
    listWidgets.add(Container(
        child: ListTile(
          textColor: Globals().appFontColorLight,
          leading: Icon(
            IconData(59403, fontFamily: 'LiteraIcons'),
            color: Globals().appFontColorLight,
          ),
          title: Text(
            Globals().getAssetsVocab('ABOUT'),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/PageAbout');
          },
        ),
      ));
      // about
    listWidgets.add(Container(
        child: ListTile(
          textColor: Globals().appFontColorLight,
          leading: Icon(
            IconData(57574, fontFamily: 'LiteraIcons'),
            color: Globals().appFontColorLight,
          ),
          title: Text(
              Globals().getAssetsVocab('CONTACT')),
          onTap: () {
            Navigator.pushNamed(context, '/PageContact');
          },
        ),
      ));
      // contact
    listWidgets.add(Container(
        child: ListTile(
          textColor: Globals().appFontColorLight,
          leading: Icon(
            IconData(59405, fontFamily: 'LiteraIcons'),
            color: Globals().appFontColorLight,
          ),
          title: Text(
              Globals().getAssetsVocab('SHARE')),
          onTap: () => Share.share('*${Globals().appTitle}*\n\nhttps://play.google.com/store/apps/details?id=net.unitasoft.litera.portuguese'),
        ),
      ));
      // share
    listWidgets.add(Container(
        child: ListTile(
          textColor: Globals().appFontColorLight,
          leading: Icon(
            IconData(59576, fontFamily: 'LiteraIcons'),
            color: Globals().appFontColorLight,
          ),
          title: Text(
              Globals().getAssetsVocab('SETTINGS')),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/PageSettings');
          },
        ),
      ));
      // settings

    Globals().listYears.forEach((_year) {
      listWidgets.add(() {
        int _yearId = _year.id.index + 1;
        return ExpansionTile(
          collapsedIconColor: Globals().appFontColorLight,
          iconColor: Globals().appFontColorLight,
          textColor: Globals().appFontColorLight,
          leading: Globals().getIcon(ModuleType.REPORT),
          title: Text("Relatório - $_yearIdº Ano"),
          collapsedTextColor: Globals().appFontColorLight,
          children: getListModules(_year),
        );
      } ());
    });

    return listWidgets;
  }

  List<Widget> getListModules(Year _year) {
    List<Widget> listModulesNew = [];
    _year.subjects.forEach((_subject) {
      listModulesNew.add(Divider(
        color: Globals().appFontColorLight,
      ));
      listModulesNew.add(Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20.0),
        child: Text(
          _subject.value,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      listModulesNew.add(Divider(
        color: Globals().appFontColorLight,
      ));
      List<Module> _listModules = _subject.modules;
      _listModules = _listModules.where((_module) => _module.type == ModuleType.TEST).toList();
      _listModules.forEach((_module) {
        listModulesNew.add(Container(
          child: () {
            return ListTile(
              leading: Globals().getIcon(ModuleType.REPORT),
              textColor: Globals().appFontColorLight,
              title: Text(_module.title,
                  overflow: TextOverflow.ellipsis
              ),
              onTap: () {
                Navigator.pushNamed(context, '/Report',
                    arguments: _module.arguments);
              },
            );
          } (),
        ));
      });
    });
    return listModulesNew;
  }
  
}
