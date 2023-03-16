import 'package:flutter/material.dart';
import 'package:litera/menu.dart';
import 'package:litera/globals.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class PageAbout extends StatefulWidget {
  @override
  _PageAboutState createState() => _PageAboutState();
}

class _PageAboutState extends State<PageAbout> {

  bool isFirstTime = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(getAssetsVocab('ABOUT')),
      ),
      drawer: () {
        Menu();
      } (),
      body: FutureBuilder(
          future: getNavigationLanguage(),
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
              return Center(
                  child: Stack(
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blueGrey),
                                      borderRadius: BorderRadius.all(
                                          const Radius.circular(5.0)),
                                    ),
                                    child: Column(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/icon/icon.png'),
                                          width: 300,
                                          gaplessPlayback: true,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          appOralLanguage,
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.blueGrey
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 80),
                                  Text('v.' + version + '+' +
                                      buildNumber,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: Image(
                                  image: AssetImage('assets/icon/unitas.png'),
                                  width: 100,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                            Text('unitasoft.net',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isFirstTime,
                        child: Container(
                            color: Colors.teal[100].withOpacity(0.95),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Flexible(
                                  flex:1,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(10),
                                    child: Image(
                                      image: AssetImage('assets/icon/arrow.png'),
                                      width: 100,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => saveSettings(1),
                                        child: Text(
                                          'Français',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => saveSettings(0),
                                        child: Text(
                                          'English',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => saveSettings(2),
                                        child: Text(
                                          'Português',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      )
                    ],
                  )
              );
            } return Container();
          }
      ),
    );
  }

  void saveSettings(int val) async {
    prefs.setInt('settings-language', val);
    Phoenix.rebirth(context);
  }

  getNavigationLanguage() async {
    var temp = prefs.get("settings-language");

    if (temp != null) isFirstTime = false;
    print('isFirstTime: ' + isFirstTime.toString());
  }

}