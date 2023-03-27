import 'package:flutter/material.dart';
import 'package:litera/globals.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/year.dart';
import 'package:litera/module.dart';

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
              children: getWidgets(),
            )),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  List<Widget> getWidgets() {
    List<Widget> listWidgets = [];

    listWidgets.add(DrawerHeader(
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
      ));
    listWidgets.add(Container(
        child: ListTile(
          leading: Icon(
            IconData(59403, fontFamily: 'LiteraIcons'),
            color: Colors.white,
          ),
          title: Text(
              getAssetsVocab('ABOUT')),
          onTap: () {
            Navigator.pushNamed(context, '/PageAbout');
          },
        ),
      ));
      // about
    listWidgets.add(Container(
        child: ListTile(
          leading: Icon(
            IconData(57574, fontFamily: 'LiteraIcons'),
            color: Colors.white,
          ),
          title: Text(
              getAssetsVocab('CONTACT')),
          onTap: () {
            Navigator.pushNamed(context, '/PageContact');
          },
        ),
      ));
      // contact
    listWidgets.add(Container(
        child: ListTile(
          leading: Icon(
            IconData(59405, fontFamily: 'LiteraIcons'),
            color: Colors.white,
          ),
          title: Text(
              getAssetsVocab('SHARE')),
          onTap: () => Share.share('*$appTitle*\n\nhttps://play.google.com/store/apps/details?id=net.unitasoft.litera.portuguese'),
        ),
      ));
      // share
    listWidgets.add(Container(
        child: ListTile(
          leading: Icon(
            IconData(59576, fontFamily: 'LiteraIcons'),
            color: Colors.white,
          ),
          title: Text(
              getAssetsVocab('SETTINGS')),
          onTap: () {
            Navigator.pushNamed(context, '/PageSettings');
          },
        ),
      ));
      // settings

    listYears.forEach((_year) {
      listWidgets.add(() {
        int _yearId = _year.id.index + 1;
        return ExpansionTile(
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          textColor: Colors.white,
          leading: getIcon(ModuleType.REPORT),
          title: Text("Relatório - $_yearIdº Ano"),
          children: getListModules(_year),
        );
      } ());
    });

    return listWidgets;
  }

  List<Widget> getListModules(Year _year) {
    List<Widget> listModulesNew = [];
    _year.subjects.forEach((_subject) {
      listModulesNew.add(Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20.0),
        child: Text(
            _subject.value,
            style: TextStyle(
                fontWeight: FontWeight. bold
            )
        ),
      ));
      listModulesNew.add(Divider(
        color: Colors.grey,
      ));
      List<Module> _listModules = _subject.modules;
      _listModules = _listModules.where((_module) => _module.type == ModuleType.TEST).toList();
      _listModules.forEach((_module) {
        listModulesNew.add(Container(
          child: () {
            return ListTile(
              leading: getIcon(ModuleType.REPORT),
              title: Text(_module.title),
              onTap: () {
                Navigator.pushNamed(context, '/BaseReport',
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
