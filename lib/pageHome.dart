import 'package:flutter/material.dart';

import 'package:litera/globals.dart';
import 'package:litera/menu.dart';
import 'package:litera/baseModule.dart';
import 'package:litera/pageYear.dart';

class PageHome extends BaseModule {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends BaseModuleState<PageHome> {

  @override
  void initState() {
    super.initState();
    useNavigation = false;
    useProgressBar = false;
    title = "Litera Brasil";
    backgroundColor = Colors.teal;
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getListYears()
        ),
      ],
    );
  }

  List<Widget> getListYears() {
    List<Widget> listContainers = [];
    listContainers.add(SizedBox(
        width: 50,
        height: 50
    ));
    for (int i=0; i<listYears.length; i++) {
      {
        bool unlockModule =
            listYears[i].id.index > 0 && (
            listYears[i-1].subjects[Sub.PORTUGUESE.index].modules.length > getUnlockModuleIndex(listYears[i-1].id.index, Sub.PORTUGUESE.index) ||
            listYears[i-1].subjects[Sub.MATH.index].modules.length > getUnlockModuleIndex(listYears[i-1].id.index, Sub.MATH.index));
        listContainers.add(Container(
          child: InkWell(
              onTap: () {
                if (!unlockModule) Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, animation1, animation2) => PageYear(listYears[i]),
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
                  setState(() {
                    // Call setState to refresh the page.
                  });
                });
              },
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: getYearIcon(i, unlockModule),
                  ),
                  Text(
                    listYears[i].value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Mynerve'
                    ),
                  )
                ],
              )
          ),
        ));
        listContainers.add(SizedBox(
            width: 50,
            height: 50
        ));
      }
    }
    return listContainers;
  }

  List<Widget> getYearIcon(i,unlockModule) {
    List<Widget> list = [];
      list.add(Icon(
        Icons.calendar_month,
        color: listYears[i].color,
        size: 100,
      ));
      if (unlockModule)list.add(getLockIcon(true) as Widget);
    return list;
  }

  @override
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