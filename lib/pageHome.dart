import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:litera/globals.dart';
import 'package:litera/menu.dart';
import 'package:litera/pageYear.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState<T extends PageHome> extends State<T> {

  bool useNavigation = true;
  bool useProgressBar = true;
  Color? backgroundColor = Colors.grey[200];
  late BannerAd bannerAd;
  final isBannerAdReady = ValueNotifier<bool>(false);

  late String title;

  @override
  void initState() {
    super.initState();
    useNavigation = false;
    useProgressBar = false;
    title = "Litera Brasil";
    backgroundColor = Colors.teal;
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4740796354683139/8664737042', // ad mob litera portuguese: bottom
      //adUnitId: 'ca-app-pub-3940256099942544/6300978111', //test id
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          printDebug('******** banner loaded: ' + DateTime.now().toString());
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          printDebug('Failed to load a banner ad: ${err.message}');
          isBannerAdReady.value = false;
          ad.dispose();
        },
      ),
    );
    bannerAd.load();

  }

  @override
  Widget build(BuildContext context) {
    printDebug("******** baseModule build");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(title),
        ),
        drawer: Menu(),
        body: getBody()
    );
  }

  Widget getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: getMainTile()
        ),
        ValueListenableBuilder(
            valueListenable: isBannerAdReady,
            builder: (context, value, widget) {
              return getAd();
            }
        )
      ],
    );
  }

  Widget getAd() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: StatefulBuilder(
        builder: (context, setState) => Container(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        ),
      ),
    );
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
        bool unlockYear = true;
        List<bool> unlockSubjects = [];
        if (i>0) {
          // unlock year if all modules from previous years are unlocked, i.e., if saved unlock index is equal to length of module list
          listYears[i].subjects.forEach((subject) {
            if (listYears[i-1].subjects.length > subject.id.index)
              unlockSubjects.add(listYears[i-1].subjects[subject.id.index].modules.length > getUnlockModuleIndex(listYears[i-1].id.index, subject.id.index));
          });
        }
        unlockYear = listYears[i].id.index > 0 && !(unlockSubjects.where((item) => item == false).length>0);
        listContainers.add(Container(
          child: InkWell(
              onTap: () {
                if (!unlockYear) Navigator.push(
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
                    children: getYearIcon(i, unlockYear),
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