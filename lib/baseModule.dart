import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:audioplayers/audioplayers.dart';

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

  List<Object> listProcess = [];
  List<Object> listOriginal = [];
  late int numberQuestions;
  late String title;
  ModuleType? type;
  int yearIndex = Yr.ONE.index;
  int subjectIndex = Sub.PORTUGUESE.index;
  int modulePos = 0;
  bool useNavigation = true;
  bool useProgressBar = true;
  String fontFamily = "Litera-Regular";
  bool loop = false;
  List<int>? misc;

  late Word wordMain;
  Color? backgroundColor = Colors.grey[200];

  late BannerAd bannerAd;
  final isBannerAdReady = ValueNotifier<bool>(false);

  // list sort criteria
  Comparator<Object> criteria = (a, b) => ((a as Word).id).compareTo((b as Word).id);

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
      Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
      printDebug("test1");
      title = args?['title']??title;
      printDebug("test2");
      type = args?['type'];
      printDebug("test3");
      yearIndex = args?['year'] ?? Yr.ONE.index;
      printDebug("test4");
      subjectIndex = args?['subject'] ?? Sub.PORTUGUESE.index;
      printDebug("test5");
      modulePos = args?['modulePos']??0;
      printDebug("test6: $modulePos");
      listProcess = args?['list']??[];
      listOriginal = args?['list']??[];
      printDebug("test7");
      numberQuestions = args?['numberQuestions']??listProcess.length.toInt();
      printDebug("test8");
      useNavigation = args?['useNavigation'] ?? true;
      printDebug("test9");
      useProgressBar = args?['useProgressBar'] ?? true;
      printDebug("test10");
      fontFamily = args?['fontFamily'] ?? "Litera-Regular";
      print("FontFamily $fontFamily");
      loop = args?['loop'] ?? false;
      misc = args?['misc'];

      listProcess.sort(criteria);

      if (listProcess.length <= 1) {
        useNavigation = false;
        useProgressBar = false;
      }
      printDebug("test11: " + getAssetsVocab('LESSON'));
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
        default:
          break;
      }
      printDebug("test12");
      setEndPoints();
    } catch (e) {
      printDebug("dcd error: " + e.toString());
      printDebug("dcd error modulePos: " + modulePos.toString());
    }
    getUnlockModuleIndex(yearIndex,subjectIndex);
    //audioPlayer = AudioPlayer();
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
          title: Text(title),
        ),
        drawer: () {
          Menu;
        } (),
        body: getBody()
    );
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
          mainAxisAlignment: (useNavigation)? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceAround,
          children: [
            if (useNavigation) getNavButtonPrevious(),
            if (type == ModuleType.TEST) showGrade(),// navigation previous
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

  Widget showGrade() {
    Text grade = Text (
      "Acertos: $correctCount/$numberQuestions (" + (correctCount/numberQuestions*100).toInt().toString() + "%)",
      style: TextStyle(
        color: Colors.redAccent,
        fontSize: 30,
      ),
    );
    return grade;
  }

  Widget getProgressBar() {
    // print("listPosition: $listPosition");
    // print("numberQuestions: $numberQuestions");
    double percent = (numberQuestions>0)?(listPosition+1) / numberQuestions:0;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        animation: true,
        animationDuration: 500,
        percent: percent,
        animateFromLastPercent: true,
        leading: Text((listPosition+1).toString() + '  ',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        trailing: Text(numberQuestions.toString() + '  ',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        progressColor: appBarColor,
        backgroundColor: backgroundColor,
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
    wordMain = listProcess[listPosition] as Word;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(wordMain.id), // image
        getMainText(wordMain,50), // words
      ],
    );
  }

  String getMainLabel(word) {
    return word.title;
  }

  Text getMainText(Word word, double fontSize, [String fontFamily = "Litera-Regular"]) {
    return Text(
      getMainLabel(word),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: Colors.teal,
      )
    );
  }

  ElevatedButton getTextTile(Word word, [double fontSize=50, Color color= Colors.teal]) {
    int id = word.id;
    return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 250,
                height: 200,
                alignment: Alignment.center,
                child: getText(word.value, fontSize, color),
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

  Text getText(String text, [double fontSize = 100, Color color = Colors.teal]) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  ElevatedButton getSoundTile(Word word) {
    return ElevatedButton(
        onPressed: () => audioPlay(word.id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Icon(
              IconData(57400, fontFamily: 'LiteraIcons'),
              color: Colors.blue,
              size: 100,
            ),
            Icon(
              IconData(57401, fontFamily: 'LiteraIcons'),
              color: Colors.white,
              size: 100,
            ), // second icon to "paint" previous transparent icon
          ],
        )
    );
  }

  ElevatedButton getOnsetTile(Word word) {
    printDebug('********** onset tile 1 word:' + word.title);
    printDebug('********** onset tile 2 word:' + alphabetOnsetList.length.toString());
    late Word onset;
    try {
      onset = alphabetOnsetList.singleWhere((element) => element.title == word.title.substring(0,1));
      printDebug('********** onset tile 3 word:' + onset.title);
    } catch (e) {
      printDebug('********** onset error:' + e.toString());
    }
    return ElevatedButton(
        onPressed: () => (word.id==8)?{}:audioPlay(onset.id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            Image(
                image: AssetImage('assets/images/voice-onset.png'),
                width: 100,
                gaplessPlayback: true,
                color: Colors.black.withOpacity((word.id==8)?0.5:1.0) // opacity on muted letter (h)
            ),
            Positioned(
              bottom: 10, right: 0,
              child: Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue.withOpacity((word.id==8)?0.5:1.0), // opacity on muted letter (h)
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

  ElevatedButton getImageTile(int id, [double imageSize=200]) {
    return ElevatedButton(
        onPressed: () => audioPlay(id),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
        ),
        child: Stack(
          children: [
            getImage(id,imageSize),
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

  Padding getImage(int id, double width) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Image(
        image: AssetImage('assets/images/$id.png'),
        width: width,
        gaplessPlayback: true,
      ),
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
    String correctKey = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-correct';
    //print("CorrectKey: $correctKey = " + flagCorrect.value.toString());
    int correctValue = (prefs.getInt(correctKey) ?? 0) + flagCorrect.value;
    await prefs.setInt(correctKey, correctValue);
    String wrongKey = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-wrong';
    //print("WrongKey: $wrongKey =" + flagWrong.value.toString());
    int wrongValue = (prefs.getInt(wrongKey) ?? 0) + flagWrong.value;
    await prefs.setInt(wrongKey, wrongValue);
    flagCorrect.value = 0;
    flagWrong.value = 0;
  }

  void next() {
    audioStop();
    printDebug("*********** next");
    if (isEndPosition) {
      modulePos++;
      printDebug("modulePos: $modulePos");
      printDebug("year: $yearIndex");
      printDebug("subject: $subjectIndex");
      // redo TEST if minimum grade not reached
      if (
        type == ModuleType.TEST &&
        correctCount/numberQuestions*100 >= int.parse(percentUnlock)  &&
        modulePos > getUnlockModuleIndex(yearIndex, subjectIndex)
      ) {
        setUnlockModule(modulePos);
      } else if (
        type != ModuleType.TEST &&
        modulePos > getUnlockModuleIndex(yearIndex, subjectIndex)
      ) {
        setUnlockModule(modulePos);
      }
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
    if (loop) {
      if (listPosition < 0) {
        listPosition = numberQuestions-1;
      }
    } else {
      if (listPosition <= 0) {
        isStartPosition = true;
      }
    }
    isEndPosition = false;
    if (loop) {
      if (listPosition > numberQuestions - 1) {
        print("in loop: $modulePos");
        setUnlockModule(modulePos+1);
        listPosition = 0;
      }
    } else {
      if (listPosition >= numberQuestions - 1) {
        isEndPosition = true;
      }
    }
    print("ListPosition: $listPosition");
    print("EndPoint: $isEndPosition");
    print("NumberOfQuestions: $numberQuestions");
  }

  showBeginningAlertDialog(BuildContext context) {
    printDebug('alert');
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text('\n' + getAssetsVocab('BEGINNING'),
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showEndAlertDialog(BuildContext context, [String grade='']) {
    printDebug('alert');
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // close popup
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(grade + '\n' + getAssetsVocab('END'),
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setUnlockModule (int newIndex, [int? _year, int? _subject]) async {

    this.yearIndex    = (_year    == null) ? this.yearIndex    : _year;
    this.subjectIndex = (_subject == null) ? this.subjectIndex : _subject;

    unlockModuleIndex['$yearIndex-$subjectIndex'] = newIndex;
    await setUnlockModuleIndex(newIndex, yearIndex, subjectIndex);
  }

  @override
  void dispose() {
    audioStop();
    super.dispose();
  }

  Word getWordById(int id) {
    return listOriginal.singleWhere((word) => (word as Word).id == id) as Word;
  }

}
