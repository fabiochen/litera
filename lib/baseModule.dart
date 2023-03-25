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
  Map<String,int> unlockModuleIndex = {'0-0':0,'0-1':0,'1-0':0,'1-1':0};

  bool isStartPosition = true;
  bool isEndPosition = true;

  final flagCorrect = ValueNotifier<int>(0);
  final flagWrong = ValueNotifier<int>(0);

  int correctCount = 0;
  int wrongCount = 0;

  List<Object> listProcess;
  int numberQuestions;
  String title = '';
  ModuleType type = ModuleType.LESSON;
  int yearIndex = Yr.ONE.index;
  int subject = Sub.PORTUGUESE.index;
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
    super.initState();
  }

  Future<InitializationStatus> _initGoogleMobileAds() async {
    return MobileAds.instance.initialize();
  }

  void didChangeDependencies() {
    printDebug("************* baseModule: didChangeDependencies");
    try {
      Map args = ModalRoute.of(context).settings.arguments;
      printDebug("test1");
      title = args['title'] ?? '';
      printDebug("test2");
      type = args['type']??ModuleType.LESSON;
      printDebug("test3");
      yearIndex = args['year'] ?? Yr.ONE.index;
      printDebug("test4");
      subject = args['subject'] ?? Sub.PORTUGUESE.index;
      printDebug("test5");
      moduleIndex = args['moduleIndex']??0;
      printDebug("test6");
      listProcess = args['list'];
      printDebug("test7");
      numberQuestions = args['numberQuestions']??listProcess.length.toInt();
      printDebug("test8");
      useNavigation = args['useNavigation'] ?? true;
      printDebug("test9");
      useProgressBar = args['useProgressBar'] ?? true;
      printDebug("test10");

      if (listProcess.length == 1) {
        useNavigation = false;
        useProgressBar = false;
      }
      switch (type) {
        case ModuleType.LESSON:
          title = getAssetsVocab('LESSON') + ": $title";
          break;
        case ModuleType.EXERCISE:
          title = getAssetsVocab('EXERCISE') + ": $title";
          break;
        case ModuleType.TEST:
          title = getAssetsVocab('TEST') + ": $title";
          useNavigation = false;
          break;
        case ModuleType.REPORT:
          title = getAssetsVocab('REPORT') + ": $title";
          break;
      }
      setEndPoints();
    } catch (e) {
      printDebug("dcd error: " + e.toString());
      printDebug("dcd error moduleIndex: " + moduleIndex.toString());
    }
    getUnlockModuleIndex(yearIndex,subject);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    printDebug("******** baseModule build");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(title??''),
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
    print("listPosition: $listPosition");
    print("numberQuestions: $numberQuestions");
    double percent = (listPosition+1) / numberQuestions;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        animation: false,
        animationDuration: 1000,
        percent: percent,
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
    String correctKey = 'reports-$yearIndex-$subject-$moduleIndex-' + wordMain.id.toString() + '-correct';
    print("CorrectKey: $correctKey = " + flagCorrect.value.toString());
    int correctValue = (prefs.getInt(correctKey) ?? 0) + flagCorrect.value;
    await prefs.setInt(correctKey, correctValue);
    String wrongKey = 'reports-$yearIndex-$subject-$moduleIndex-' + wordMain.id.toString() + '-wrong';
    print("WrongKey: $wrongKey =" + flagWrong.value.toString());
    int wrongValue = (prefs.getInt(wrongKey) ?? 0) + flagWrong.value;
    await prefs.setInt(wrongKey, wrongValue);
    flagCorrect.value = 0;
    flagWrong.value = 0;
  }

  void next() {
    audioStop();
    if (isEndPosition) {
      moduleIndex++;
      printDebug("*********** next");
      printDebug("moduleIndex: $moduleIndex");
      printDebug("year: $yearIndex");
      printDebug("subject: $subject");
      if (moduleIndex > getUnlockModuleIndex(yearIndex, subject))
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

  setUnlockModuleIndex (int newIndex, [int _year, int _subject]) async {

    this.yearIndex    = (_year    == null) ? this.yearIndex    : _year;
    this.subject = (_subject == null) ? this.subject : _subject;

    unlockModuleIndex['$yearIndex-$subject'] = newIndex;
    await prefs.setInt('unlockModuleIndex-$yearIndex-$subject', newIndex);
  }

  int getUnlockModuleIndex (int _year, int _subject) {
    return prefs.getInt('unlockModuleIndex-$_year-$_subject')??0;
  }

}
