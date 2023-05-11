import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:analog_clock/analog_clock.dart';

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

enum Sub {
  PORTUGUESE,
  MATH,
  SCIENCE,
  GEOGRAPHY,
}

enum Yr {
  ONE,
  TWO,
  THREE,
}

class Globals {
  static final Globals _singleton = Globals._internal();

  factory Globals() {
    return _singleton;
  }

  Globals._internal();

  late String appOralLanguage;
  late String appTitle;
  late String devName;
  late String devEmail;

  late int navigationLanguage;

  late String buildNumber;
  late String version;

  List<MapEntry> settingsNavigationLanguage = [];
  late Map<String, dynamic> _assetsConfig;

  Color? appBarColorLight = Colors.teal[200];
  Color appBarColor = Colors.teal;
  Color? appBarColorDark = Colors.teal[800];

  Color? menuColorLight = Colors.teal[200];
  Color menuColor = Colors.teal;
  Color? menuColorDark = Colors.teal[800];

  bool debugMode = true;

  late List<Word> alphabet;
  late List<Word> syllableUnique;
  late List<Word> listWordOnset;
  late List<Word> listVowels;
  late List<Word> listAlphabet;
  late List<Word> listNumber1t20;
  late List<Word> listNumber30t100;
  late List<Word> listNumber1t10Ordinal;
  late List<Word> listNumber20t100Ordinal;
  late List<Word> listVocab;
  late List<Word> listAnimals;
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
    'Masculino/ Singular',
    'Feminino/ Singular',
    'Masculino/ Plural',
    'Feminino/ Plural',
  ];

  List<Year> listYears = [];

  Future init() async {
    printDebug("******** init");

    prefs = await SharedPreferences.getInstance();

    alphabet = [];
    syllableUnique = [];
    listWordOnset = [];
    listSyllables = [];
    listVowels = [];
    listAlphabet = [];
    listVocab = [];
    listAnimals = [];
    listNumber1t20 = [];
    listNumber30t100 = [];
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
    listStateCapital = [];

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

    printDebug("******** init 4.3");
    getYear2Por();
    printDebug("******** init 4.4");
    getYear2Mat();
    getYear2Sci();

    getYear3Por();
    getYear3Geo();
    getYear3Sci();

    printDebug("******** init 5");
    expandedId.asMap().forEach((index, value) =>
    prefs.getInt("expandedId-$index") ?? Sub.PORTUGUESE.index);
    printDebug("******** init 6");
    print("expandedId-0: " + expandedId[0].toString());
    print("expandedId-1: " + expandedId[1].toString());

    percentUnlock = prefs.getString('percentUnlock') ?? percentUnlock;

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

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    // populate vocab list
    List<dynamic> listKeys = parsedWords['LIST']['CATEGORY']['VOCABULARY'].keys.toList();
    print("key count: " + listKeys.length.toString());
    for (int id=0; id<listKeys.length; id++) {
      printDebug("******** populate 3.1: $id");
      var key = listKeys[id];
      printDebug("******** populate 3.2");
      print("key $key");
      List listElement = parsedWords['LIST']['CATEGORY']['VOCABULARY']["$key"];
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
      print("$id contains audio: " + word.containsAudio.toString());
      print("$id contains image: " + word.containsImage.toString());
      listVocab.add(word);
      print("word added to listVocab");
      printDebug("******** populate 4");
    }

    // populate vocab list
    parsedWords['LIST']['CATEGORY']['DAYS-OF-THE-WEEK'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['DAYS-OF-THE-WEEK'][key];
      Word word = Word(id, title);
      listDaysOfTheWeek.add(word);
    });

    // populate vocab list
    parsedWords['LIST']['CATEGORY']['DIRECTIONS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['DIRECTIONS'][key];
      Word word = Word(id, title);
      listDirections.add(word);
    });

    // populate vocab list
    parsedWords['LIST']['CATEGORY']['MONTHS-OF-THE-YEAR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['MONTHS-OF-THE-YEAR'][key];
      Word word = Word(id, title, (id - 3600).toString());
      listMonthsOfTheYear.add(word);
    });

    printDebug("******** populate 5");

    parsedWords['LIST']['CATEGORY']['SEASONS-OF-THE-YEAR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['SEASONS-OF-THE-YEAR'][key];
      Word word = Word(id, title);
      listSeasonsOfTheYear.add(word);
    });

    parsedWords['LIST']['CATEGORY']['PLANETS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['PLANETS'][key];
      Word word = Word(id, title);
      word.val1 = title;
      listPlanets.add(word);
    });

    printDebug("******** populate 6");

    parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'].keys.forEach((key1) {
      List<Word> listWord = [];
      parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'][key1]
          .asMap()
          .keys
          .forEach((key2) {
        parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'][key1][key2].keys
            .forEach((key3) {
          int id = int.parse(key3);
          String title = parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'][key1][key2][key3]
              .toString();
          listWord.add(Word(id, title, key2.toString()));
        });
      });
      print("List length: " + listWord.length.toString());
      listGenderNumber.add(listWord);
    });

    printDebug("******** populate 7");

    parsedWords['LIST']['CATEGORY']['ALPHABET'].forEach((key) {
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

    parsedWords['LIST']['CATEGORY']['SYLLABLE-UNIQUE'].forEach((key) {
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

    printDebug("******** populate 4");

    // populate vowel list
    parsedWords['LIST']['CATEGORY']['ALPHABET-VOWELS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ALPHABET-VOWELS'][key];
      Word word = Word(id, title);
      listVowels.add(word);
    });

    // populate vowel list
    parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'][key];
      Word word = Word(id, title);
      listAlphabet.add(word);
    });

    printDebug("******** populate 5");

    // populate number list
    parsedWords['LIST']['CATEGORY']['NUMBERS_1-20'].keys.forEach((key) {
      int id = int.parse(key);
      printDebug('key: ' + key);
      parsedWords['LIST']['CATEGORY']['NUMBERS_1-20'][id.toString()].keys
          .forEach((value) {
        printDebug('value: ' + value);
        String title = parsedWords['LIST']['CATEGORY']['NUMBERS_1-20'][id
            .toString()][value];
        printDebug('title: ' + title);
        Word word = Word(id, title);
        word.val1 = value;
        word.val2 = key;
        listNumber1t20.add(word);
      });
    });

    parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'][id.toString()].keys
          .forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listNumber30t100.add(word);
      });
    });

    parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'][id.toString()]
          .keys.forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listNumber1t10Ordinal.add(word);
      });
    });

    parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'].keys.forEach((
        key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'][id.toString()]
          .keys.forEach((value) {
        //printDebug('value: ' + value);
        String title = parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'][id
            .toString()][value];
        //printDebug('title: ' + title);
        Word word = Word(id, title, value);
        listNumber20t100Ordinal.add(word);
      });
    });

    printDebug("******** populate 6");

    // populate alphabet onset
    parsedWords['LIST']['CATEGORY']['ALPHABET-ONSET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ALPHABET-ONSET'][key];
      Word word = Word(id, title);
      alphabetOnsetList.add(word);
    });

    // populate alphabet onset
    parsedWords['LIST']['CATEGORY']['ALPHABET-LETTER-SOUND'].keys.forEach((
        key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ALPHABET-LETTER-SOUND'][key];
      Word word = Word(id, title, title);
      listAlphabetSounds.add(word);
    });

    // populate letter onset
    parsedWords['LIST']['CATEGORY']['LETTER-ONSET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['LETTER-ONSET'][key];
      Word word = Word(id, title);
      letterOnsetList.add(word);
    });

    // populate wo alphabet list
    parsedWords['LIST']['CATEGORY']['LIST-ONSET-CONSONANTS'].keys.forEach((
        key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['LIST-ONSET-CONSONANTS'][key];
      Word word = Word(id, title);
      listOnsetConsonants.add(word);
    });

    // populate alphabet list
    parsedWords['LIST']['CATEGORY']['MATCH-CASE'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['MATCH-CASE'][key];
      Word word = Word(id, title);
      lettersMatchCase.add(word);
    });

    printDebug("******** populate 7");

    // populate number order list
    parsedWords['LIST']['CATEGORY']['ORDER-NUMBERS_1-10'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ORDER-NUMBERS_1-10'][key];
      Word word = Word(id, title);
      valOrderNumbers.add(word);
    });

    // populate vowel order list
    parsedWords['LIST']['CATEGORY']['ORDER-VOWELS'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ORDER-VOWELS'][key];
      Word word = Word(id, title);
      valOrderVowels.add(word);
    });

    // populate alphabet order list
    parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'][key];
      Word word = Word(id, title);
      valOrderAlphabet.add(word);
    });

    // populate word list
    parsedWords['LIST']['CATEGORY']['LIST-SYLLABLES'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['LIST-SYLLABLES'][key];
      Word word = Word(id, title);
      listSyllables.add(word);
    });

    parsedWords['LIST']['CATEGORY']['TIME-LESSON-HOUR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['TIME-LESSON-HOUR'][key];
      Word word = Word(id, title);
      listTimeLessonHour.add(word);
    });

    parsedWords['LIST']['CATEGORY']['TIME-LESSON-MINUTES'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['TIME-LESSON-MINUTES'][key];
      Word word = Word(id, title);
      listTimeLessonMinutes.add(word);
    });

    parsedWords['LIST']['CATEGORY']['TIME-HOUR'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['TIME-HOUR'][key];
      Word word = Word(id, title);
      listTimeHour.add(word);
    });

    parsedWords['LIST']['CATEGORY']['TIME-MINUTES'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['TIME-MINUTES'][key];
      Word word = Word(id, title);
      listTimeMinutes.add(word);
    });

    parsedWords['LIST']['CATEGORY']['TIME-TEST'].keys.forEach((key) {
      int id = int.parse(key);
      String title = parsedWords['LIST']['CATEGORY']['TIME-TEST'][key];
      Word word = Word(id, title);
      listTimeTest.add(word);
    });

    printDebug("******** populate 8");

    parsedWords['LIST']['CATEGORY']['SYLLABLE-MATCH'].forEach((key) {
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

    parsedWords['LIST']['CATEGORY']['WORD-MATCH'].forEach((key) {
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

    parsedWords['LIST']['CATEGORY']['VERTEBRATE-ANIMAL-MATCH'].forEach((key) {
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

    printDebug("******** populate 9");
    parsedWords['LIST']['CATEGORY']['WORD-ONSET'].forEach((key) {
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

    parsedWords['LIST']['CATEGORY']['STATE-CAPITAL'].keys.forEach((key) {
      int id = int.parse(key);
      //printDebug('key: ' + key);
      List listWords = parsedWords['LIST']['CATEGORY']['STATE-CAPITAL'][key];
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
        listSubjects);
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
    listModules.add(() {
      String _title = "Alfabeto (Letras)";
      int _modulePos = listModules.length;
      return Module(
          _modulePos,
          _title,
          ModuleType.LESSON,
          _year,
          _subject,
          listAlphabetSounds,
          '/LessonAlphabetLetters',
          numberQuestions: 26
      );
    }());
    listModules.add(() {
      String _title = "Vogais";
      print("length: " + listModules.length.toString());
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
        fontSizeOption: 40,
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
      String _title = "Caça-Palavras";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <= 6).toList(),
        '/LessonWordSearch',
        noLock: true,
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
        '/LessonCategory2Words',
        noLock: true,
        list2: listSyllables,
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
        Subject(_subject, "Português", listModules));
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
        fontSizeOption: 40,
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
        fontSizeOption: 40,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Matemática", listModules));
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
        fontSizeOption: 50,
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
        widthOption: 100,
        heightOption: 100
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
        word.title.length <= 4 && !(word.title.contains(RegExp(r'[çéáúãóõ]'))))
            .toList(),
        '/LessonWord2Onsets',
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
          fieldTypeMain: FieldType.VAL1
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
          '/LessonWordsConsonantsVowels',
          list2: listSyllables,
          fieldTypeMain: FieldType.TITLE
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
        listVocab.where((word) => word.title.length < 10).toList(),
        '/ModuleSyllablesCount',
      );
    }());

    listModules.add(() {
      String _title = "Forca";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.GAME,
        _year,
        _subject,
        listVocab.where((word) =>
        word.title.length <= 4 && !(word.title.contains(RegExp(r'[çéáúãóõ]'))))
            .toList(),
        '/LessonHangman',
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " +
          getAssetsVocab('WORDS');
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) => word.title.length <= 5).toList(),
        '/ModulePicture2Words',
        fieldTypeOption: FieldType.TITLE,
      );
    }());

    listModules.add(() {
      String _title = getAssetsVocab('PICTURE') + " / " +
          getAssetsVocab('WORDS') + " (cursiva)";
      int _modulePos = listModules.length;
      return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listVocab.where((word) => word.title.length <= 5).toList(),
        '/ModulePicture2Words',
        fieldTypeOption: FieldType.TITLE,
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
        heightOption: 150,
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
        word.title.length > 3 && word.title.length <= 6 &&
            !(word.title.contains(RegExp(r'[çéáúãóõ]')))).toList(),
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
        word.title.length <= 6 && !(word.title.contains(RegExp(r'[çéáúãóõ]'))))
            .toList(),
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
        fontSizeOption: 50,
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
        fieldTypeOption: FieldType.TITLE,
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
        heightOption: 150,
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
        alphabet.where((word) =>
        word.title.length <= 6 && word.title.length > 3).toList(),
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
          fieldTypeMain: [0, 1]
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
          fieldTypeMain: [0, 2]
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
        Subject(_subject, "Português", listModules));
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
        fieldTypeMain: FieldType.VAL1,
        fieldTypeOption: FieldType.TITLE,
        fontSizeMain: 50,
        fontSizeOption: 100,
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
        fieldTypeMain: FieldType.VAL1,
        fieldTypeOption: FieldType.TITLE,
        fontSizeMain: 50,
        fontSizeOption: 100,
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
        fieldTypeMain: FieldType.VAL1,
        fieldTypeOption: FieldType.TITLE,
        fontSizeMain: 50,
        fontSizeOption: 100,
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
          fieldTypeMain: FieldType.VAL1,
          fieldTypeOption: FieldType.TITLE,
          fontSizeMain: 40,
          fontSizeOption: 100,
          widthMain: 300
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

    listYears[_year.index].subjects.add(
        Subject(_subject, "Matemática", listModules));
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
      String _title = "Esquerda / Direita";
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
        heightOption: 200,
      );
    }());

    listModules.add(() {
      String _title = "Esquerda / Direita";
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
        heightOption: 200,
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
//      loop:true,
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
        fontSizeOption: 25,
        fieldTypeOption: FieldType.VAL1,
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
        fontSizeOption: 25,
        fieldTypeOption: FieldType.VAL1,
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
          fieldTypeMain: FieldType.TITLE,
          fieldTypeOption: FieldType.VAL1,
          fontSizeMain: 50,
          fontSizeOption: 50,
          colorMain: Colors.red
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
        fontSizeOption: 25,
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
        fontSizeOption: 25,
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
        fontSizeOption: 30,
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
        fontSizeOption: 30,
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
        Subject(_subject, "Ciências", listModules));
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
        numberQuestions: 30,
        fontSizeMain: 60,
        fontSizeOption: 50,
        widthMain: 120,
        sortCriteria: FieldType.TITLE,
        fieldTypeMain: FieldType.VAL2,
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
        fontSizeMain: 40,
        fontSizeOption: 50,
        widthMain: 120,
        fieldTypeMain: FieldType.VAL2,
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
        fontSizeMain: 40,
        fontSizeOption: 50,
        widthMain: 120,
        fieldTypeMain: FieldType.VAL2,
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
            word.val1.split('-').length == int.parse(word.val2)
        ).toList(),
        '/LessonTonic',
        numberQuestions: 30,
        fontSizeMain: 60,
        fontSizeOption: 50,
        widthMain: 150,
        fieldTypeMain: FieldType.VAL2,
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
        fontSizeMain: 60,
        fontSizeOption: 50,
        widthMain: 120,
        fieldTypeMain: FieldType.VAL2,
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
        fontSizeMain: 60,
        fontSizeOption: 50,
        widthMain: 120,
        fieldTypeMain: FieldType.VAL2,
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
            .length > 2).toList(),
        '/ModuleTonicOption',
        numberQuestions: 20,
        fontSizeMain: 60,
        fontSizeOption: 50,
        widthMain: 120,
        widthOption: 300,
        fieldTypeMain: FieldType.VAL2,
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
        fontSizeMain: 60,
        fontSizeOption: 50,
        widthMain: 120,
        widthOption: 300,
        fieldTypeMain: FieldType.VAL2,
        sortCriteria: FieldType.TITLE,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Português", listModules));
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
        fontSizeMain: 50,
        fontSizeOption: 50,
        widthMain: 300,
        fieldTypeMain: FieldType.VAL2,
        fieldTypeOption: FieldType.TITLE_VAL1,
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
        fontSizeMain: 40,
        fontSizeOption: 30,
        widthMain: 300,
        heightMain: 150,
        widthOption: 150,
        colorMain: Colors.red,
        containsAudio: false,
        fieldTypeMain: FieldType.VAL1,
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
        fontSizeMain: 40,
        fontSizeOption: 30,
        widthMain: 300,
        heightMain: 150,
        widthOption: 250,
        colorMain: Colors.red,
        containsAudio: false,
        fieldTypeMain: FieldType.TITLE,
        fieldTypeOption: FieldType.VAL2,
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
        fontSizeMain: 40,
        fontSizeOption: 30,
        widthMain: 300,
        heightMain: 150,
        widthOption: 150,
        colorMain: Colors.red,
        containsAudio: false,
        fieldTypeMain: FieldType.VAL1,
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
        fontSizeMain: 40,
        fontSizeOption: 30,
        widthMain: 300,
        heightMain: 150,
        widthOption: 250,
        colorMain: Colors.red,
        containsAudio: false,
        fieldTypeMain: FieldType.TITLE,
        fieldTypeOption: FieldType.VAL2,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Geografia", listModules));
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
        fontSizeOption: 30,
        fontSizeMain: 40,
        fieldTypeMain: FieldType.TITLE,
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
        fontSizeOption: 30,
        fieldTypeMain: FieldType.TITLE,
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
          '/LessonWordsConsonantsVowels',
          list2: listVocab,
          fieldTypeMain: FieldType.TITLE
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
        containsAudio: false,
        numberQuestions: 999,
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
        containsAudio: false,
        numberQuestions: 10,
        sortCriteria: FieldType.TITLE,
      );
    }());

    listYears[_year.index].subjects.add(
        Subject(_subject, "Ciências", listModules));
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
      IconData(59545, fontFamily: 'LiteraIcons'),
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
        color = Colors.blue.shade500;
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
    print("Time: $time");
    int hr = int.parse(time.substring(0, 2));
    int mn = int.parse(time.substring(3, 5));
    return Padding(
      padding: EdgeInsets.all(padding),
      child: AnalogClock(
        decoration: BoxDecoration(
            border: Border.all(width: 10.0, color: Colors.teal),
            color: Colors.transparent,
            shape: BoxShape.circle),
        isLive: false,
        hourHandColor: Colors.deepOrange,
        minuteHandColor: Colors.black,
        showSecondHand: false,
        numberColor: Colors.teal,
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
    print("**************** PRINT LIST START *******************");
    print("object type: " + list.runtimeType.toString());
    if (list is List<int>) {
      print("List of elements: " + list.length.toString());
      list.forEach((element) {
          print("element $element");
      });
    }
    if (list is List<Word>) {
      int i = 0;
      list.forEach((element) {
        print("$i. element " + element.id.toString() + ": " + element.title +
            " cat: " + (getWordFromId(int.parse(element.val3))).title);
        i++;
      });
    }
    if (list is Set<int>) {
      list.forEach((element) {
          print("element $element");
      });
    }
    print("**************** PRINT LIST END *******************");
  }

  Word getWordFromId(int id) {
    return Globals().listVocab.singleWhere((word) => (word).id == id);
  }

  Word getCategoryFromId(List category, int id) {
    return category.singleWhere((word) => (word).id == id);
  }


}