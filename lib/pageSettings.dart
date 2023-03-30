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

  bool resetApp = false;
  bool isUnlockModulesYear1 = false;
  bool isUnlockModulesYear2 = false;
  List<DropdownMenuItem<String>> listPercentUnlock = [
    DropdownMenuItem(
        value: "0",
        child: Text("0")),
    DropdownMenuItem(
        value: "20",
        child: Text("20")),
    DropdownMenuItem(
        value: "40",
        child: Text("40")),
    DropdownMenuItem(
        value: "60",
        child: Text("60")),
    DropdownMenuItem(
          value: "80",
      child: Text("80")),
    DropdownMenuItem(
        value: "100",
        child: Text("100")),
  ];

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
                trailing: SizedBox(
                  width: 50.0,
                  height: 25.0,
                  child: FlutterSwitch(
                    width: 50.0,
                    height: 25.0,
                    toggleSize: 15.0,
                    value: isUnlockModulesYear1,
                    borderRadius: 30.0,
                    padding: 5.0,
                    showOnOff: false,
                    onToggle: (val) {
                      setState(() {
                        // only unlock year 1
                        isUnlockModulesYear1 = true;
                        isUnlockModulesYear2 = false;
                        setUnlockModule(ModulePosYear1Por.values.length, Yr.ONE.index, Sub.PORTUGUESE.index);
                        setUnlockModule(ModulePosYear1Por.values.length, Yr.ONE.index, Sub.MATH.index);
                        setUnlockModule(0, Yr.TWO.index, Sub.PORTUGUESE.index);
                        setUnlockModule(0, Yr.TWO.index, Sub.MATH.index);
                        if (!val) {
                          // lock all
                          isUnlockModulesYear1 = false;
                          isUnlockModulesYear2 = false;
                          setUnlockModule(0, Yr.ONE.index, Sub.PORTUGUESE.index);
                          setUnlockModule(0, Yr.ONE.index, Sub.MATH.index);
                          setUnlockModule(0, Yr.TWO.index, Sub.PORTUGUESE.index);
                          setUnlockModule(0, Yr.TWO.index, Sub.MATH.index);
                        }
                      });
                    },
                  ),
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
                trailing: SizedBox(
                  width: 50.0,
                  height: 25.0,
                  child: FlutterSwitch(
                    width: 50.0,
                    height: 25.0,
                    toggleSize: 15.0,
                    value: isUnlockModulesYear2,
                    borderRadius: 30.0,
                    padding: 5.0,
                    showOnOff: false,
                    onToggle: (val) {
                      setState(() {
                        // unlock all
                        isUnlockModulesYear1 = true;
                        isUnlockModulesYear2 = true;
                        setUnlockModule(ModulePosYear1Por.values.length, Yr.ONE.index, Sub.PORTUGUESE.index);
                        setUnlockModule(ModulePosYear1Por.values.length, Yr.ONE.index, Sub.MATH.index);
                        setUnlockModule(ModulePosYear1Por.values.length, Yr.TWO.index, Sub.PORTUGUESE.index);
                        setUnlockModule(ModulePosYear1Por.values.length, Yr.TWO.index, Sub.MATH.index);
                        if (!val) {
                          // only unlock year 1
                          isUnlockModulesYear1 = true;
                          isUnlockModulesYear2 = false;
                          setUnlockModule(ModulePosYear1Por.values.length, Yr.ONE.index, Sub.PORTUGUESE.index);
                          setUnlockModule(ModulePosYear1Por.values.length, Yr.ONE.index, Sub.MATH.index);
                          setUnlockModule(0, Yr.TWO.index, Sub.PORTUGUESE.index);
                          setUnlockModule(0, Yr.TWO.index, Sub.MATH.index);
                        }
                      });
                    },
                  ),
                ),
              ),  // ano 2
              ListTile(
                leading: Icon(null),
                title: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 5,
                          child: Text(
                        "Acertos para desbloqueio de módulo",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      )),
                      Flexible(
                          child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        value: percentUnlock,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            percentUnlock = newValue!;
                          });
                        },
                        items: listPercentUnlock,
                      )),
                      Text(
                        "    %",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
              ),  // percent
              ListTile(
                leading: Icon(
                  IconData(58837, fontFamily: 'LiteraIcons'),
                  color: Colors.black,
                ),
                title: Text(
                  'Reset (inclue apagar relatórios)',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: SizedBox(
                  width: 50.0,
                  height: 25.0,
                  child: FlutterSwitch(
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
              ),  // reset
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
              ),  // save button
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
    prefs.setString('percentUnlock',percentUnlock);
    Phoenix.rebirth(context);
  }

  Future clearSettings(String section) async {
    for (int i=prefs.getKeys().length-1; i>=0; i--) {
      String key = prefs.getKeys().elementAt(i);
      if (key.startsWith(section + '-')) prefs.remove(key);
    }
  }

}
