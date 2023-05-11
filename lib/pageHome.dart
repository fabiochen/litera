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
          //Globals().printDebug('******** banner loaded: ' + DateTime.now().toString());
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          Globals().printDebug('Failed to load a banner ad: ${err.message}');
          isBannerAdReady.value = false;
          ad.dispose();
        },
      ),
    );
    bannerAd.load();

  }

  @override
  Widget build(BuildContext context) {
    Globals().printDebug("******** baseModule build");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Globals().appBarColor,
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
        SizedBox(width: 50, height: 50),
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
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: getListYears(),
    );
  }

  List<Widget> getListYears() {
    List<Widget> listContainers = [];
    print("number of years: " + Globals().listYears.length.toString());
    for (int i=0; i<Globals().listYears.length; i++) {
      {
        bool lockYear = true;
        List<bool> unlockSubjects = [];
        // since modules for year 1 (i.e. i=0) are all unlocked, start checking unlocked modules after year 1 (i.e. i>0);
        if (i==0) lockYear = false;
        if (i>0) {
          // unlock year if all modules from previous years are unlocked, i.e., if saved unlock index is equal to length of module list
          //print("$i: " + listYears[i].subjects.length.toString() + " subjects");
          for (int s=0; s<Globals().listYears[i-1].subjects.length; s++) {
            int totalSubjectModules = Globals().listYears[i-1].subjects[s].modules.length;
            int lastSubjectUnlockedModule = Globals().getUnlockModuleIndex(Globals().listYears[i-1].id.index, Globals().listYears[i-1].subjects[s].id.index);
            print("totalSubjectModules: $totalSubjectModules lastSubjectUnlockedModule: $lastSubjectUnlockedModule");
            if (lastSubjectUnlockedModule >= totalSubjectModules) unlockSubjects.add(true);
          }
          print("unlockSubjects ******************");
          Globals().printList(unlockSubjects);
          int unlockedSubjectCount = unlockSubjects.where((item) => item == true).length;
          int subjectCount = Globals().listYears[i-1].subjects.length;
          bool unlockedSubjects = unlockedSubjectCount == subjectCount;
          lockYear = i>0 && !unlockedSubjects;
          print("number of subject: $subjectCount");
          print("number of unlocked subjects: $unlockedSubjectCount");
          print("all subjects unlocked: $unlockedSubjects");
          print("lock year: $i $lockYear");
        }
        listContainers.add(Container(
          child: InkWell(
              onTap: () {
                if (!lockYear) Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, animation1, animation2) => PageYear(Globals().listYears[i]),
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
                    children: getYearIcon(i, lockYear),
                  ),
                  Text(
                    Globals().listYears[i].value,
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
      }
    }
    return listContainers;
  }

  List<Widget> getListIcons() {
    List<Widget> listContainers = [];
    for (int i=59500; i<60000; i++) {
      {
        listContainers.add(Container(
          child: Column(

            children: [
              Text("$i"),
              Icon(
                IconData(i, fontFamily: 'LiteraIcons'),
                color: Colors.white,
              ),
            ],
          ),
        ));
      }
    }
    return listContainers;
  }

  List<Widget> getYearIcon(i,unlockModule) {
    List<Widget> list = [];
      list.add(Icon(
        Icons.calendar_month,
        color: Globals().listYears[i].color,
        size: 100,
      ));
      if (unlockModule)list.add(Globals().getLockIcon(true) as Widget);
    return list;
  }

  TextStyle getModuleStyle(unlock) {
    return TextStyle(
        fontSize: 20,
        color: unlock?Colors.white:Colors.grey[350]
    );
  }

}