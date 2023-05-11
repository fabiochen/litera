import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'menu.dart';
import 'word.dart';
import 'globals.dart';

class BaseModule extends StatefulWidget {
  @override
  BaseModuleState createState() => BaseModuleState();
}

class BaseModuleState<T extends BaseModule> extends State<T> {

  int listPosition=0;

  // year #: [portuguese module index, math module index]
  Map<String,int> unlockModuleIndex = {'0-0':0,'0-1':0,'1-0':0,'1-1':0, '1-2':0};

  bool isStartPosition = true;
  bool isEndPosition = true;

  final flagCorrect = ValueNotifier<int>(0);
  final flagWrong = ValueNotifier<int>(0);

  int correctCount = 0;
  int wrongCount = 0;

  late List<Object> listProcess;
  Set<Word> setProcessed = Set();
  late List<Object> listOriginal;
  late List<Object> listProcess2;
  int numberQuestions = 10;
  String title = '';
  ModuleType? type;
  int yearIndex = Yr.ONE.index;
  int subjectIndex = Sub.PORTUGUESE.index;
  int modulePos = 0;
  bool useNavigation = true;
  bool useProgressBar = true;
  String fontFamily = "Litera-Regular";

  late double fontSizeMain = 30;
  late double fontSizeOption = 30;
  late double widthMain = 250;
  late double heightMain = 150;
  late double widthOption = 200;
  late double heightOption = 150;
  late Color colorMain = Colors.teal;
  late Color colorOption = Colors.teal;
  late Object? fieldTypeMain = FieldType.TITLE;
  late Object? fieldTypeOption = FieldType.VAL1;
  late Object? sortCriteria = FieldType.ID;

  bool loop = false;
  bool containsAudio = true;
  bool noLock = false;
  Color buttonColor = Colors.grey;

  late Word wordMain;
  Color? backgroundColor = Colors.grey[200];

  late BannerAd bannerAd;
  final isBannerAdReady = ValueNotifier<bool>(false);

  // list sort criteria
  Comparator<Object> criteria = (a, b) => ((a as Word).id).compareTo((b as Word).id);

  void initState() {
    Globals().printDebug("************* baseModule: initState");
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
    super.initState();
  }

  Future<InitializationStatus> _initGoogleMobileAds() async {
    return MobileAds.instance.initialize();
  }

  void didChangeDependencies() {
    Globals().printDebug("************* baseModule: didChangeDependencies");
    try {
      Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
      Globals().printDebug("test1");
      title = args?['title']??title;
      Globals().printDebug("test2");
      type = args?['type'];
      Globals().printDebug("test3");
      yearIndex = args?['year'] ?? Yr.ONE.index;
      Globals().printDebug("test4");
      subjectIndex = args?['subject'] ?? Sub.PORTUGUESE.index;
      Globals().printDebug("test5");
      modulePos = args?['modulePos']??0;
      Globals().printDebug("test6: $modulePos");

      listProcess = args?['list1']??[];
      // reset
      if (listProcess is List<Word>) listProcess.forEach((word) {(word as Word).processed = false;});
      if (listProcess is List<Map<String, List<Word>>>) listProcess as List<Map<String, List<Word>>>;
      Globals().printDebug("test6.1: $modulePos");
      listOriginal = args?['list1']??[];
      Globals().printDebug("test6.2: $modulePos");
      listProcess2 = args?['list2']??[];
      // reset
      //if (listProcess2 is List<Word>) listProcess2.forEach((word) {(word as Word).processed = false;});
      //if (listProcess2 is List<Map<String, List<Word>>>) listProcess2.forEach((word) {(word as Word).processed = false;});

      Globals().printDebug("test7");
      numberQuestions = args?['numberQuestions']??numberQuestions;
      if (listProcess.length < numberQuestions) numberQuestions = listProcess.length;
      Globals().printDebug("test8");
      useNavigation = args?['useNavigation'] ?? true;
      Globals().printDebug("test9");
      useProgressBar = args?['useProgressBar'] ?? true;
      Globals().printDebug("test10");
      fontFamily = args?['fontFamily'] ?? fontFamily;
      Globals().printDebug("test10.1");
      fontSizeMain = args?['fontSizeMain'] ?? fontSizeMain;
      Globals().printDebug("test10.2");
      fontSizeOption = args?['fontSizeOption'] ?? fontSizeOption;
      widthMain = args?['widthMain'] ?? widthMain;
      heightMain = args?['heightMain'] ?? heightMain;
      widthOption = args?['widthOption'] ?? widthOption;
      heightOption = args?['heightOption'] ?? heightOption;
      colorMain   = args?['colorMain'] ?? colorMain;
      colorOption = args?['colorOption'] ?? colorOption;
      fieldTypeMain = args?['fieldTypeMain'] ?? fieldTypeMain;
      fieldTypeOption = args?['fieldTypeOption'] ?? fieldTypeOption;
      sortCriteria = args?['sortCriteria'] ?? sortCriteria;
      Globals().printDebug("test10.1");

      loop = args?['loop'] ?? loop;
      Globals().printDebug("test10.2");
      containsAudio = args?['containsAudio'] ?? containsAudio;
      noLock = args?['noLock'] ?? false;

      if (noLock) unlockNextModule();

      if (listProcess is List<Word>) {
        switch (sortCriteria) {
          case FieldType.ID:
            print("sort criteria: $sortCriteria");
            criteria = (a, b) => (a as Word).id.compareTo((b as Word).id);
            break;
          case FieldType.TITLE:
            print("sort criteria: $sortCriteria");
            criteria = (a, b) => (a as Word).title.compareTo((b as Word).title);
            break;
          default:
            criteria = (a, b) => (a as Word).id.compareTo((b as Word).id);
            break;
        }
        listProcess.sort(criteria);
      }

      Globals().printDebug("test11: " + Globals().getAssetsVocab('LESSON'));
      switch (type) {
        case ModuleType.LESSON:
          title = Globals().getAssetsVocab('LESSON') + ": $title";
          break;
        case ModuleType.EXERCISE:
          title = Globals().getAssetsVocab('EXERCISE') + ": $title";
          break;
        case ModuleType.TEST:
          title = Globals().getAssetsVocab('TEST') + ": $title";
          useNavigation = false;
          break;
        case ModuleType.REPORT:
          title = Globals().getAssetsVocab('REPORT') + ": $title";
          break;
        default:
          break;
      }
      Globals().printDebug("test12");
      setEndPoints();
    } catch (e) {
      Globals().printDebug("dcd error: " + e.toString());
      Globals().printDebug("dcd error modulePos: $title");
    }
    Globals().getUnlockModuleIndex(yearIndex,subjectIndex);

    super.didChangeDependencies();
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
        drawer: () {
          Menu;
        } (),
        body: getBody()
    );
  }

  Widget getBody() {
    print("baseModule: getBody");
    if (listProcess.length <= 1) {
      useNavigation = false;
      useProgressBar = false;
    }
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
        progressColor: Globals().appBarColor,
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
    print("listProcess count: $listProcess");
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(wordMain.id), // image
        getMainText(wordMain,fontSizeMain), // words
      ],
    );
  }

  String getMainLabel(String text) {
    return text;
  }

  Text getMainText(Word word, double fontSize, [String fontFamily = "Litera-Regular"]) {
    String label;
    switch (fieldTypeMain as dynamic) {
      case FieldType.VAL1:
        label = word.val1;
        break;
      default:
        label = word.title;
        break;
    }
    return Text(
      getMainLabel(label),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: Colors.teal,
      )
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color color= Colors.teal, double width=250, double height=200}) {
    int id = word.id;
    String text = word.title;
    if (containsAudio) {
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
                  width: width,
                  height: 200,
                  alignment: Alignment.center,
                  child: getText(text, fontSize, color),
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
    } else {
    return ElevatedButton(
      onPressed: () => null,
      style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: getText(text, fontSize, color),
      ),
    ),

    );
    }
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

  String getFieldTypeValue(word, fieldType) {
    String text = word.id.toString();
    switch (fieldType) {
      case FieldType.ID:
        text = word.id.toString();
        break;
      case FieldType.TITLE:
        text = word.title;
        break;
      case FieldType.VAL1:
        text = word.val1;
        break;
      case FieldType.VAL2:
        text = word.val2;
        break;
      case FieldType.TITLE_ID:
        text = word.title + "\n(" + word.id + ")";
        break;
      case FieldType.TITLE_VAL1:
        text = word.title + "\n(" + word.val1 + ")";
        break;
      case FieldType.TITLE_VAL2:
        text = word.title + "\n(" + word.val2 + ")";
        break;
    }
    return text;
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
    Globals().printDebug('********** onset tile 1 word:' + word.title);
    Globals().printDebug('********** onset tile 2 word:' + Globals().alphabetOnsetList.length.toString());
    late Word onset;
    try {
      onset = Globals().alphabetOnsetList.singleWhere((element) => element.title == word.title.substring(0,1));
      Globals().printDebug('********** onset tile 3 word:' + onset.title);
    } catch (e) {
      Globals().printDebug('********** onset error:' + e.toString());
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
    if (containsAudio)
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
    else
      return ElevatedButton(
          onPressed: () => null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white
          ),
          child: getImage(id,imageSize)
      );
  }

  Padding getImage(int id, double width) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        color: Colors.white,
        child: Image(
          image: AssetImage('assets/images/$id.png'),
          width: width,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  PlayerBuilder getNavButtonPrevious() {
    print("getNavButtonPrevious");
    return PlayerBuilder.isPlaying(
        player: Globals().audioPlayer,
        builder: (context, isPlaying) {
          return InkWell(
            onTap: () => (!isPlaying)?previous():null,
            child: Icon(
              IconData(58376, fontFamily: 'LiteraIcons'),
              color: (!isPlaying)?Colors.blue:Colors.grey,
              size: 80,
            ),
          );
        }
    );
  }

  Widget getNavButtonNext() {
    print("getNavButtonNext");
    return PlayerBuilder.isPlaying(
        player: Globals().audioPlayer,
        builder: (context, isPlaying) {
          return InkWell(
            onTap: () => (!isPlaying)?next():null,
            child: Icon(
              IconData(58377, fontFamily: 'LiteraIcons'),
              color: (!isPlaying)?Colors.blue:Colors.grey,
              size: 80,
            ),
          );
        }
    );
  }

  void saveCorrectionValues () async {
    print("SaveCorrectionValues");
    String correctKey = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-correct';
    print("CorrectKey: $correctKey = " + flagCorrect.value.toString());
    int correctValue = (Globals().prefs.getInt(correctKey) ?? 0) + flagCorrect.value;
    await Globals().prefs.setInt(correctKey, correctValue);
    String wrongKey = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-wrong';
    print("WrongKey: $wrongKey =" + flagWrong.value.toString());
    int wrongValue = (Globals().prefs.getInt(wrongKey) ?? 0) + flagWrong.value;
    await Globals().prefs.setInt(wrongKey, wrongValue);
    flagCorrect.value = 0;
    flagWrong.value = 0;
  }

  void next() {
    audioStop();
    Globals().printDebug("*********** next");
    if (isEndPosition) {
      modulePos++;
      Globals().printDebug("modulePos: $modulePos");
      Globals().printDebug("year: $yearIndex");
      Globals().printDebug("subject: $subjectIndex");
      if (
      // unlock only if minimum grade reached
      type == ModuleType.TEST &&
          correctCount/numberQuestions*100 >= int.parse(Globals().percentUnlock)  &&
          modulePos > Globals().getUnlockModuleIndex(yearIndex, subjectIndex)
      ) {
        print("test1");
        setUnlockModule(modulePos);
        showEndAlertDialog(context,true);
      } else if (
        // unlock only if minimum grade reached
        type == ModuleType.TEST &&
        correctCount/numberQuestions*100 < int.parse(Globals().percentUnlock)
      ) {
        print("test2");
        showEndAlertDialog(context,false);
      } else if (
        // unlock if not TEST
        type != ModuleType.TEST &&
        modulePos > Globals().getUnlockModuleIndex(yearIndex, subjectIndex)
      ) {
        print("test3");
        setUnlockModule(modulePos);
        Navigator.of(context).pop();
      } else {
        print("test4");
        Navigator.of(context).pop();
      }
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
    Globals().printDebug('alert');
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text('\n' + Globals().getAssetsVocab('BEGINNING'),
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

  showEndAlertDialog(BuildContext context, [bool pass=false, String grade='']) {
    Globals().printDebug('alert');
    String message = '';
    if (pass) {
      audioPlay("cheer");
      message = "Parabéns! Prossiga para o próximo módulo!";
    } else {
      audioPlay("moan");
      message = "Você acertou $correctCount de $numberQuestions. Acerte " + (numberQuestions*int.parse(Globals().percentUnlock)/100).ceil().toString() + " ou mais perguntas para prosseguir.";
    }
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // close popup
        Navigator.of(context).pop(); // back one page
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        message,
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
    await Globals().setUnlockModuleIndex(newIndex, yearIndex, subjectIndex);
  }

  @override
  void dispose() {
    audioStop();
    super.dispose();
  }

  void unlockNextModule() {
    modulePos++;
    if (modulePos > Globals().getUnlockModuleIndex(yearIndex, subjectIndex))
      setUnlockModule(modulePos);
  }

  void audioPlay(Object itemId) async {
    audioStop();
    Globals().audioPlayer.open(Audio("assets/audios/$itemId.mp3"));
  }

  void audioPlayOnset(String onset) {
    Word testWord = Globals().alphabetOnsetList.firstWhere((word) => word.title.startsWith(onset));
    print("onset3: " + testWord.title);
    audioPlay(testWord.id);
  }

  void playTime(String time) {
    int hr = int.parse(time.substring(0,2));
    int min = int.parse(time.substring(3,5));
    Globals().audioPlayer.stop();
    String strHr = (400+hr).toString();
    String strHrEnding = "horas";
    String strMin = (600+min).toString();
    if (min == 0) {
      if (hr == 1) strHrEnding = "hora";
      if (hr >  1) strHrEnding = "horas";
      Globals().audioPlayer.open(
        Playlist(
            audios: [
              Audio("assets/audios/$strHr.mp3"),
              Audio("assets/audios/$strHrEnding.mp3")
            ]
        ),
      );
    } else {
      if (hr == 1) strHrEnding = "hora_e";
      if (hr >  1) strHrEnding = "horas_e";
      Globals().audioPlayer.open(
        Playlist(
            audios: [
              Audio("assets/audios/$strHr.mp3"),
              Audio("assets/audios/$strHrEnding.mp3"),
              Audio("assets/audios/$strMin.mp3"),
              Audio("assets/audios/minutos.mp3"),
            ]
        ),
      );
    }
  }

  void audioStop() {
    Globals().audioPlayer.stop();
    Globals().t1?.cancel();
    Globals().t2?.cancel();
    Globals().t3?.cancel();
  }

}
