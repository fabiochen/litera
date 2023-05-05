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
  List<bool> isUnlockModulesYear = [];
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

  @override
  initState() {
    Globals().listYears.forEach((year) {
      isUnlockModulesYear.add(false);
    });
    super.initState();
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Globals().appBarColor,
        title: Text(Globals().getAssetsVocab('SETTINGS')),
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
                  Globals().getAssetsVocab('UNLOCKMODULES'),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              getYearTiles(),
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
                        value: Globals().percentUnlock,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            Globals().percentUnlock = newValue!;
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
                        Globals().percentUnlock = "80";
                      });
                    },
                  ),
                ),
              ),  // reset
              ListTile(
                trailing: ElevatedButton(
                    onPressed: () => saveSettings(),
                    child: Text(Globals().getAssetsVocab('SAVE'),
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

  Column getYearTiles() {
    List<ListTile> listListTiles = [];
    Globals().listYears.forEach((year) {
      ListTile listTile = ListTile(
        leading: Icon(
          null,
        ),
        title: Text(
          Globals().listYears[year.id.index].value + "º Ano",
          style: TextStyle(color: Colors.black),
        ),
        trailing: SizedBox(
          width: 50.0,
          height: 25.0,
          child: FlutterSwitch(
            width: 50.0,
            height: 25.0,
            toggleSize: 15.0,
            value: isUnlockModulesYear[year.id.index],
            borderRadius: 30.0,
            padding: 5.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                // unlock all
                lockAll();
                for (int j=0; j<=year.id.index; j++) {
                  isUnlockModulesYear[j] = true;
                  Globals().listYears[j].subjects.forEach((subject) {
                    setUnlockModule(subject.modules.length, j, subject.id.index);
                  });
                }
                if (!val) {
                  lockAll();
                  for (int j=0; j<year.id.index; j++) {
                    isUnlockModulesYear[j] = true;
                    Globals().listYears[j].subjects.forEach((subject) {
                      setUnlockModule(subject.modules.length, j, subject.id.index);
                    });
                  }
                  // only unlock year 1
                }
              });
            },
          ),
        ),
      );  // nº ano
      listListTiles.add(listTile);
    });
    Column col = Column(
      children: listListTiles,
    );
    return col;
  }

  void lockAll() {
    Globals().listYears.forEach((year) {
      isUnlockModulesYear[year.id.index] = false;
      year.subjects.forEach((subject) {
        setUnlockModule(0, year.id.index, subject.id.index);
      });
    });
  }

  void saveSettings() async {
    if (resetApp) {
      await clearSettings('reports');
      await clearSettings('unlockModuleIndex');
      Globals().prefs.setInt('expandedId',1);
    }
    Globals().prefs.setString('percentUnlock',Globals().percentUnlock);
    Phoenix.rebirth(context);
  }

  Future clearSettings(String section) async {
    for (int i=Globals().prefs.getKeys().length-1; i>=0; i--) {
      String key = Globals().prefs.getKeys().elementAt(i);
      if (key.startsWith(section + '-')) Globals().prefs.remove(key);
    }
  }

}
