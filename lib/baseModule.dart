import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'menu.dart';
import 'word.dart';
import 'globals.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:just_audio/just_audio.dart';

class BaseModule extends StatefulWidget {
  @override
  BaseModuleState createState() => BaseModuleState();
}

class BaseModuleState<T extends BaseModule> extends State<T> {

  int listPosition=0;

  AudioPlayer player = AudioPlayer();

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

  late double mainFontSize;
  late double optionFontSize;
  late double mainWidth;
  late double mainHeight;
  late double optionWidth;
  late double optionHeight;
  Color mainFontColor = Globals().appFontColorLight;
  Color optionFontColor = Globals().appFontColorLight;
  late Object? mainFieldType = FieldType.TITLE;
  late Object? optionFieldType = FieldType.VAL1;
  late Object? optionTileType = TileType.TEXT;
  late Object? sortCriteria = FieldType.ID;
  late Object? misc;

  bool loop = false;
  bool containsAudio = true;
  bool noLock = false;
  Color buttonColor = Colors.grey;

  late Word wordMain;
  Color backgroundColor = Globals().appBackgroundColor;

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
//          "AD77649C27A07629F1CBF3D6291B6C84",
//          "5DA35B68B1037D249669C37E7087B993",
          "BB2C1C888DC418C2F6D73E1A5BE6F964"
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
      // test mode
      // numberQuestions = 1;
      Globals().printDebug("test8");
      useNavigation = (args?['useNavigation']) ?? useNavigation;
      Globals().printDebug("test9");
      useProgressBar = args?['useProgressBar'] ?? useProgressBar;
      Globals().printDebug("test10");
      fontFamily = args?['fontFamily'] ?? fontFamily;
      Globals().printDebug("test10.1");
      //debugPrint("***************** mainFontSize3: $mainFontSize");
      mainFontSize = args?['mainFontSize'];
      debugPrint("******************* mainFontSize4: $mainFontSize");
      Globals().printDebug("test10.2");
      optionFontSize = args?['optionFontSize'] ?? optionFontSize;
      mainWidth = args?['mainWidth'] ?? mainWidth;
      mainHeight = args?['mainHeight'] ?? mainHeight;
      optionWidth = args?['optionWidth'] ?? optionWidth;
      optionHeight = args?['optionHeight'] ?? optionHeight;
      mainFontColor   = args?['mainFontColor'] ?? mainFontColor;
      optionFontColor = args?['optionFontColor'] ?? optionFontColor;
      mainFieldType = args?['mainFieldType'] ?? mainFieldType;
      optionFieldType = args?['optionFieldType'] ?? optionFieldType;
      optionTileType = args?['optionTileType'] ?? optionTileType;
      sortCriteria = args?['sortCriteria'] ?? sortCriteria;
      try {
        misc = args?['misc'] ?? misc;
      } catch (e) {
        misc = null;
      }
      Globals().printDebug("test10.1");

      loop = args?['loop'] ?? loop;
      Globals().printDebug("test10.2");
      containsAudio = args?['containsAudio'] ?? containsAudio;
      noLock = args?['noLock'] ?? false;

      if (noLock) unlockNextModule();

      if (listProcess is List<Word>) {
        switch (sortCriteria) {
          case FieldType.ID:
            Globals().printDebug("sort criteria: $sortCriteria");
            criteria = (a, b) => (a as Word).id.compareTo((b as Word).id);
            break;
          case FieldType.TITLE:
            Globals().printDebug("sort criteria: $sortCriteria");
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white, Globals().appBarColorDark],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: getAppBar(),
        drawer: () {
          getMenu();
        } (),
        body: getBody()
      ),
    );
  }

  Widget getMenu() {
    return Menu();
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
    );
  }

  Widget getBody() {
    Globals().printDebug("baseModule: getBody 01");
    if (listProcess.length <= 1) {
      useNavigation = false;
      useProgressBar = false;
      Globals().printDebug("baseModule: getBody 02");
    }
    Globals().printDebug("baseModule: getBody 03");
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (useProgressBar) getProgressBar(),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: getMainTile(),
            )
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: (useNavigation)? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceAround,
              children: [
                if (useNavigation) getNavButtonPrevious(),
                if (useNavigation) getNavButtonNext(),// navigation next
              ],
            ),
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ValueListenableBuilder(
                    valueListenable: isBannerAdReady,
                    builder: (context, value, widget) {
                      return getAd();
                    }
                ),
              ),
            ),
          ],
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
    Globals().printDebug("listPosition: $listPosition");
    Globals().printDebug("numberQuestions: $numberQuestions");
    double percent = (numberQuestions>0)?(listPosition+1) / numberQuestions:0;
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(10.0),
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        animation: true,
        animationDuration: 500,
        percent: percent,
        animateFromLastPercent: true,
        leading: Text((listPosition+1).toString() + '  ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        ),
        trailing: Text(numberQuestions.toString() + '  ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white),
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
    Globals().printDebug("listProcess count: $listProcess");
    wordMain = listProcess[listPosition] as Word;
    audioPlay(wordMain.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getImageTile(wordMain.id), // image
        getMainText(wordMain,mainFontSize), // words
      ],
    );
  }

  String getMainLabel(String text) {
    return text;
  }

  Widget getMainText(
      Word word,
      double fontSize,
      {String fontFamily = "Litera-Regular",
        Color fontColor = Colors.teal,
        Color backgroundColor = Colors.white
      }
    ) {
    String? label;
    switch (mainFieldType as dynamic) {
      case FieldType.VAL1:
        label = word.val1;
        break;
      default:
        label = word.title;
        break;
    }
    return ElevatedButton(
      onPressed: null,
      child: AutoSizeText(
        getMainLabel(label),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: fontColor,
        )
      ),
      style: Globals().buttonStyle(
        backgroundColor: backgroundColor,
      ),
    );
  }

  ElevatedButton getTextTile(Word word, {double fontSize=50, Color? backgroundColor=Colors.white, Color? borderColor=Colors.white, Color fontColor=Colors.teal, double width=250, double height=200}) {
    int id = word.id;
    String text = word.title;
    if (containsAudio) {
      return ElevatedButton(
          onPressed: () => audioPlay(id),
          style: Globals().buttonStyle(
            backgroundColor: backgroundColor!,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: width,
                  height: 200,
                  alignment: Alignment.center,
                  child: getText(text, fontSize, fontColor),
                ),
              ),
              Positioned(
                bottom: 11, right: 1,
                child: Icon(
                  IconData(57400, fontFamily: 'LiteraIcons'),
                  color: Colors.blue,
                  size: 38,
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
      style: Globals().buttonStyle(
        backgroundColor: backgroundColor!
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: getText(text, fontSize, fontColor),
        ),
      ),
    );
    }
  }

  Widget getText(String text, [double fontSize = 100, Color fontColor = Colors.teal, String fontFamily = 'Litera-Regular']) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontFamily: fontFamily,
      ),
    );
  }

  ElevatedButton getSoundTile(Word word, {Color borderColor=Colors.blue}) {
    return ElevatedButton(
        onPressed: () => audioPlay(word.id),
        style: Globals().buttonStyle(
          borderColor: borderColor
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              IconData(57400, fontFamily: 'LiteraIcons'),
              color: Colors.blue,
              size: 98,
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

  ElevatedButton getOnsetTile(Word word, {double imageSize=200}) {
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
        style: Globals().buttonStyle(),
        child: Stack(
          children: [
            getImage('voice-onset',width:imageSize),
            Positioned(
              bottom: 11, right: 1,
              child: Icon(
                IconData(57400, fontFamily: 'LiteraIcons'),
                color: Colors.blue.withOpacity((word.id==8)?0.5:1.0), // opacity on muted letter (h)
                size: 38,
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

  Widget getImageTile(int id, {double imageSize=200, Color borderColor=Colors.blue, Color backgroundColor=Colors.white}) {
    if (containsAudio)
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: () => audioPlay(id),
          style: Globals().buttonStyle(
            borderColor: borderColor
          ),
          child: Stack(
            children: [
              getImage(id,width:imageSize),
              Positioned(
                bottom: 11, right: 1,
                child: Icon(
                  IconData(57400, fontFamily: 'LiteraIcons'),
                  color: Colors.blue,
                  size: 38,
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
            ),
      );
    else
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
            onPressed: () => null,
            style: Globals().buttonStyle(),
            child: getImage(id,width:imageSize)
        ),
      );
  }

  Widget getImage(id, {double width=100, double padding=10, Color backgroundColor=Colors.white}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        color: backgroundColor,
        child: Image(
          image: AssetImage('assets/images/$id.png'),
          width: width,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  Widget getNavButtonPrevious() {
    //Globals().printDebug("getNavButtonPrevious");
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
    //Globals().printDebug("getNavButtonNext");
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
    //Globals().printDebug("SaveCorrectionValues");
    String correctKey = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-correct';
    //Globals().printDebug("CorrectKey: $correctKey = " + flagCorrect.value.toString());
    int correctValue = (Globals().prefs.getInt(correctKey) ?? 0) + flagCorrect.value;
    await Globals().prefs.setInt(correctKey, correctValue);
    String wrongKey = 'reports-$yearIndex-$subjectIndex-$modulePos-' + wordMain.id.toString() + '-wrong';
    //Globals().printDebug("WrongKey: $wrongKey =" + flagWrong.value.toString());
    int wrongValue = (Globals().prefs.getInt(wrongKey) ?? 0) + flagWrong.value;
    await Globals().prefs.setInt(wrongKey, wrongValue);
    flagCorrect.value = 0;
    flagWrong.value = 0;
  }

  void next([bool refresh=true]) {
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
        Globals().printDebug("test1");
        setUnlockModule(modulePos);
        showEndAlertDialog(context,true);
      } else if (
        // unlock only if minimum grade reached
        type == ModuleType.TEST &&
        correctCount/numberQuestions*100 < int.parse(Globals().percentUnlock)
      ) {
        Globals().printDebug("test2");
        showEndAlertDialog(context,false);
      } else if (
        // unlock if not TEST
        type != ModuleType.TEST &&
        modulePos > Globals().getUnlockModuleIndex(yearIndex, subjectIndex)
      ) {
        Globals().printDebug("test3");
        setUnlockModule(modulePos);
        Navigator.of(context).pop();
      } else {
        Globals().printDebug("test4");
        Navigator.of(context).pop();
      }
    } else {
      listPosition++;
      if (refresh)
      {
        setState(() {
          setEndPoints();
        });
      } else {
        setEndPoints();
      }
    }
  }

  void previous([bool refresh=true]) {
    audioStop();
    if (isStartPosition) {
      showBeginningAlertDialog(context);
    } else {
      listPosition--;
      if (refresh) {
        setState(() {
          setEndPoints();
        });
      } else {
        setEndPoints();
      }
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
    Globals().printDebug("ListPosition: $listPosition");
    Globals().printDebug("EndPoint: $isEndPosition");
    Globals().printDebug("NumberOfQuestions: $numberQuestions");
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

  void audioPlay(Object itemId, [int delay=0]) async {
    audioStop();
    Globals().t1 = Timer(Duration(milliseconds: delay), () {
      Globals().audioPlayer.open(Audio("assets/audios/$itemId.mp3"));
    });
  }

  void audioPlayOnset(String onset) {
    Word testWord = Globals().alphabetOnsetList.firstWhere((word) => word.title.startsWith(onset));
    Globals().printDebug("onset3: " + testWord.title);
    audioPlay(testWord.id);
  }

  void playTime(String time) async {
    int hr = int.parse(time.substring(0,2));
    debugPrint("playTime: 1");
    int min = int.parse(time.substring(3,5));
    debugPrint("playTime: 2");
    debugPrint("playTime: 3");
    String strHr = (400+hr).toString();
    debugPrint("playTime: 4");
    String strHrEnding = "horas";
    String strMin = (600+min).toString();
    late final playlist;
    if (min == 0) {
      if (hr == 1) strHrEnding = "hora";
      if (hr > 1) strHrEnding = "horas";
      playlist = ConcatenatingAudioSource(
          children: [
            AudioSource.asset("assets/audios/$strHr.mp3"),
            AudioSource.asset("assets/audios/$strHrEnding.mp3"),
          ],
      );
    } else {
      if (hr == 1) strHrEnding = "hora_e";
      if (hr >  1) strHrEnding = "horas_e";
      playlist = ConcatenatingAudioSource(
        children: [
          AudioSource.asset("assets/audios/$strHr.mp3"),
          AudioSource.asset("assets/audios/$strHrEnding.mp3"),
          AudioSource.asset("assets/audios/$strMin.mp3"),
          AudioSource.asset("assets/audios/minutos.mp3"),
        ],
      );
    }
    player.stop();
    debugPrint("playTime: 5");
    try {
      await player.setAudioSource(playlist, initialIndex: 0, initialPosition: Duration.zero);
    } catch (e) {
      player = AudioPlayer();
    }
    debugPrint("playTime: 6");
    await player.play();
    debugPrint("playTime: 7");
  }

  void audioStop() {
    player.stop();
    player.dispose();
    Globals().audioPlayer.stop();
    Globals().t1?.cancel();
    Globals().t2?.cancel();
    Globals().t3?.cancel();
  }

}
