import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:litera/menu.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class BaseModule extends StatefulWidget {
  @override
  BaseModuleState createState() => BaseModuleState();
}

class BaseModuleState<T extends BaseModule> extends State<T> {

  int listPosition=0;

  // year #: [portuguese module index, math module index]
  Map<String,int> unlockModuleIndex = {'1-1':0,'1-2':0,'2-1':0,'2-2':0};

  bool isStartPosition = true;
  bool isEndPosition = true;

  final flagCorrect = ValueNotifier<int>(0);
  final flagWrong = ValueNotifier<int>(0);

  int correctCount = 0;
  int wrongCount = 0;

  bool kDebugMode = true;

  List<Object> listProcess;
  int numberQuestions;
  String title;
  String mode;
  int year = 1;
  int subject = 1; // 1 = portuguese, 2 = math
  int moduleIndex = 0;
  bool useNavigation = true;
  bool useProgressBar = true;

  Word wordMain;
  Color backgroundColor = Colors.grey[200];

  BannerAd bannerAd;
  final isBannerAdReady = ValueNotifier<bool>(false);

  void initState() {
    _initGoogleMobileAds();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        testDeviceIds: <String>[
          "AD77649C27A07629F1CBF3D6291B6C84",
          "5DA35B68B1037D249669C37E7087B993",
        ],
      ),
    );
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4740796354683139/8664737042', // ad mob litera portuguese: bottom
      //adUnitId: 'ca-app-pub-3940256099942544/6300978111', //test id
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('******** banner loaded: ' + DateTime.now().toString());
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady.value = false;
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
    super.initState();
  }

  Future<InitializationStatus> _initGoogleMobileAds() async {
    return MobileAds.instance.initialize();
  }

  void didChangeDependencies() {
    print("************* baseModule: didChangeDependencies");
    try {
      Map args = ModalRoute.of(context).settings.arguments;
      title = args['title'] ?? '';
      mode = args['mode'];
      year = args['year'];
      subject = args['subject'];
      moduleIndex = args['moduleIndex'];
      listProcess = args['list'];
      numberQuestions = args['numberQuestions']??listProcess.length.toInt();
      useNavigation = args['useNavigation'] ?? true;
      useProgressBar = args['useProgressBar'] ?? true;

      if (listProcess.length == 1) {
        useNavigation = false;
        useProgressBar = false;
      }
      if (mode == 'test')
        useNavigation = false;
      setEndPoints();
    } catch (e) {
      print("dcd error: " + e.toString());
      print("dcd error moduleIndex: " + moduleIndex.toString());
    }
    getUnlockModuleIndex(year,subject);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("******** baseModule build");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(title),
        ),
        drawer: getMenu(),
        body: getBody()
    );
  }

  Widget getMenu() {
    return () {
      audioStop();
      Menu();
    } ();
  }

  Widget getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (useProgressBar) getProgressBar(),
        Flexible(
            child: getMainTile()
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (useNavigation) getNavButtonPrevious(), // navigation previous
            if (useNavigation) getNavButtonNext(),// navigation next
          ],
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

  Widget getProgressBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        animation: false,
        animationDuration: 1000,
        percent: (listPosition+1) / numberQuestions,
        leading: Text((listPosition+1).toString() + '  ',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        trailing: Text('  ' + numberQuestions.toString(),
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        progressColor: appBarColor,
        backgroundColor: backgroundColor,
        linearStrokeCap: LinearStrokeCap.roundAll,
      ),
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

  Widget getMainTile() {
    wordMain = listProcess[listPosition];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(), // image
        getMainText(50), // words
      ],
    );
  }

  String getMainLabel() {
    return wordMain.title;
  }

  Text getMainText(double fontSize) {
    return Text(
      getMainLabel(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.teal,
      )
    );
  }

  ElevatedButton getImageTile() {
    return ElevatedButton(
        onPressed: () => audioPlay(wordMain.id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                image: AssetImage('assets/images/' + wordMain.id.toString() + '.png'),
                width: 200,
                gaplessPlayback: true,
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue,
                size: 40,
              ),
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57401, fontFamily: 'LiteraIcons'),
                color: Colors.white,
                size: 40,
              ),
            ), // second icon to "paint" previous transparent icon
          ],
        )
    );
  }

  InkWell getNavButtonPrevious() {
    return InkWell(
      onTap: () => previous(),
      child: Icon(
        IconData(58376, fontFamily: 'LiteraIcons'),
        color: Colors.blue,
        size: 80,
      ),
    );
  }

  InkWell getNavButtonNext() {
    return InkWell(
      onTap: () => next(),
      child: Icon(
        IconData(58377, fontFamily: 'LiteraIcons'),
        color: Colors.blue,
        size:80,
      ),
    );
  }

  void saveCorrectionValues () async {
    String correctKey = 'reports-$year-$subject-$moduleIndex-' + wordMain.id.toString() + '-correct';
    int correctValue = (prefs.getInt(correctKey) ?? 0) + flagCorrect.value;
    await prefs.setInt(correctKey, correctValue);
    String wrongKey = 'reports-$year-$subject-$moduleIndex-' + wordMain.id.toString() + '-wrong';
    int wrongValue = (prefs.getInt(wrongKey) ?? 0) + flagWrong.value;
    await prefs.setInt(wrongKey, wrongValue);
    flagCorrect.value = 0;
    flagWrong.value = 0;
  }

  void next() {
    audioStop();
    if (isEndPosition) {
      moduleIndex++;
      setUnlockModuleIndex(moduleIndex);
      // rebirth so lock icon is refreshed...
      // ideally would be to unlock from the previous page
      Navigator.of(context).pop();
    } else {
      listPosition++;
      setState(() {
        setEndPoints();
      });
    }
  }

  void previous() {
    audioStop();
    if (isStartPosition) {
      showBeginningAlertDialog(context);
    } else {
      listPosition--;
      setState(() {
        setEndPoints();
      });
    }
  }

  void setEndPoints() {
    isStartPosition = false;
    if (listPosition <= 0) {
      isStartPosition = true;
    }
    isEndPosition = false;
    if (listPosition >= numberQuestions - 1) {
      isEndPosition = true;
    }
  }

  setUnlockModuleIndex (int newIndex, [int year, int subject]) async {

    year    = (year    == null) ? this.year    : year;
    subject = (subject == null) ? this.subject : subject;

    print("year: $year");
    print("subject: $subject");

    unlockModuleIndex['$year-$subject'] = newIndex;
    await prefs.setInt('unlockModuleIndex-$year-$subject', newIndex);
  }

  int getUnlockModuleIndex (int _year, int _subject) {
    return prefs.getInt('unlockModuleIndex-$_year-$_subject')??0;
  }

}
