import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/menu.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/pageYear1.dart';
import 'package:litera/pageYear2.dart';

class PageHome extends BaseModule {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends BaseModuleState<PageHome> {

  String title = appTitle;
  Color backgroundColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    useNavigation = false;
    useProgressBar = false;
    bannerAd.load();
  }

  Container getIcon(id) {
    return Container(
      child: ListTile(
        leading: Icon(
          IconData(id, fontFamily: 'LiteraIcons'),
          color: Colors.white,
        ),
        title: Text("$id"),
      ),
    );
  }
  
  @override
  Widget getMainTile() {
    // List<Container> icons = [];
    // for (int i=58700; i<59800; i++) {
    //   icons.add(getIcon(i));
    // }
    // return ListView(
    //   physics: const AlwaysScrollableScrollPhysics(),
    //   children: [
    //     Column (
    //       children: icons,
    //     )
    //   ],
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, animation1, animation2) => PageYear1(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 1000),
                      ),
                    ).then((_) {
                      // This block runs when you have returned back to the 1st Page from 2nd.
                      print("returned 1");
                      print("Last PT ModuleIndex: " + ModulePosYear1Por.values.length.toString());
                      print("Saved PT ModuleIndex: " + getUnlockModuleIndex(1, 1).toString());
                      print("Last MT ModuleIndex: " + ModulePosYear1Mat.values.length.toString());
                      print("Saved MT ModuleIndex: " + getUnlockModuleIndex(1, 2).toString());
                      setState(() {
                        // Call setState to refresh the page.
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.red.shade200,
                        size: 100,
                      ),
                      Text(
                        "1º Ano",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Mynerve'
                        ),
                      )
                    ],
                  )
              ),
            ),  // year 1
            SizedBox(
                width: 50,
                height: 50
            ),
            Container(
              child: InkWell(
                  onTap: () {
                    if (
                      ModulePosYear1Por.values.length <= getUnlockModuleIndex(Year.ONE.index, Subject.PORTUGUESE.index) &&
                      ModulePosYear1Mat.values.length <= getUnlockModuleIndex(Year.ONE.index, Subject.MATH.index)
                    )
                      Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, animation1, animation2) => PageYear2(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 1000),
                      ),
                    ).then((_) {
                      // This block runs when you have returned back to the 1st Page from 2nd.
                      print("returned 2");
                      setState(() {
                        // Call setState to refresh the page.
                        print("refresh 2");
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.yellow.shade200,
                            size: 100,
                          ),
                          if (
                            ModulePosYear1Por.values.length > getUnlockModuleIndex(Year.ONE.index, Subject.PORTUGUESE.index) ||
                            ModulePosYear1Mat.values.length > getUnlockModuleIndex(Year.ONE.index, Subject.MATH.index)
                          ) getLockIcon(true),
                        ],
                      ),
                      Text(
                        "2º Ano",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Mynerve'
                        ),
                      )
                    ],
                  )
              ),
            ),  // year 2
          ],
        ),
      ],
    );
  }

  Widget getMenu() {
    return Menu();
  }

  TextStyle getModuleStyle(unlock) {
    return TextStyle(
        fontSize: 20,
        color: unlock?Colors.white:Colors.grey[350]
    );
  }

  Icon getLessonIcon() {
    return Icon(
      IconData(59404, fontFamily: 'LiteraIcons'),
      color: Colors.blue.shade500,
    );
  }

  Icon getExerciseIcon() {
    return Icon(
      IconData(58740, fontFamily: 'LiteraIcons'),
      color: Colors.yellow.shade200,
    );
  }

  Icon getTestIcon() {
    return Icon(
      IconData(59485, fontFamily: 'LiteraIcons'),
      color: Colors.red.shade200,
    );
  }

  Icon getReportIcon() {
    return Icon(
      IconData(59484, fontFamily: 'LiteraIcons'),
      color: Colors.white,
    );
  }

}