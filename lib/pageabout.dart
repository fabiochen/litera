import 'package:flutter/material.dart';
import 'package:litera/menu.dart';
import 'package:litera/globals.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: Globals().appBarColor,
        title: Text(Globals().getAssetsVocab('ABOUT')),
      ),
      drawer: () {
        Menu();
      } (),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
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
                        Globals().appTitle.toUpperCase(),
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.blueGrey
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
                Text("Illustrations by FreePik, brgfx and others",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 20),
                Text('v.' + Globals().version + '+' +
                    Globals().buildNumber,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                ),
              ],
            ),
          ),
          InkWell(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Image(
                      image: AssetImage('assets/icon/unitas.png'),
                      width: 100,
                      gaplessPlayback: true,
                    ),
                  ),
                  Text('unitasoft.net',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
              onTap: () {
                launchUrl(Uri(
                    scheme: 'https',
                    host: 'unitasoft.net',
                    path: '/'
                ));
              }
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  void saveSettings(int val) async {
    Globals().prefs.setInt('settings-language', val);
    Phoenix.rebirth(context);
  }

  getNavigationLanguage() async {
    var temp = Globals().prefs.get("settings-language");

    if (temp != null) isFirstTime = false;
    print('isFirstTime: ' + isFirstTime.toString());
  }

}