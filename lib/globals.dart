import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'word.dart';
import 'module.dart';
import 'subject.dart';
import 'year.dart';

enum ModuleType {
  LESSON,
  EXERCISE,
  TEST,
  REPORT,
  GAME
}

enum AudioType {
  MIDI,
  FILE,
}

enum FieldType {
  ID,
  TITLE,
  VAL1,
  VAL2,
  VAL3,
  TITLE_ID,
  TITLE_VAL1,
  TITLE_VAL2,
  TITLE_VAL3,
}

enum TileType {
  TEXT,
  AUDIO,
  IMAGE,
}

enum Sub {
  PORTUGUESE,
  MATH,
  SCIENCE,
  GEOGRAPHY,
  MUSIC,
}

enum Yr {
  ONE,
  TWO,
  THREE,
}

List<Color?> optionColors = [
  Colors.pink[50],
  Colors.blue[50],
  Colors.green[50],
  Colors.orange[50],
  Colors.red[50],
  Colors.yellow[50],
  Colors.teal[50],
  Colors.cyan[50],
  Colors.brown[50],
  Colors.purple[50]
];

class Globals {
  static final Globals _singleton = Globals._internal();

  factory Globals() {
    return _singleton;
  }

  Globals._internal();

  bool firstTime = true;

  late String appOralLanguage;
  late String appTitle;
  late String devName;
  late String devEmail;

  late int navigationLanguage;

  late int buildNumber;
  late String version;

  List<MapEntry> settingsNavigationLanguage = [];
  late Map<String, dynamic> _assetsConfig;

  Color appBarColorLight = Colors.teal.shade200;
  Color appBarColor = Colors.teal.shade400;
  Color appBarColorDark = Colors.teal.shade800;

  Color appColorLight = Colors.teal.shade200;
  Color appColor = Colors.teal.shade400;
  Color appColorDark = Colors.teal.shade600;
  Color appFontColorLight = Colors.white;
  Color appFontColorDark = Colors.teal.shade800;
  Color appBackgroundColor = Colors.teal.shade50;
  Color appButtonColor = Colors.blue;
  double appButtonFontSize = 20;

  final bool debugMode = true;

  late List<Word> alphabet;
  late List<Word> syllableUnique;
  late List<Word> listWordOnset;
  late List<Word> listVowels;
  late List<Word> listAlphabet;
  late List<Word> listNumber1t20;
  late List<Word> listNumber30t100;
  late List<Word> listColors;
  late List<Word> listMusicNotes;
  late List<Word> listMusicInstruments;
  late List<Word> listNumber1t10Ordinal;
  late List<Word> listNumber20t100Ordinal;
  late List<Word> listVocab;
  late List<Word> listAnimals;
  late List<Word> listOddEvenNumbers;
  late List<Word> alphabetOnsetList;
  late List<Word> listAlphabetSounds;
  late List<Word> letterOnsetList;
  late List<Word> listOnsetConsonants; // list of alphabet letters used for onset lesson
  late List<Word> lettersMatchCase;
  late List<Word> valOrderNumbers;
  late List<Word> valOrderVowels;
  late List<Word> valOrderAlphabet;
  late List<Word> listSyllables;
  late List<Map<String, List<Word>>> mapMatchSyllable;
  late List<Map<String, List<Word>>> mapMatchWord;
  late List<Map<String, List<Word>>> mapMatchVertebrateAnimal;
  late List<Map<String, List<Word>>> mapMatchOddEvenNumber;
  late List<Word> listDirections;
  late List<Word> listDaysOfTheWeek;
  late List<Word> listMonthsOfTheYear;
  late List<Word> listSeasonsOfTheYear;
  late List<Word> listPlanets;
  late List<List<Word>> listGenderNumber;
  late List<Word> listTimeLessonHour;
  late List<Word> listTimeLessonMinutes;
  late List<Word> listTimeHour;
  late List<Word> listTimeMinutes;
  late List<Word> listTimeTest;
  late List<Word> listStateCapital;

  late List<Word> listMath1;
  late List<Word> listMath2;
  late List<Word> listMath3;
  late List<Word> listMath4;
  late List<Word> listMath5;
  late List<Word> listMath6;
  late List<Word> listMath7;

  // late List<Word> listMath1Subtraction1;
  // late List<Word> listMath2Subtraction1;
  late List<int> listTimesTableBase;

  late Map<String, dynamic> parsedWords;

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  Timer? t1, t2, t3 = Timer(Duration(seconds: 1), () {});

  late Widget adWidget;

//index 0 = year 1; index 1 = year 2;
  List<int> expandedId = [];

  late SharedPreferences prefs;

  String percentUnlock = "80";

  Future<Map<String, dynamic>> getConfigAssets() async {
    return _assetsConfig;
  }

  List<String> enumGenderNumber = [
    'Masculino / Singular',
    'Feminino / Singular',
    'Masculino / Plural',
    'Feminino / Plural',
  ];

  List<Year> listYears = [];

  Future clearSettings(String section) async {
    for (int i=prefs.getKeys().length-1; i>=0; i--) {
      String key = prefs.getKeys().elementAt(i);
      if (key.startsWith(section + '-')) prefs.remove(key);
    }
  }

  void unLockAll() {
    for (int i=0; i<listYears.length; i++) {
      Year year = listYears[i];
      for (int j=0; j<year.subjects.length; j++) {
        Subject subject = year.subjects[j];
        setUnlockModuleIndex(subject.modules.length, year.id.index, subject.id.index);
      }
    }
  }

  void resetApp(context) async {
    debugPrint("resetApp");
    await clearSettings('reports');
    await clearSettings('unlockModuleIndex');
//    prefs.setInt('expandedId',1);
    prefs.setString('percentUnlock',Globals().percentUnlock);
    Phoenix.rebirth(context);
  }

  Future init(context) async {
    print("******** init 0");

    prefs = await SharedPreferences.getInstance();

    printDebug("******** init1");
    alphabet = [];
    syllableUnique = [];
    listWordOnset = [];
    listSyllables = [];
    listVowels = [];
    listAlphabet = [];
    listVocab = [];
    listAnimals = [];
    listOddEvenNumbers = [];
    listNumber1t20 = [];
    listNumber30t100 = [];
    listColors = [];
    listMusicNotes = [];
    listMusicInstruments = [];
    listNumber1t10Ordinal = [];
    listNumber20t100Ordinal = [];
    alphabetOnsetList = [];
    listAlphabetSounds = [];
    letterOnsetList = [];
    listOnsetConsonants = [];
    lettersMatchCase = [];
    valOrderNumbers = [];
    valOrderVowels = [];
    valOrderAlphabet = [];
    mapMatchSyllable = [];
    mapMatchVertebrateAnimal = [];
    mapMatchOddEvenNumber = [];
    mapMatchWord = [];
    listYears = [];
    listDirections = [];
    listDaysOfTheWeek = [];
    listMonthsOfTheYear = [];
    listSeasonsOfTheYear = [];
    listPlanets = [];
    listGenderNumber = [];
    listTimeLessonHour = [];
    listTimeLessonMinutes = [];
    listTimeHour = [];
    listTimeMinutes = [];
    listTimeTest = [];
    listMath1 = [];
    listMath2 = [];
    listMath3 = [];
    listMath4 = [];
    listMath5 = [];
    listMath6 = [];
    listMath7 = [];
    // listMath1Subtraction1 = [];
    // listMath2Subtraction1 = [];
    listStateCapital = [];
    listTimesTableBase = [1,2,3,4,5,6,7,8,9,10];

    printDebug("******** init 2");

    settingsNavigationLanguage.clear();

    listSyllables.clear();

    printDebug("******** init 3");

    getNavigationLanguage();

    printDebug("******** init 4");
    await populate();

    printDebug("******** init 4.1");
    getYear1Por();
    printDebug("******** init 4.2");
    getYear1Mat();
    getYear1Sci();
    getYear1Mus();

    printDebug("******** init 4.3");
    getYear2Por();
    printDebug("******** init 4.4");
    getYear2Mat();
    getYear2Sci();

    getYear3Por();
    getYear3Geo();
    getYear3Sci();
    getYear3Math();

    printDebug("******** init 5");
    expandedId.asMap().forEach((index, value) => prefs.getInt("expandedId-$index") ?? Sub.PORTUGUESE.index);
    Globals().printDebug("expandedId-0: " + expandedId[0].toString());
    Globals().printDebug("expandedId-1: " + expandedId[1].toString());
    printDebug("******** init 6");

    percentUnlock = prefs.getString('percentUnlock') ?? percentUnlock;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("******** init1.5 " + packageInfo.version);
    buildNumber = int.parse(packageInfo.buildNumber);

    try {
      version = prefs.getString('version')!;
      firstTime = false;
      printDebug("version2: $version");
    } catch (e) {
      // first time
      unLockAll();
      version = packageInfo.version;
      prefs.setString('version',version);
      firstTime = true;
      Globals().printDebug("Error getting version from smartphone: $e");
    }
    if (version != packageInfo.version) {
      print ("version3: $version");
      Globals().printDebug("packageinfo: " + packageInfo.version);
      version = packageInfo.version;
      prefs.setString('version',version);
      prefs.setInt('expandedId',1);
      resetApp(context);
    }
    prefs.setBool('firsttime',firstTime);

    printDebug("******** finished populate");
  }

  Future populate() async {
    printDebug("******** populate 1");

    await rootBundle.loadString('assets/config.json').then((value) {
      _assetsConfig = json.decode(value);
      devName = _assetsConfig['CONFIG']['DEVELOPER']['NAME'];
      devEmail = _assetsConfig['CONFIG']['DEVELOPER']['EMAIL'];
      appOralLanguage = _assetsConfig['CONFIG']['APP']['ORAL-LANGUAGE'];
      appTitle = _assetsConfig['CONFIG']['APP']['TITLE'];
      int langCount = _assetsConfig['CONFIG']['SETTINGS'].length;
      for (int i = 0; i < langCount; i++) {
        settingsNavigationLanguage.add(MapEntry(
            i, _assetsConfig['CONFIG']['SETTINGS'][i]['NAVIGATION-LANGUAGE']));
      }
    });

    printDebug("******** populate 2");

    try {
      String jsonString = await rootBundle.loadString("assets/words.json");
      parsedWords = json.decode(jsonString);
    } catch (e) {
      printDebug(e.toString());
    }

    printDebug("******** populate 3");

    // populate vocab list
    List<dynamic> listKeys = parsedWords['LIST']['VOCABULARY'].keys.toList();
    //Globals().printDebug("key count: " + listKeys.length.toString());
    for (int id=0; id<listKeys.length; id++) {
      printDebug("******** populate 3.1: $id");
      var key = listKeys[id];
      printDebug("******** populate 3.2");
      //Globals().printDebug("key $key");
      List listElement = parsedWords['LIST']['VOCABULARY']["$key"];
      String title = listElement[0].replaceAll('-', '');
      printDebug("******** populate 3.3");
      String val2 = listElement[1].toString();
      printDebug("******** populate 3.4");
      Word word = Word(int.parse(key), title);
      printDebug("******** populate 3.5 " + word.id.toString());
      word.val1 = listElement[0];
      printDebug("******** populate 3.5 " + word.title.toString());
      word.val2 = val2;
      word.containsAudio = await AssetExists('assets/audios/$key.mp3');
      word.containsImage = await AssetExists('assets/images/$key.png');
      Globals().printDebug("$id contains audio: " + word.containsAudio.toString());
      Globals().printDebug("$id contains image: " + word.containsImage.toString());
      listVocab.add(word);
      Globals().printDebug("word added to listVocab");
      printDebug("******** populate 4");
    }

    // populate vocab list
    parsedWords['LIST']['DAYS-OF-THE-WEEK'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['DAYS-OF-THE-WEEK'][key];
      Word word = Word(id, title);
      listDaysOfTheWeek.add(word);
    });

    printDebug("******** populate 4.1");

    // populate vocab list
    parsedWords['LIST']['DIRECTIONS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['DIRECTIONS'][key];
      Word word = Word(id, title);
      listDirections.add(word);
    });

    printDebug("******** populate 4.2");

    // populate vocab list
    parsedWords['LIST']['MONTHS-OF-THE-YEAR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MONTHS-OF-THE-YEAR'][key];
      Word word = Word(id, title, (id - 3600).toString());
      listMonthsOfTheYear.add(word);
    });

    printDebug("******** populate 5");

    parsedWords['LIST']['SEASONS-OF-THE-YEAR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['SEASONS-OF-THE-YEAR'][key];
      Word word = Word(id, title);
      listSeasonsOfTheYear.add(word);
    });

    parsedWords['LIST']['PLANETS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['PLANETS'][key];
      Word word = Word(id, title);
      word.val1 = title;
      listPlanets.add(word);
    });

    printDebug("******** populate 6");

    parsedWords['LIST']['GENDER-NUMBER'].keys.forEach((key1) {
      List<Word> listWord = [];
      parsedWords['LIST']['GENDER-NUMBER'][key1]
          .asMap()
          .keys
          .forEach((key2) {
        parsedWords['LIST']['GENDER-NUMBER'][key1][key2].keys
            .forEach((key3) {
          int id = int.parse(key3);
          String title = parsedWords['LIST']['GENDER-NUMBER'][key1][key2][key3]
              .toString();
          listWord.add(Word(id, title, key2.toString()));
        });
      });
      Globals().printDebug("List length: " + listWord.length.toString());
      listGenderNumber.add(listWord);
    });

    printDebug("******** populate 7");

    parsedWords['LIST']['ALPHABET'].forEach((key) {
      int id = int.parse(key.toString());
      //printDebug("key:" + key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        // printDebug("id:" + word.id.toString());
        // printDebug("title:" + word.title);
        alphabet.add(word);
      } else {
        printDebug("empty result");
      }
    });

    parsedWords['LIST']['SYLLABLE-UNIQUE'].forEach((key) {
      int id = int.parse(key.toString());
      //printDebug("key:" + key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        // printDebug("id:" + word.id.toString());
        // printDebug("title:" + word.title);
        syllableUnique.add(word);
      } else {
        printDebug("empty result");
      }
    });

    printDebug("******** populate 8");

    // populate vowel list
    parsedWords['LIST']['ALPHABET-VOWELS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ALPHABET-VOWELS'][key];
      Word word = Word(id, title);
      listVowels.add(word);
    });

    // populate vowel list
    parsedWords['LIST']['ORDER-ALPHABET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ORDER-ALPHABET'][key];
      Word word = Word(id, title);
      listAlphabet.add(word);
    });

    printDebug("******** populate 9");

    // populate number list
    parsedWords['LIST']['NUMBERS_1-20'].keys.forEach((key) {
      int id = int.parse(key);
      printDebug('key: ' + key);
      parsedWords['LIST']['NUMBERS_1-20'][id.toString()].keys
          .forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['NUMBERS_1-20'][id
            .toString()][value];
        printDebug('title: ' + title);
        Word word = Word(id, title);
        word.val1 = value;
        word.val2 = key;
        listNumber1t20.add(word);
      });
    });

    printDebug("******** populate 10");

    parsedWords['LIST']['NUMBERS_30-100'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['NUMBERS_30-100'][id.toString()].keys
          .forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['NUMBERS_30-100'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listNumber30t100.add(word);
      });
    });

    printDebug("******** populate 11");

    parsedWords['LIST']['COLORS'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['COLORS'][id.toString()].keys
          .forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['COLORS'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listColors.add(word);
      });
    });

    printDebug("******** populate 12");

    parsedWords['LIST']['MUSIC-NOTES'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['MUSIC-NOTES'][id.toString()].keys
          .forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['MUSIC-NOTES'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        word.val3 = AudioType.FILE.name;
        listMusicNotes.add(word);
      });
    });

    printDebug("******** populate 13");

    parsedWords['LIST']['MUSIC-INSTRUMENTS'].keys.forEach((key) {
      int id = int.parse(key);
      printDebug('key: ' + key);
      String title = parsedWords['LIST']['MUSIC-INSTRUMENTS'][id
          .toString()];
      printDebug('title: ' + title);
      Word word = Word(id, title, id.toString());
      word.val3 = AudioType.FILE.name;
      listMusicInstruments.add(word);
    });

    parsedWords['LIST']['NUMBERS_1-10_ORDINAL'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['NUMBERS_1-10_ORDINAL'][id.toString()]
          .keys.forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['NUMBERS_1-10_ORDINAL'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listNumber1t10Ordinal.add(word);
      });
    });

    parsedWords['LIST']['NUMBERS_20-100_ORDINAL'].keys.forEach((
        key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['NUMBERS_20-100_ORDINAL'][id.toString()]
          .keys.forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['NUMBERS_20-100_ORDINAL'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listNumber20t100Ordinal.add(word);
      });
    });

    printDebug("******** populate 14");

    // populate alphabet onset
    parsedWords['LIST']['ALPHABET-ONSET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ALPHABET-ONSET'][key];
      Word word = Word(id, title);
      alphabetOnsetList.add(word);
    });

    // populate alphabet onset
    parsedWords['LIST']['ALPHABET-LETTER-SOUND'].keys.forEach((
        key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ALPHABET-LETTER-SOUND'][key];
      Word word = Word(id, title, title);
      listAlphabetSounds.add(word);
    });

    // populate letter onset
    parsedWords['LIST']['LETTER-ONSET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['LETTER-ONSET'][key];
      Word word = Word(id, title);
      letterOnsetList.add(word);
    });

    // populate wo alphabet list
    parsedWords['LIST']['LIST-ONSET-CONSONANTS'].keys.forEach((
        key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['LIST-ONSET-CONSONANTS'][key];
      Word word = Word(id, title);
      listOnsetConsonants.add(word);
    });

    // populate alphabet list
    parsedWords['LIST']['MATCH-CASE'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATCH-CASE'][key];
      Word word = Word(id, title);
      lettersMatchCase.add(word);
    });

    printDebug("******** populate 15");

    // populate number order list
    parsedWords['LIST']['ORDER-NUMBERS_1-10'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ORDER-NUMBERS_1-10'][key];
      Word word = Word(id, title);
      valOrderNumbers.add(word);
    });

    // populate vowel order list
    parsedWords['LIST']['ORDER-VOWELS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ORDER-VOWELS'][key];
      Word word = Word(id, title);
      valOrderVowels.add(word);
    });

    // populate alphabet order list
    parsedWords['LIST']['ORDER-ALPHABET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['ORDER-ALPHABET'][key];
      Word word = Word(id, title);
      valOrderAlphabet.add(word);
    });

    // populate word list
    parsedWords['LIST']['LIST-SYLLABLES'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['LIST-SYLLABLES'][key];
      Word word = Word(id, title);
      listSyllables.add(word);
    });

    parsedWords['LIST']['TIME-LESSON-HOUR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['TIME-LESSON-HOUR'][key];
      Word word = Word(id, title);
      listTimeLessonHour.add(word);
    });

    parsedWords['LIST']['TIME-LESSON-MINUTES'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['TIME-LESSON-MINUTES'][key];
      Word word = Word(id, title);
      listTimeLessonMinutes.add(word);
    });

    parsedWords['LIST']['TIME-HOUR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['TIME-HOUR'][key];
      Word word = Word(id, title);
      listTimeHour.add(word);
    });

    parsedWords['LIST']['TIME-MINUTES'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['TIME-MINUTES'][key];
      Word word = Word(id, title);
      listTimeMinutes.add(word);
    });

    parsedWords['LIST']['TIME-TEST'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['TIME-TEST'][key];
      Word word = Word(id, title);
      listTimeTest.add(word);
    });

    parsedWords['LIST']['MATH1'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH1'][key];
      Word word = Word(id, title);
      listMath1.add(word);
    });

    debugPrint("************* populate math2");

    parsedWords['LIST']['MATH2'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH2'][key];
      Word word = Word(id, title);
      listMath2.add(word);
    });

    debugPrint("************* populate math4");

    parsedWords['LIST']['MATH4'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH4'][key];
      Word word = Word(id, title);
//      debugPrint("************* populate math4: $title");
      listMath4.add(word);
//      debugPrint("************* populate math4: add");
    });

    debugPrint("************* populate math3");

    parsedWords['LIST']['MATH3'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH3'][key];
      Word word = Word(id, title);
      listMath3.add(word);
    });

    parsedWords['LIST']['MATH5'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH5'][key];
      Word word = Word(id, title);
//      debugPrint("************* populate math5: $title");
      listMath5.add(word);
//      debugPrint("************* populate math5: add");
    });

    parsedWords['LIST']['MATH6'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH6'][key];
      Word word = Word(id, title);
//      debugPrint("************* populate math6: $title");
      listMath6.add(word);
//      debugPrint("************* populate math6: add");
    });

    parsedWords['LIST']['MATH7'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['MATH7'][key];
      Word word = Word(id, title);
//      debugPrint("************* populate math7: $title");
      listMath7.add(word);
//      debugPrint("************* populate math7: add");
    });

    printDebug("******** populate 8");

    parsedWords['LIST']['SYLLABLE-MATCH'].forEach((key) {
      String _syllableId = key['SYLLABLE'].toString();
      List<Word> _listWords = [];
      key['WORDS'].forEach((key) {
        int id = int.parse(key.toString());
        final result = listVocab.where((element) => element.id == id);
        Word word;
        if (result.isNotEmpty) {
          word = result.first;
          _listWords.add(word);
        }
      });
      Map<String, List<Word>> map = {_syllableId: _listWords};
      try {
        mapMatchSyllable.add(map);
      } catch (e) {
        printDebug("Error:" + e.toString());
      }
    });

    parsedWords['LIST']['WORD-MATCH'].forEach((key) {
      String _syllable = key['SYLLABLE'].toString();
      List<Word> _listWords = [];
      key['WORDS'].forEach((key) {
        int id = int.parse(key.toString());
        final result = listVocab.where((element) => element.id == id);
        Word word;
        if (result.isNotEmpty) {
          word = result.first;
          _listWords.add(word);
        }
      });
      Map<String, List<Word>> map = {_syllable: _listWords};
      try {
        mapMatchWord.add(map);
      } catch (e) {
        printDebug("Error:" + e.toString());
      }
    });

    parsedWords['LIST']['VERTEBRATE-ANIMAL-MATCH'].forEach((key) {
      String category = key['CLASSIFICATION'].toString();
      List<Word> _listWords = [];
      key['ANIMAL'].forEach((key) {
        int id = int.parse(key.toString());
        final result = listVocab.where((element) => element.id == id);
        Word word;
        if (result.isNotEmpty) {
          word = result.first;
          word.val3 = category;
          _listWords.add(word);
          listAnimals.add(word);
        }
      });
      Map<String, List<Word>> map = {category: _listWords};
      try {
        mapMatchVertebrateAnimal.add(map);
      } catch (e) {
        printDebug("Error:" + e.toString());
      }
    });

    parsedWords['LIST']['ODD-EVEN'].forEach((key) {
      String category = key['CLASSIFICATION'].toString();
      List<Word> _listWords = [];
      key['NUMBER'].forEach((key) {
        int id = int.parse(key.toString());
        final result = listNumber1t20.where((element) => element.id == id);
        Word word;
        if (result.isNotEmpty) {
          word = result.first;
          word.val3 = category;
          _listWords.add(word);
          Globals().printDebug("title: " + word.title + " id: $id val3: " + word.val3);
          listOddEvenNumbers.add(word);
        }
      });
      Map<String, List<Word>> map = {category: _listWords};
      try {
        mapMatchOddEvenNumber.add(map);
      } catch (e) {
        printDebug("Error:" + e.toString());
      }
    });

    printDebug("******** populate 9");
    parsedWords['LIST']['WORD-ONSET'].forEach((key) {
      int id = int.parse(key.toString());
      //printDebug("key:" + key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        //printDebug("id:" + word.id.toString());
        //printDebug("title:" + word.title);
        listWordOnset.add(word);
      } else {
        printDebug("empty result");
      }
    });

    parsedWords['LIST']['STATE-CAPITAL'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      List listWords = parsedWords['LIST']['STATE-CAPITAL'][key];
      Word word = Word(id, listWords[0]);
      word.val1 = listWords[1];
      word.val2 = listWords[2];
      listStateCapital.add(word);
    });
  }

  void getYear1Por() {
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    printDebug("******** init 4.1.1");
    List<Subject> listSubjects = [];
    printDebug("******** init 4.1.2");
    List<Module> listModules = [];

    Year year = Year(
        _year,
        "1º Ano",
        Colors.red.shade200,
        listSubjects,
    );
    expandedId.add(_subject.index);

    printDebug("******** init 4.1.3");

    listYears.add(year);

    // module 0
    listModules.add(() {
      String _title = "Alfabeto (Imagens)";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          alphabet,
          '/LessonAlphabet',
          numberQuestions: 999
      );
    }());

    // listModules.add(() {
    //   String _title = "Alfabeto (Letras)";
    //   int _modulePos = listModules.length;
    //   return Module(
    //       _modulePos,
    //       _title,
    //       ModuleType.LESSON,
    //       _year,
    //       _subject,
    //       listAlphabetSounds,
    //       '/LessonAlphabetLetters',
    //       numberQuestions: 26
    //   );
    // }());
    //
    listModules.add(() {
      String _title = "Vogais";
      Globals().printDebug("length: " + listModules.length.toString());
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listVowels,
        '/LessonLetters',
      );
    }());

    listModules.add(() {
      String _title = "Ordem das Vogais";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        valOrderVowels,
        '/ModuleOrder',
      );
    }());

    listModules.add(() {
      String _title = "Ordem Alfabética";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        valOrderAlphabet,
        '/ModuleOrder',
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Letra?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listAlphabetSounds,
        '/ModuleSound2Words',
      );
    }());

    listModules.add(() {
      String _title = "Jogo da Memória";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listAlphabetSounds,
        '/UnitMemoryGame',
        numberQuestions: 5,
        mainFieldType: FieldType.TITLE,
        mainFontSize: 50,
        optionFieldType: FieldType.ID,
        optionTileType: TileType.AUDIO,
        noLock: true,
      );
    }());

    listModules.add(() {
      String _title = "Som inicial / Letras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        letterOnsetList,
        '/ModuleLetters2Onset',
        optionWidth: 150,
      );
    }());

    listModules.add(() {
      String _title = "Maiúscula / Minúscula";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        lettersMatchCase,
        '/ModuleMatchCase',
        isVisibleTarget: true,
      );
    }());

    listModules.add(() {
      String _title = "Imagem / Letras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        alphabet,
        '/ModuleLetters2Picture',
        optionFontSize: 40,
        optionWidth: 150,
      );
    }());

    listModules.add(() {
      String _title = "Som inicial / Letras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        letterOnsetList,
        '/ModuleLetters2Onset',
        useNavigation: false,
        optionWidth: 150,
      );
    }());

    listModules.add(() {
      String _title = "Maiúscula / Minúscula";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        lettersMatchCase,
        '/ModuleMatchCase',
        isVisibleTarget: true,
        useNavigation: false,
      );
    }());

    listModules.add(() {
      String _title = "Jogo de Caça-Palavras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <= 6).toList(),
        '/UnitWordSearch',
        noLock: true,
        useNavigation: false,
        useProgressBar: false,
      );
    }());

    listModules.add(() {
      String _title = "Sílabas";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listSyllables,
          '/LessonSyllables',
          numberQuestions: 999
      );
    }());

    listModules.add(() {
      String _title = "Consoantes / Vogais";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        [],
        '/LessonSyllablesConsonantsVowels',
        noLock: true,
      );
    }());

    listModules.add(() {
      String _title = "Sílabas / Palavras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        mapMatchSyllable,
        '/UnitCategory2Words',
        noLock: true,
        list2: listSyllables,
        useProgressBar: false,
        useNavigation: false,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Sílaba?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listSyllables,
        '/ModuleSound2Words',
      );
    }());

    listModules.add(() {
      String _title = "Palavras / Sílabas";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        syllableUnique.where((word) => word.title.length == 4).toList(),
        '/ModuleSyllablesWord',
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Sílaba?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listSyllables,
        '/ModuleSound2Words',
      );
    }());

    listModules.add(() {
      String _title = "Palavra / Sílabas";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        syllableUnique.where((word) => word.title.length == 4).toList(),
        '/ModuleSyllablesWord',
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Português", listModules, Image.asset('assets/icon/portuguese.png')));
  }

  void getYear1Mat() {
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MATH;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "1 - 10";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 154).toList(),
        '/LessonImageText',
        mainFieldType: FieldType.VAL1,
        mainFontSize: 80,
      );
    }());
    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " +
          getAssetsVocab('NUMBERS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 154).toList(),
        '/ModuleNumbers2Picture',
      );
    }());
    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " +
          getAssetsVocab('NUMBERS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 154).toList(),
        '/ModuleNumbers2Picture',
        useNavigation: false,
        sortCriteria: FieldType.ID,
      );
    }());
    listModules.add(() {
      String _title = getAssetsVocab('ORDER-NUMBERS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        valOrderNumbers,
        '/ModuleOrderNumeric',
      );
    }());
    listModules.add(() {
      String _title = "Números (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 153).toList(),
        '/ModuleBeforeAndAfter',
        optionFontSize: 40,
        mainFieldType: FieldType.VAL1,
      );
    }());

    listModules.add(() {
      String _title = "Jogo da Memória";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 153).toList(),
        '/UnitMemoryGame',
        numberQuestions: 2,
        mainFieldType: FieldType.TITLE,
        mainFontSize: 20,
        optionFieldType: FieldType.VAL1,
        noLock: true,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('ORDER-NUMBERS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        valOrderNumbers,
        '/ModuleOrderNumeric',
      );
    }());
    listModules.add(() {
      String _title = "Números (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 153).toList(),
        '/ModuleBeforeAndAfter',
        sortCriteria: FieldType.ID,
        optionFontSize: 40,
        mainFieldType: FieldType.VAL1,
      );
    }());

    listModules.add(() {
      String _title = "Adição (1 casa)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath1.where((word) => word.title.contains("+")).toList(),
        '/ModuleExpressionEval',
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Subtração (1 casa)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath1.where((word) => word.title.contains("-")).toList(),
        '/ModuleExpressionEval',
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMath1,
        '/ModuleExpressionEval',
        numberQuestions: 10,
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath1,
        '/ModuleExpressionEval',
        numberQuestions: 10,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Matemática", listModules,  Image.asset('assets/icon/maths.png')));
  }

  void getYear1Sci() {
    Yr _year = Yr.ONE;
    Sub _subject = Sub.SCIENCE;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "Cores";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listColors,
        '/LessonWordsAndPicture',
      );
    }());

    listModules.add(() {
      String _title = "Onde está a Cor?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listColors,
        '/ModuleColors',
        optionHeight: 150,
        misc: false,
      );
    }());

    listModules.add(() {
      String _title = "Onde está a Cor?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listColors,
        '/ModuleColors',
        optionHeight: 150,
        misc: false,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Ciências", listModules,  Image.asset('assets/icon/science.png')));
  }

  void getYear1Mus() {
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MUSIC;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "Instrumentos";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMusicInstruments,
        '/LessonMusic',
      );
    }());

    listModules.add(() {
      String _title = "Qual é o Instrumento?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        // only use first C
        listMusicInstruments,  //alphabet,
        '/ModuleWord2Pictures',
        optionHeight: 150,
      );
    }());

    listModules.add(() {
      String _title = "Som de Instrumento";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.EXERCISE,
          _year,
          _subject,
          listMusicInstruments,
          '/ModuleSound2Images',
          containsAudio: true,
          optionHeight: 150,
          misc: false // no reference note
      );
    }());

    listModules.add(() {
      String _title = "Som de Instrumento";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.TEST,
          _year,
          _subject,
          listMusicInstruments,
          '/ModuleSound2Images',
          containsAudio: true,
          optionHeight: 150,
          misc: false // no reference note
      );
    }());

    listModules.add(() {
      String _title = "Dó, Ré, Mi";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMusicNotes,
        '/LessonMusic',
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Nota? (1)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        // only use first C
        listMusicNotes.where((word) => word.id < 808).toList(),  //alphabet,
        '/ModuleWord2Pictures',
        optionHeight: 150,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Nota? (2)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMusicNotes.where((word) => word.id < 808).toList(),  // no upper C
        '/ModulePicture2Words',
        optionFieldType: FieldType.TITLE,
        optionFontSize: 30,
        containsAudio: false,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Nota? (1)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        // only use first C
        listMusicNotes.where((word) => word.id < 808).toList(),  // no upper C
        '/ModuleWord2Pictures',
        optionHeight: 150,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Nota? (2)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMusicNotes.where((word) => word.id < 808).toList(), // no upper C
        '/ModulePicture2Words',
        optionFieldType: FieldType.TITLE,
        optionFontSize: 30,
        containsAudio: false,
      );
    }());

    listModules.add(() {
      String _title = "Piano";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMusicNotes,
        '/UnitPiano',
        noLock: true,
        useNavigation: false,
        useProgressBar: false,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Tecla? (partitura)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMusicNotes,
        '/ModulePiano',
        useNavigation: false,
        misc: true, // notation and sound
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Tecla? (som)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMusicNotes,
        '/ModulePiano',
        useNavigation: false,
        misc: false,  // sound only
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Nota? (partitura)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMusicNotes,
        '/ModuleSound2Images',
        useNavigation: false,
        misc: true // include reference note
      );
    }());

    listModules.add(() {
      String _title = "Qual tecla? (som)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMusicNotes,
        '/ModulePiano',
        useNavigation: false,
        misc: false,  // sound only
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Música", listModules,  Image.asset('assets/icon/music.png')));
  }

  void getYear2Por() {
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    List<Subject> listSubjects = [];
    List<Module> listModules = [];

    Year year = Year(
        _year,
        "2º Ano",
        Colors.yellow.shade200,
        listSubjects);

    listYears.add(year);
    expandedId.add(_subject.index);

    listModules.add(() {
      String _title = "Alfabeto (Cursiva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listAlphabetSounds,
        '/LessonAlphabetCursive',
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Letras (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listAlphabetSounds,
        '/ModuleBeforeAndAfter',
        optionFontSize: 50,
        mainFieldType: FieldType.VAL1,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('WORDS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listOnsetConsonants,
        '/LessonOnset2Words',
        optionWidth: 100,
        optionHeight: 50,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('ONSETS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listWordOnset.where((word) =>
        word.title.length <= 4 && !(word.title.contains(RegExp(r'[çáãéêôóõú]'))))
            .toList(),
        '/LessonWord2Onsets',
        mainFontColor: Colors.red,
      );
    }());

    listModules.add(() {
      String _title = "Alfabeto (Sílabas)";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listVocab.where((word) => word.containsImage && word.containsAudio).toList(),  //alphabet,
          '/LessonWordsAndPicture',
          numberQuestions: 26,
          mainFieldType: FieldType.VAL1
      );
    }());
    
    listModules.add(() {
      String _title = "Sílabas Iniciais";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          mapMatchWord,
          '/LessonCategory2Word2Picture',
          list2: listSyllables,
          mainFieldType: FieldType.TITLE
      );
    }());

    listModules.add(() {
      String _title = "Número de Sílabas";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) => word.containsAudio && word.title.length < 10).toList(),
        '/ModuleSyllablesCount',
      );
    }());

    listModules.add(() {
      String _title = "Jogo da Forca";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listVocab.where((word) =>
        word.title.length == 4 && !(word.title.contains(RegExp(r'[çáãéêôóõú]'))))
            .toList(),
        '/UnitHangman',
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) => word.containsImage && word.containsAudio && word.title.length <= 5).toList(),
        '/ModulePicture2Words',
        optionFieldType: FieldType.TITLE,
        optionFontSize: 30,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS') + " (cursiva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) => word.containsImage && word.containsAudio && word.title.length <= 5).toList(),
        '/ModulePicture2Words',
        optionFieldType: FieldType.TITLE,
        optionFontSize: 40,
        fontFamily: "Maria_lucia",
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        alphabet,
        '/ModuleWord2Pictures',
        optionHeight: 150,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('SPELLING') + " 1";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) =>
          word.title.length == 6 &&
          !(word.title.contains(RegExp(r'[çáãéêôóõú]'))) &&
          (word.containsAudio) &&
          (word.containsImage)
        ).toList(),
        '/ModuleSpelling01',
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('SPELLING') + " 2";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        alphabet.where((word) =>
        word.title.length <= 6 &&
            !(word.title.contains(RegExp(r'[çáãéêôóõú]'))) &&
            (word.containsAudio) &&
            (word.containsImage)
        ).toList(),
        '/ModuleSpelling02',
      );
    }());

    listModules.add(() {
      String _title = "Letras (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listAlphabetSounds,
        '/ModuleBeforeAndAfter',
        optionFontSize: 50,
        mainFieldType: FieldType.VAL1,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listVocab.where((word) => word.containsImage && word.containsAudio && word.title.length <= 5).toList(),
        '/ModulePicture2Words',
        optionFieldType: FieldType.TITLE,
        optionFontSize: 30,
        sortCriteria: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        alphabet,
        '/ModuleWord2Pictures',
        optionHeight: 150,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('SPELLING') + " 1";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <= 6 && word.title.length > 3).toList(),
        '/ModuleSpelling01',
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('SPELLING') + ' 2';
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <= 6).toList(),
        '/ModuleSpelling02',
      );
    }());

    listModules.add(() {
      String _title = "Masculino / Feminino";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listGenderNumber,
          '/LessonWordPairs',
          mainFieldType: [0, 1]
      );
    }());

    listModules.add(() {
      String _title = "Singular / Plural";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listGenderNumber,
          '/LessonWordPairs',
          sortCriteria: null,
          mainFieldType: [0, 2]
      );
    }());

    listModules.add(() {
      String _title = "Gênero & Número";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listGenderNumber,
        '/ModuleGenderNumber',
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Português", listModules,  Image.asset('assets/icon/portuguese.png')));
  }

  void getYear2Mat() {
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "1 - 20 (extenso)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listNumber1t20,
        '/LessonWordAndWord',
        mainFieldType: FieldType.VAL1,
        optionFieldType: FieldType.TITLE,
        mainFontSize: 50,
        optionFontSize: 100,
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "1 - 20 (extenso)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber1t20,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "1 - 20 (extenso)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber1t20,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "Adição (2 casas)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath2.where((word) => word.title.contains("+")).toList(),
        '/ModuleExpressionEval',
        numberQuestions: 999,
        misc: 'v'
      );
    }());

    listModules.add(() {
      String _title = "Subtração (2 casas)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath2.where((word) => word.title.contains("-")).toList(),
        '/ModuleExpressionEval',
        numberQuestions: 999,
        misc: 'v'
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMath2,
        '/ModuleExpressionEval',
        numberQuestions: 10,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath2,
        '/ModuleExpressionEval',
        numberQuestions: 10,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "30 - 100 (extenso)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listNumber30t100,
        '/LessonWordAndWord',
        mainFieldType: FieldType.VAL1,
        optionFieldType: FieldType.TITLE,
        mainFontSize: 50,
        optionFontSize: 100,
      );
    }());

    listModules.add(() {
      String _title = "30 - 100 (extenso)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber30t100,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "30 - 100 (extenso)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber30t100,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "Par ou Ímpar";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          mapMatchOddEvenNumber,
          '/LessonCategory2Word2Picture',
          list2: listVocab,
          mainFieldType: FieldType.VAL1
      );
    }());

    listModules.add(() {
      String _title = "Par ou Ímpar?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listOddEvenNumbers,
        '/ModuleCategory2Option',
        list2: mapMatchOddEvenNumber,
        containsAudio: false,
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Par ou Ímpar?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listOddEvenNumbers,
        '/ModuleCategory2Option',
        list2: mapMatchOddEvenNumber,
        containsAudio: false,
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "1 - 10 (ordinais)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listNumber1t10Ordinal,
        '/LessonWordAndWord',
        mainFieldType: FieldType.VAL1,
        optionFieldType: FieldType.TITLE,
        mainFontSize: 50,
        optionFontSize: 100,
      );
    }());

    listModules.add(() {
      String _title = "1 - 10 (ordinais)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber1t10Ordinal,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "Jogo de Caça-Palavras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listNumber1t10Ordinal.where((word) => word.title.length <= 6).toList(),
        '/UnitWordSearch',
        noLock: true,
        useNavigation: false,
        useProgressBar: false,
      );
    }());

    listModules.add(() {
      String _title = "1 - 10 (ordinais)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber1t10Ordinal,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "20 - 100 (ordinais)";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listNumber20t100Ordinal,
          '/LessonWordAndWord',
          mainFieldType: FieldType.VAL1,
          optionFieldType: FieldType.TITLE,
          mainFontSize: 40,
          optionFontSize: 100,
          mainWidth: 300
      );
    }());

    listModules.add(() {
      String _title = "20 - 100 (ordinais)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber20t100Ordinal,
        '/ModuleNumbers2Word',
      );
    }());

    listModules.add(() {
      String _title = "20 - 100 (ordinais)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber20t100Ordinal,
        '/ModuleNumbers2Word',
      );
    }());

    debugPrint("************* populate add 2");

    listModules.add(() {
      String _title = "Adição (2 casas com reserva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath4.where((word) => word.title.contains("+")).toList(),
        '/ModuleExpressionEval',
        numberQuestions: 999,
        misc: 'v'
      );
    }());

    debugPrint("************* populate sub 2");

    listModules.add(() {
      String _title = "Subtração (2 casas com reserva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath4.where((word) => word.title.contains("-")).toList(),
        '/ModuleExpressionEval',
        numberQuestions: 999,
        misc: 'v'
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMath4,
        '/ModuleExpressionEval',
        numberQuestions: 10,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath4,
        '/ModuleExpressionEval',
        numberQuestions: 10,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Matemática", listModules,  Image.asset('assets/icon/maths.png')));
  }

  void getYear2Sci() {
    Yr _year = Yr.TWO;
    Sub _subject = Sub.SCIENCE;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "Esquerda / Direita";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listDirections,
        '/LessonWordsAndPicture',
      );
    }());

    listModules.add(() {
      String _title = "Esquerda ou Direita?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listDirections,
        '/ModuleLeftRight',
        numberQuestions: 10,
        optionHeight: 200,
      );
    }());

    listModules.add(() {
      String _title = "Esquerda ou Direita?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listDirections,
        '/ModuleLeftRight',
        numberQuestions: 10,
        optionHeight: 200,
      );
    }());

    listModules.add(() {
      String _title = "Dias da Semana";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listDaysOfTheWeek,
        '/LessonWords',
        mainFontSize: 40,
      );
    }());

    listModules.add(() {
      String _title = "Dias da Semana (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listDaysOfTheWeek,
        '/ModuleBeforeAndAfter',
        optionFontSize: 25,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Dias da Semana (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listDaysOfTheWeek,
        '/ModuleBeforeAndAfter',
        optionFontSize: 25,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Meses do Ano";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMonthsOfTheYear,
        '/LessonWordAndWord',
        numberQuestions: 999,
//      loop:true,
      );
    }());

    listModules.add(() {
      String _title = "Número do Mês";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.EXERCISE,
          _year,
          _subject,
          listMonthsOfTheYear,
          '/ModuleWord2Numbers',
          mainFieldType: FieldType.TITLE,
          optionFieldType: FieldType.VAL1,
          mainFontSize: 50,
          optionFontSize: 50,
          mainFontColor: Colors.red
      );
    }());

    listModules.add(() {
      String _title = "Meses do Ano (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMonthsOfTheYear,
        '/ModuleBeforeAndAfter',
        optionFontSize: 25,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Meses do Ano (Antes e Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMonthsOfTheYear,
        '/ModuleBeforeAndAfter',
        optionFontSize: 25,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Estações do Ano";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listSeasonsOfTheYear,
        '/LessonWordsAndPicture',
//      loop:true,
      );
    }());

    listModules.add(() {
      String _title = "Estações do Ano (Antes & Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listSeasonsOfTheYear,
        '/ModuleBeforeAndAfter',
        optionFontSize: 25,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Estações do Ano (Antes & Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listSeasonsOfTheYear,
        '/ModuleBeforeAndAfter',
        optionFontSize: 25,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Relógio Análogo (horas)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listTimeLessonHour,
        '/LessonClock',
//      loop:true,
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Relógio Análogo (minutos)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listTimeLessonMinutes,
        '/LessonClock',
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Relógio: Análogo & Digital";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        [],
        '/LessonClockDigital',
        useNavigation: false,
        noLock: true,
      );
    }());

    listModules.add(() {
      String _title = "Que horas são?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listTimeTest,
        '/ModuleClock',
      );
    }());

    listModules.add(() {
      String _title = "Que horas são?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listTimeTest,
        '/ModuleClock',
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Ciências", listModules,  Image.asset('assets/icon/science.png')));
  }

  void getYear3Por() {
    Yr _year = Yr.THREE;
    Sub _subject = Sub.PORTUGUESE;
    List<Subject> listSubjects = [];
    List<Module> listModules = [];

    Year year = Year(
        _year,
        "3º Ano",
        Colors.blue.shade200,
        listSubjects);

    listYears.add(year);
    expandedId.add(_subject.index);

    listModules.add(() {
      String _title = "Sílaba Tônica";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        // do not include single syllable words
        // queijo & xadrez have syllables that are too long
        listVocab.where((word) =>
        word.containsAudio &&
        word.val1
            .split('-')
            .length > 1 &&
            word.title != 'queijo' &&
            word.title != 'xadrez').toList(),
        '/LessonTonic',
        numberQuestions: 20,
        mainFontSize: 40,
        optionFontSize: 50,
        mainWidth: 100,
        sortCriteria: FieldType.TITLE,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Sílaba Tônica?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        // do not include single syllable words
        // queijo & xadrez have syllables that are too long
        listVocab.where((word) =>
        word.containsAudio &&
        word.val1
            .split('-')
            .length == 4 &&
            word.containsAudio &&
            word.title != 'queijo' &&
            word.title != 'xadrez').toList(),
        '/ModuleTonicSyllable',
        numberQuestions: 20,
        mainFontSize: 40,
        optionFontSize: 50,
        mainWidth: 120,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Sílaba Tônica?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        // do not include single syllable words
        // queijo & xadrez have syllables that are too long
        listVocab.where((word) =>
        word.containsAudio &&
        word.val1
            .split('-')
            .length == 4 &&
            word.title != 'queijo' &&
            word.title != 'xadrez').toList(),
        '/ModuleTonicSyllable',
        numberQuestions: 20,
        mainFontSize: 40,
        optionFontSize: 50,
        mainWidth: 120,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Oxítona";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        // do not include single syllable words
        // queijo & xadrez have syllables that are too long
        listVocab.where((word) =>
            word.val1.split('-').length > 1 &&
            word.val1.split('-').length < 4 &&
            word.title != 'queijo' &&
            word.title != 'xadrez' &&
            word.containsAudio &&
            word.val1.split('-').length == int.parse(word.val2) // oxítona
        ).toList(),
        '/LessonTonic',
        numberQuestions: 30,
        mainFontSize: 40,
        optionFontSize: 50,
        mainWidth: 100,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Paroxítona";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        // do not include single syllable words
        // queijo & xadrez have syllables that are too long
        listVocab.where((word) =>
        word.val1.split('-').length == 3 &&
            word.title != 'queijo' &&
            word.title != 'xadrez' &&
            word.containsAudio &&
            word.val1
                .split('-')
                .length - 1 == int.parse(word.val2)
        ).toList(),
        '/LessonTonic',
        numberQuestions: 30,
        mainFontSize: 40,
        optionFontSize: 50,
        mainWidth: 100,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Proparoxítona";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        // do not include single syllable words
        // queijo & xadrez have syllables that are too long
        listVocab.where((word) =>
        (word).val1
            .split('-')
            .length > 1 &&
            word.title != 'queijo' &&
            word.title != 'xadrez' &&
            word.val1
                .split('-')
                .length - 2 == int.parse(word.val2)
        ).toList(),
        '/LessonTonic',
        numberQuestions: 30,
        mainFontSize: 40,
        optionFontSize: 50,
        mainWidth: 100,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Oxítona, Paroxítona ou Proparoxítona?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) =>
        word.containsAudio &&
        word.val1
            .split('-')
            .length > 2).toList(), // more than 3 syllables
        '/ModuleTonicOption',
        numberQuestions: 20,
        mainFontSize: 60,
        optionFontSize: 50,
        mainWidth: 120,
        optionWidth: 300,
        mainFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Oxítona, Paroxítona ou Proparoxítona?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listVocab.where((word) =>
          word.val1.split('-').length > 2 &&
          word.containsAudio
        ).toList(),
        '/ModuleTonicOption',
        numberQuestions: 20,
        mainFontSize: 60,
        optionFontSize: 50,
        mainWidth: 120,
        optionWidth: 300,
        mainFieldType: FieldType.VAL2,
        sortCriteria: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Palavras com CH, X";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listVocab.where((word) =>
            (word.title.contains('ch') ||
            word.title.contains('x')) &&
            word.title != 'taxi'
          ).toList(),
          '/LessonWords',
          misc: "ch|x",
          containsAudio: false,
          numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "CH ou X?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) =>
        (word.title.contains('ch') ||
            word.title.contains('x')) &&
            word.title != 'taxi'
        ).toList(),
        '/ModuleHomophone2Options',
        misc: "ch|x",
        containsAudio: false,
        numberQuestions: 999
      );
    }());

    listModules.add(() {
      String _title = "CH ou X?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listVocab.where((word) =>
        (word.title.contains('ch') ||
            word.title.contains('x')) &&
            word.title != 'taxi'
        ).toList(),
        '/ModuleHomophone2Options',
        misc: "ch|x",
        containsAudio: false,
        numberQuestions: 999
      );
    }());

    listModules.add(() {
      String _title = "Palavras com GE, JE";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listVocab.where((word) =>
        word.title.contains('ge') ||
            word.title.contains('je')
        ).toList(),
        '/LessonWords',
        misc: "ge|je",
        containsAudio: false,
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "GE ou JE?";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.EXERCISE,
          _year,
          _subject,
          listVocab.where((word) =>
          word.title.contains('ge') ||
              word.title.contains('je')
          ).toList(),
          '/ModuleHomophone2Options',
          misc: "ge|je",
          containsAudio: false,
          optionFontSize: 25,
          numberQuestions: 999
      );
    }());

    listModules.add(() {
      String _title = "GE ou JE?";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.TEST,
          _year,
          _subject,
          listVocab.where((word) =>
          word.title.contains('ge') ||
              word.title.contains('je')
          ).toList(),
          '/ModuleHomophone2Options',
          misc: "ge|je",
          containsAudio: false,
          numberQuestions: 999
      );
    }());

    listModules.add(() {
      String _title = "Palavras com GI, JI";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listVocab.where((word) =>
        word.title.contains('gi') ||
            word.title.contains('ji')
        ).toList(),
        '/LessonWords',
        misc: "gi|ji",
        containsAudio: false,
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "GI ou JI?";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.EXERCISE,
          _year,
          _subject,
          listVocab.where((word) =>
          word.title.contains('gi') ||
              word.title.contains('ji')
          ).toList(),
          '/ModuleHomophone2Options',
          misc: "gi|ji",
          containsAudio: false,
          numberQuestions: 999
      );
    }());

    listModules.add(() {
      String _title = "GI ou JI?";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.TEST,
          _year,
          _subject,
          listVocab.where((word) =>
          word.title.contains('gi') ||
              word.title.contains('ji')
          ).toList(),
          '/ModuleHomophone2Options',
          misc: "gi|ji",
          containsAudio: false,
          numberQuestions: 999
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Português", listModules,  Image.asset('assets/icon/portuguese.png')));
  }

  void getYear3Geo() {
    Yr _year = Yr.THREE;
    Sub _subject = Sub.GEOGRAPHY;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "Estados / Capitais";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listStateCapital,
        '/LessonWordAndWord',
        numberQuestions: 999,
        mainFontSize: 50,
        optionFontSize: 50,
        mainWidth: 300,
        mainFieldType: FieldType.VAL2,
        optionFieldType: FieldType.TITLE_VAL1,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Sigla?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listStateCapital,
        '/ModuleWord2Numbers',
        mainFontSize: 30,
        optionFontSize: 25,
        mainWidth: 300,
        mainHeight: 150,
        optionWidth: 150,
        mainFontColor: Colors.red,
        containsAudio: false,
        mainFieldType: FieldType.VAL1,
      );
    }());

    listModules.add(() {
      String _title = "Jogo da Memória";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listStateCapital,
        '/UnitMemoryGame',
        numberQuestions: 4,
        mainFieldType: FieldType.VAL2,
        mainFontSize: 15,
        optionFieldType: FieldType.TITLE,
        noLock: true,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Capital?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listStateCapital,
        '/ModuleWord2Numbers',
        mainFontSize: 30,
        optionFontSize: 25,
        mainWidth: 300,
        mainHeight: 150,
        optionWidth: 250,
        mainFontColor: Colors.red,
        containsAudio: false,
        mainFieldType: FieldType.TITLE,
        optionFieldType: FieldType.VAL2,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Sigla?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listStateCapital,
        '/ModuleWord2Numbers',
        mainFontSize: 30,
        optionFontSize: 25,
        mainWidth: 300,
        mainHeight: 150,
        optionWidth: 150,
        mainFontColor: Colors.red,
        containsAudio: false,
        mainFieldType: FieldType.VAL1,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Capital?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listStateCapital,
        '/ModuleWord2Numbers',
        mainFontSize: 30,
        optionFontSize: 25,
        mainWidth: 300,
        mainHeight: 150,
        optionWidth: 250,
        mainFontColor: Colors.red,
        containsAudio: false,
        mainFieldType: FieldType.TITLE,
        optionFieldType: FieldType.VAL2,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Geografia", listModules,  Image.asset('assets/icon/geography.png')));
  }

  void getYear3Sci() {
    Yr _year = Yr.THREE;
    Sub _subject = Sub.SCIENCE;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "Planetas";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listPlanets,
        '/LessonWordsAndPicture',
        containsAudio:  false,
      );
    }());

    listModules.add(() {
      String _title = "Jogo de Caça-Palavras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listPlanets,
        '/UnitWordSearch',
        noLock: true,
        useNavigation: false,
        useProgressBar: false,
        misc: true,
      );
    }());

    listModules.add(() {
      String _title = "Planetas (Antes & Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listPlanets,
        '/ModuleBeforeAndAfter',
        containsAudio:  false,
        optionFontSize: 20,
        optionWidth: 160,
        mainFontSize: 40,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Planetas (Antes & Depois)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listPlanets,
        '/ModuleBeforeAndAfter',
        containsAudio:  false,
        optionWidth: 160,
        optionFontSize: 20,
        mainFieldType: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = "Animais Vertebrados";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          mapMatchVertebrateAnimal,
          '/LessonCategory2Word2Picture',
          list2: listVocab,
          mainFieldType: FieldType.TITLE
      );
    }());

    listModules.add(() {
      String _title = "Jogo da Forca";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listAnimals.where((word) =>
        word.title.length <= 4 && !(word.title.contains(RegExp(r'[çáãéêôóõú]'))))
            .toList(),
        '/UnitHangman',
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Classificação?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listAnimals,
        '/ModuleCategoryOption',
        list2: mapMatchVertebrateAnimal,
        containsAudio: false,
        numberQuestions: 999,
        optionFontSize: 20,
        optionWidth: 180,
      );
    }());

    listModules.add(() {
      String _title = "Qual é a Classificação?";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listAnimals,
        '/ModuleCategoryOption',
        list2: mapMatchVertebrateAnimal,
        containsAudio: false,
        numberQuestions: 999,
        optionFontSize: 20,
        optionWidth: 180,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Ciências", listModules, Image.asset('assets/icon/science.png')));
  }

  void getYear3Math() {
    Yr _year = Yr.THREE;
    Sub _subject = Sub.MATH;
    List<Module> listModules = [];

    listModules.add(() {
      String _title = "Tabuada da Multiplicação";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listTimesTableBase,
        '/LessonTableMult',
        containsAudio:  false,
      );
    }());

    listModules.add(() {
      String _title = "Tabuada 1";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listTimesTableBase,
        '/ModuleTimesTable',
        containsAudio:  false,
      );
    }());

    listModules.add(() {
      String _title = "Tabuada 2";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMath3, // endless exercise
        '/ModuleExpressionEval',
        numberQuestions: 20,
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath3,
        '/ModuleExpressionEval',
        numberQuestions: 20,
      );
    }());

    listModules.add(() {
      String _title = "Multiplicação (2 casas sem reserva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath5,
        '/ModuleExpressionEval',
        numberQuestions: 999, // show all
      );
    }());

    listModules.add(() {
      String _title = "Multiplicação sem reserva";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMath5,
        '/ModuleExpressionEval',
        numberQuestions: 20,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "Multiplicação sem reserva";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath5,
        '/ModuleExpressionEval',
        numberQuestions: 20,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "Multiplicação (2 casas com reserva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath6,
        '/ModuleExpressionEval',
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Multiplicação com reserva";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listMath6,
        '/ModuleExpressionEval',
        numberQuestions: 10,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "Multiplicação com reserva";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath6,
        '/ModuleExpressionEval',
        numberQuestions: 20,
        misc: 'v',
        mainFontSize: 90,
      );
    }());

    listModules.add(() {
      String _title = "Tabuada da Divisão";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listTimesTableBase,
        '/LessonTableDiv',
        containsAudio:  false,
      );
    }());

    listModules.add(() {
      String _title = "Divisão Simples";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listMath7,
        '/ModuleExpressionEval',
        numberQuestions: 999,
      );
    }());

    listModules.add(() {
      String _title = "Calcule";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listMath7,
        '/ModuleExpressionEval',
        numberQuestions: 20,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Matemática", listModules, Image.asset('assets/icon/maths.png')));
  }

  Future<bool> AssetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      printDebug("ERROR: $e");
      return false;
    }
  }

  Icon? getLockIcon(bool isModuleLocked) {
    if (!isModuleLocked) return null;
    return Icon(
      Icons.lock_rounded,
      color: Colors.white,
    );
  }

  TextStyle getModuleStyle(unlock) {
    return TextStyle(
        fontSize: 20,
        color: !unlock ? Colors.white : Colors.grey[350]
    );
  }

  Icon getIcon(ModuleType type) {
    int code;
    Color color;
    switch (type) {
      case ModuleType.LESSON:
        code = 59404;
        color = Colors.blue.shade700;
        break;
      case ModuleType.EXERCISE:
        code = 58740;
        color = Colors.yellow.shade200;
        break;
      case ModuleType.TEST:
        code = 59485;
        color = Colors.red.shade200;
        break;
      case ModuleType.REPORT:
        code = 59484;
        color = Colors.white;
        break;
      case ModuleType.GAME:
        code = 59944;
        color = Colors.white;
        break;
    }
    return Icon(
      IconData(code, fontFamily: 'LiteraIcons'),
      color: color,
    );
  }

  String getAssetsVocab(String key) {
    return _assetsConfig['CONFIG']['VOCABULARY'][getNavigationLanguage()][key];
  }

  int getNavigationLanguage() {
    navigationLanguage = 2;
    return navigationLanguage; // portuguese as default
  }

  Widget getClock(String time, [double padding = 8.0]) {
    Globals().printDebug("Time: $time");
    int hr = int.parse(time.substring(0, 2));
    int mn = int.parse(time.substring(3, 5));
    return Padding(
      padding: EdgeInsets.all(padding),
      child: AnalogClock(
        decoration: BoxDecoration(
            border: Border.all(width: 5.0, color: Colors.blue),
            color: Colors.white,
            shape: BoxShape.circle),
        isLive: false,
        hourHandColor: Colors.deepOrange,
        minuteHandColor: Colors.teal,
        showSecondHand: false,
        numberColor: Colors.blue,
        showNumbers: true,
        showAllNumbers: true,
        textScaleFactor: 1.0,
        showTicks: false,
        showDigitalClock: false,
        datetime: DateTime(2019, 1, 1, hr, mn, 00),
      ),
    );
  }

  Future<SharedPreferences> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  printDebug(String text) {
    if (debugMode) print(text);
  }

  int getUnlockModuleIndex(int _year, int _subject) {
    return prefs.getInt('unlockModuleIndex-$_year-$_subject') ?? 0;
  }

  setUnlockModuleIndex(int newIndex, [int? _year, int? _subject]) async {
    await prefs.setInt('unlockModuleIndex-$_year-$_subject', newIndex);
  }

  printList(Object list) {
    Globals().printDebug("**************** PRINT LIST START *******************");
    Globals().printDebug("object type: " + list.runtimeType.toString());
    if (list is List<int>) {
      Globals().printDebug("List of elements: " + list.length.toString());
      list.forEach((element) {
          Globals().printDebug("element $element");
      });
    }
    try {
      Globals().printDebug("try");
      if (list is List<Object>) {
        Globals().printDebug("try is List<Word>");
        int i = 0;
        list.forEach((element) {
          Globals().printDebug("$i. element " + (element as Word).id.toString() + ": " + element.title);
          i++;
        });
      }
    } catch (e) {
      Globals().printDebug("Error: $e");
    }
    if (list is Set<int>) {
      list.forEach((element) {
          Globals().printDebug("element $element");
      });
    }
    Globals().printDebug("**************** PRINT LIST END *******************");
  }

  String getLabelFromFieldType(Word word, fieldTypeObject) {
    String label = '';
    switch (fieldTypeObject) {
      case FieldType.ID:
        label = word.id.toString();
        break;
      case FieldType.TITLE:
        label = word.title;
        break;
      case FieldType.VAL1:
        label = word.val1;
        break;
      case FieldType.VAL2:
        label = word.val2;
        break;
      case FieldType.VAL3:
        label = word.val3;
        break;
      case FieldType.TITLE_ID:
        label = word.title + "\n(" + word.id.toString() + ")";
        break;
      case FieldType.TITLE_VAL1:
        label = word.title + "\n(" + word.val1 + ")";
        break;
      case FieldType.TITLE_VAL2:
        label = word.title + "\n(" + word.val2 + ")";
        break;
      default:
        label = word.title;
    }
    return label;
  }

  Word getWordFromId(int id) {
    return Globals().listVocab.singleWhere((word) => (word).id == id);
  }

  Word getWordFromField(List list, FieldType fieldType, String val) {
    switch (fieldType) {
      default:
        return list.singleWhere((word) => (word).val1 == val);
    }
  }

  Word getCategoryFromId(List category, int id) {
    Globals().printDebug("getCategoryFromId: $id");
    return category.singleWhere((word) => (word).id == id);
  }

  ButtonStyle buttonStyle({Color backgroundColor=Colors.white, Color borderColor=Colors.blue, double borderWidth=5.0}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      disabledBackgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
          )
      ),
    );
  }

}