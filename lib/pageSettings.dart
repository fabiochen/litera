import 'package:flutter/material.dart';
import 'package:litera/menu.dart';
import 'package:litera/globals.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:litera/baseModule.dart';

class PageSettings extends BaseModule {
  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends BaseModuleState<PageSettings> {

  int dropdownKey = navigationLanguage;
  bool resetApp = false;
  bool isUnlockModulesYear1 = false;
  bool isUnlockModulesYear2 = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(getAssetsVocab('SETTINGS')),
      ),
      drawer: () {
        Menu();
      } (),
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  IconData(59544, fontFamily: 'LiteraIcons'),
                  color: Colors.black,
                ),
                title: Text(
                  getAssetsVocab('UNLOCKMODULES'),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                leading: Icon(
                  null,
                ),
                title: Text(
                  "1º Ano",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: FlutterSwitch(
                  width: 50.0,
                  height: 25.0,
                  toggleSize: 15.0,
                  value: isUnlockModulesYear1,
                  borderRadius: 30.0,
                  padding: 5.0,
                  showOnOff: false,
                  onToggle: (val) {
                    setState(() {
                      isUnlockModulesYear1 = true;
                      isUnlockModulesYear2 = false;
                      setUnlockModuleIndex(ModulesYear1Portuguese.values.length, 1, 1);
                      setUnlockModuleIndex(ModulesYear1Portuguese.values.length, 1, 2);
                      setUnlockModuleIndex(0, 2, 1);
                      setUnlockModuleIndex(0, 2, 2);
                      if (!val) {
                        isUnlockModulesYear1 = false;
                        isUnlockModulesYear2 = false;
                        setUnlockModuleIndex(0, 1, 1);
                        setUnlockModuleIndex(0, 1, 2);
                        setUnlockModuleIndex(0, 2, 1);
                        setUnlockModuleIndex(0, 2, 2);
                      }
                    });
                  },
                ),
              ),  // ano 1
              ListTile(
                leading: Icon(
                  null,
                ),
                title: Text(
                  "2º Ano",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: FlutterSwitch(
                  width: 50.0,
                  height: 25.0,
                  toggleSize: 15.0,
                  value: isUnlockModulesYear2,
                  borderRadius: 30.0,
                  padding: 5.0,
                  showOnOff: false,
                  onToggle: (val) {
                    setState(() {
                      isUnlockModulesYear1 = true;
                      isUnlockModulesYear2 = true;
                      setUnlockModuleIndex(ModulesYear1Portuguese.values.length, 1, 1);
                      setUnlockModuleIndex(ModulesYear1Math.values.length, 1, 2);
                      setUnlockModuleIndex(ModulesYear2Portuguese.values.length, 2, 1);
                      setUnlockModuleIndex(ModulesYear2Math.values.length, 2, 2);
                      if (!val) {
                        isUnlockModulesYear1 = true;
                        isUnlockModulesYear2 = false;
                        setUnlockModuleIndex(ModulesYear1Portuguese.values.length, 1, 1);
                        setUnlockModuleIndex(ModulesYear1Math.values.length, 1, 2);
                        setUnlockModuleIndex(0, 2, 1);
                        setUnlockModuleIndex(0, 2, 2);
                      }
                    });
                  },
                ),
              ),  // ano 2
              ListTile(
                leading: Icon(
                  IconData(58837, fontFamily: 'LiteraIcons'),
                  color: Colors.black,
                ),
                title: Text(
                  'Reset (inclue apagar relatórios)',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: FlutterSwitch(
                  width: 50.0,
                  height: 25.0,
                  toggleSize: 15.0,
                  value: resetApp,
                  borderRadius: 30.0,
                  padding: 5.0,
                  showOnOff: false,
                  onToggle: (val) {
                    setState(() {
                      resetApp = val;
                    });
                  },
                ),
              ),
              ListTile(
                trailing: ElevatedButton(
                    onPressed: () => saveSettings(),
                    child: Text(getAssetsVocab('SAVE'),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.teal)
                            )
                        )
                    )
                ),
              ), // save button
            ],
          ),
        ),
      ),
    );
  }

  void saveSettings() async {
    if (resetApp) {
      await clearSettings('reports');
      await clearSettings('unlockModuleIndex');
      prefs.setInt('expandedId',1);
    }
    Phoenix.rebirth(context);
  }

  Future clearSettings(String section) async {
    for (int i=prefs.getKeys().length-1; i>=0; i--) {
      String key = prefs.getKeys().elementAt(i);
      if (key.startsWith(section + '-')) prefs.remove(key);
    }
  }

}
