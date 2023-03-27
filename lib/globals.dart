library globals;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:litera/word.dart';
import 'package:litera/module.dart';
import 'package:litera/subject.dart';
import 'package:litera/year.dart';

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
late List<Word> alphabetOnsetList;
late List<Word> letterOnsetList;
late List<Word> listOnsetConsonants; // list of alphabet letters used for onset lesson
late List<Word> lettersMatchCase;
late List<Word> valOrderNumbers;
late List<Word> valOrderVowels;
late List<Word> valOrderAlphabet;
late List<Word> listSyllables;
late List<Map<String, List<Word>>> mapSyllableMatch;
late List<Map<String, List<Word>>> mapWordMatch;

late Map<String, dynamic> parsedWords;

AudioPlayer audioPlayer = AudioPlayer();
Timer? t1,t2,t3 = Timer(Duration(seconds: 1), () {});

late Widget adWidget;

//index 0 = year 1; index 1 = year 2;
List<int> expandedId = [Sub.PORTUGUESE.index, Sub.PORTUGUESE.index];

late SharedPreferences prefs;

Future<Map<String, dynamic>> getConfigAssets() async {
  return _assetsConfig;
}

enum ModuleType {
  LESSON,
  EXERCISE,
  TEST,
  REPORT
}

enum Sub {
  PORTUGUESE,
  MATH
}

enum Yr {
  ONE,
  TWO,
}

enum ModulePosYear1Por {
  Letters_Lesson_Alphabet,
  Letters_Lesson_Vowels,
  Letters_Exercise_OrderVowels,
  Letters_Exercise_OrderAlphabet,
  Letters_Exercise_LettersOnset,
  Letters_Exercise_MatchCase,
  Letters_Test_LettersImage,
  Letters_Test_LettersOnset,
  Letters_Test_MatchCase,
  Syllables_Lesson_Syllables,
  Syllables_Lesson_Consonant_Vowels,
  Syllables_Lesson_Words,
  Syllables_Exercise_SyllablesSound,
  Syllables_Exercise_SyllablesWord,
  Syllables_Test_SyllablesSound,
  Syllables_Test_SyllablesWord,
}
enum ModulePosYear1Mat {
  Numbers_Lesson_1_10,
  Numbers_Exercise_NumbersPicture,
  Numbers_Exercise_OrderNumbers,
  Numbers_Test_NumbersPicture,
  Numbers_Test_OrderNumbers,
}
enum ModulePosYear2Por {
  Words_Lesson_Words,
  Words_Lesson_WordsOnset,
  Words_Lesson_WordOnsets,
  Words_Lesson_ConsonantsVowels,
  Words_Exercise_WordsPicture,
  Words_Exercise_WordPictures,
  Words_Exercise_Spelling1,
  Words_Exercise_Spelling2,
  Words_Test_WordsPicture,
  Words_Test_WordPictures,
  Words_Test_Spelling1,
  Words_Test_Spelling2,
}
enum ModulePosYear2Mat {
  Numbers_Lesson_1_20_Full,
  Numbers_Exercise_WordNumbers1_20,
  Numbers_Test_WordNumbers1_20,
  Numbers_Lesson_30_100_Full,
  Numbers_Exercise_WordNumbers30_100,
  Numbers_Test_WordNumbers30_100,
  Numbers_Lesson_1_10_Ordinals,
  Numbers_Exercise_1_10_Ordinals,
  Numbers_Test_1_10_Ordinals,
  Numbers_Lesson_20_100_Ordinals,
  Numbers_Exercise_20_100_Ordinals,
  Numbers_Test_20_100_Ordinals,
}

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
  listNumber1t20 = [];
  listNumber30t100 = [];
  listNumber1t10Ordinal = [];
  listNumber20t100Ordinal = [];
  alphabetOnsetList = [];
  letterOnsetList = [];
  listOnsetConsonants = [];
  lettersMatchCase = [];
  valOrderNumbers = [];
  valOrderVowels = [];
  valOrderAlphabet = [];
  mapSyllableMatch = [];
  mapWordMatch = [];
  listYears = [];

  printDebug("******** init 2");

  settingsNavigationLanguage.clear();

  listSyllables.clear();

  printDebug("******** init 3");

  getNavigationLanguage();

  printDebug("******** init 4");
  await populate();

  printDebug("******** init 5");
  expandedId.asMap().forEach((index, value) => prefs.getInt("expandedId-$index")??Sub.PORTUGUESE.index);
  printDebug("******** init 6");
  print("expandedId-0: " + expandedId[0].toString());
  print("expandedId-1: " + expandedId[1].toString());

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
    for (int i=0; i<langCount; i++) {
      settingsNavigationLanguage.add(MapEntry(i, _assetsConfig['CONFIG']['SETTINGS'][i]['NAVIGATION-LANGUAGE']));
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
  parsedWords['LIST']['CATEGORY']['VOCABULARY'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['VOCABULARY'][key];
    Word word = Word(id, title);
    listVocab.add(word);
  });

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
  parsedWords['LIST']['CATEGORY']['ALPHABET-VOWELS'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ALPHABET-VOWELS'][key];
    Word word = Word(id, title);
    listVowels.add(word);
  });

  // populate vowel list
  parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'][key];
    Word word = Word(id, title);
    listAlphabet.add(word);
  });

  printDebug("******** populate 5");

  // populate number list
  parsedWords['LIST']['CATEGORY']['NUMBERS_1-20'].keys.forEach((key){
    int id = int.parse(key);
    //printDebug('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_1-20'][id.toString()].keys.forEach((value) {
      //printDebug('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_1-20'][id.toString()][value];
      //printDebug('title: ' + title);
      Word word = Word(id, title, value);
      listNumber1t20.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'].keys.forEach((key){
    int id = int.parse(key);
    //printDebug('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'][id.toString()].keys.forEach((value) {
      //printDebug('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'][id.toString()][value];
      //printDebug('title: ' + title);
      Word word = Word(id, title, value);
      listNumber30t100.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'].keys.forEach((key){
    int id = int.parse(key);
    //printDebug('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'][id.toString()].keys.forEach((value) {
      //printDebug('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'][id.toString()][value];
      //printDebug('title: ' + title);
      Word word = Word(id, title, value);
      listNumber1t10Ordinal.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'].keys.forEach((key){
    int id = int.parse(key);
    //printDebug('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'][id.toString()].keys.forEach((value) {
      //printDebug('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'][id.toString()][value];
      //printDebug('title: ' + title);
      Word word = Word(id, title, value);
      listNumber20t100Ordinal.add(word);
    });
  });

  printDebug("******** populate 6");

  // populate alphabet onset
  parsedWords['LIST']['CATEGORY']['ALPHABET-ONSET'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ALPHABET-ONSET'][key];
    Word word = Word(id, title);
    alphabetOnsetList.add(word);
  });

  // populate letter onset
  parsedWords['LIST']['CATEGORY']['LETTER-ONSET'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['LETTER-ONSET'][key];
    Word word = Word(id, title);
    letterOnsetList.add(word);
  });

  // populate wo alphabet list
  parsedWords['LIST']['CATEGORY']['LIST-ONSET-CONSONANTS'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['LIST-ONSET-CONSONANTS'][key];
    Word word = Word(id, title);
    listOnsetConsonants.add(word);
  });

  // populate alphabet list
  parsedWords['LIST']['CATEGORY']['MATCH-CASE'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['MATCH-CASE'][key];
    Word word = Word(id, title);
    lettersMatchCase.add(word);
  });

  printDebug("******** populate 7");

  // populate number order list
  parsedWords['LIST']['CATEGORY']['ORDER-NUMBERS_1-10'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ORDER-NUMBERS_1-10'][key];
    Word word = Word(id, title);
    valOrderNumbers.add(word);
  });

  // populate vowel order list
  parsedWords['LIST']['CATEGORY']['ORDER-VOWELS'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ORDER-VOWELS'][key];
    Word word = Word(id, title);
    valOrderVowels.add(word);
  });
  
  // populate alphabet order list
  parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ORDER-ALPHABET'][key];
    Word word = Word(id, title);
    valOrderAlphabet.add(word);
  });

  // populate word list
  parsedWords['LIST']['CATEGORY']['LIST-SYLLABLES'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['LIST-SYLLABLES'][key];
    Word word = Word(id, title);
    listSyllables.add(word);
  });

  printDebug("******** populate 8");

  parsedWords['LIST']['CATEGORY']['SYLLABLE-MATCH'].forEach((key) {
    //printDebug("key:"+key.toString());
    String _syllable = key['SYLLABLE'].toString();
    //printDebug("syllable:"+syllable);
    List<Word> _listWords = [];
    key['WORDS'].forEach((key) {
      int id= int.parse(key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        //printDebug("id:" + word.id.toString());
        //printDebug("title:" + word.title);
        _listWords.add(word);
      }
    });
    Map<String,List<Word>> map = {_syllable:_listWords};
    try {
      mapSyllableMatch.add(map);
    } catch (e) {
      printDebug("Error:" + e.toString());
    }
  });

  parsedWords['LIST']['CATEGORY']['WORD-MATCH'].forEach((key) {
    //printDebug("key:"+key.toString());
    String _syllable = key['SYLLABLE'].toString();
    //printDebug("syllable:"+syllable);
    List<Word> _listWords = [];
    key['WORDS'].forEach((key) {
      int id= int.parse(key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        // printDebug("id:" + word.id.toString());
        // printDebug("title:" + word.title);
        _listWords.add(word);
      }
    });
    Map<String,List<Word>> map = {_syllable:_listWords};
    try {
      mapWordMatch.add(map);
    } catch (e) {
      printDebug("Error:" + e.toString());
    }
  });

  printDebug("******** populate 9");
  parsedWords['LIST']['CATEGORY']['WORD-ONSET'].forEach((key) {
    int id= int.parse(key.toString());
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

  List<Module> listModulesYear1Por = [];
  List<Module> listModulesYear1Mat = [];

  // module 0
  listModulesYear1Por.add(() {
    String _title = "Alfabeto";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabet,
      '/LessonAlphabet',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Vogais";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    print("length: " + listModulesYear1Por.length.toString());
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listVowels,
      '/LessonLetters',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Ordem das Vogais";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      valOrderVowels,
      '/ModuleOrder',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Ordem Alfabética";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      valOrderAlphabet,
      '/ModuleOrder',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Som inicial / Letras";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      letterOnsetList,
      '/ModuleLetters2Onset',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Maiúscula / Minúscula";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      lettersMatchCase,
      '/ModuleMatchCase',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Imagem / Letras";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet,
      '/ModuleLetters2Picture',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Som inicial / Letras";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      letterOnsetList,
      '/ModuleLetters2Onset',
      {
        'numberQuestions': 20,
        'useNavigation':false,
      },
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Maiúscula / Minúscula";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      lettersMatchCase,
      '/ModuleMatchCase',
      {
        'isVisibleTarget': true,
        'useNavigation':false,
      },
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Sílabas";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listSyllables,
      '/LessonSyllables',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Consoantes / Vogais";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      null,
      '/LessonSyllablesConsonantsVowels',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Sílabas / Palavras";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      null,
      '/LessonSyllables2Words',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Som / Sílabas";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listSyllables,
      '/ModuleSyllableOnset2Text',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Palavras / Sílabas";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      syllableUnique.where((word) => word.title.length == 4).toList(),
      '/ModuleSyllablesWord',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Som / Sílabas";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listSyllables,
      '/ModuleSyllableOnset2Text',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Palavra / Sílabas";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      syllableUnique.where((word) => word.title.length == 4).toList(),
      '/ModuleSyllablesWord',
      {
        'numberQuestions': 20,
      },
    );
  } ());

  listModulesYear1Mat.add(() {
    String _title = "1-10";
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear1Mat.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 154).toList(),
        '/LessonNumbers',
    );
  } ());
  listModulesYear1Mat.add(() {
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear1Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listNumber1t20.where((word) => word.id <= 154).toList(),
      '/ModuleNumbers2Picture',
    );
  } ());
  listModulesYear1Mat.add(() {
    String _title = getAssetsVocab('ORDER-NUMBERS');
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear1Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      valOrderNumbers,
      '/ModuleOrderNumeric',
    );
  } ());
  listModulesYear1Mat.add(() {
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear1Mat.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        listNumber1t20.where((word) => word.id <= 154).toList(),
        '/ModuleNumbers2Picture',
      {
        'numberQuestions': 20,
        'useNavigation':false,
      },
    );
  } ());
  listModulesYear1Mat.add(() {
    String _title = getAssetsVocab('ORDER-NUMBERS');
    Yr _year = Yr.ONE;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear1Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      valOrderNumbers,
      '/ModuleOrderNumeric',
    );
  } ());

  Year year;
  List<Subject> listSubjects;
  Subject subjectPor;
  Subject subjectMat;

  subjectPor = Subject(Sub.PORTUGUESE, "Português", listModulesYear1Por);
  subjectMat = Subject(Sub.MATH, "Matemática", listModulesYear1Mat);

  listSubjects = [];
  listSubjects.add(subjectPor);
  listSubjects.add(subjectMat);

  year = Year(
      Yr.ONE,
      "1º Ano",
      Colors.red.shade200,
      listSubjects);
  listYears.add(year);

  List<Module> listModulesYear2Por = [];
  List<Module> listModulesYear2Mat = [];

  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('WORDS');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabet,
      '/LessonWords',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('WORDS');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listOnsetConsonants,
      '/LessonOnset2Words',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('ONSETS');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listWordOnset.where((word) => word.title.length <=6).toList(),
      '/LessonWord2Onsets',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('CONSONANTS') + " / " + getAssetsVocab('VOWELS');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        mapWordMatch,
        '/LessonWordsConsonantsVowels',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listVocab.where((word) => word.title.length <=5).toList(),
      '/ModuleWords2Picture',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        alphabet,
        '/ModuleWord2Pictures',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + " 1";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <=6).toList(),
        '/ModuleSpelling01',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + " 2";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <=6).toList(),
        '/ModuleSpelling02',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet.where((word) => word.title.length <=5).toList(),
      '/ModuleWords2Picture',
      {
        'numberQuestions': 20,
      },
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet,
      '/ModuleWord2Pictures',
      {
        'numberQuestions': 20,
      },
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + " 1";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet.where((word) => word.title.length <=6 && word.title.length >3).toList(),
        '/ModuleSpelling01',
      {
        'numberQuestions': 20,
      },
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + ' 2';
    Yr _year = Yr.TWO;
    Sub _subject = Sub.PORTUGUESE;
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet.where((word) => word.title.length <=6).toList(),
      '/ModuleSpelling02',
      {
        'numberQuestions': 20,
      },
    );
  } ());

  listModulesYear2Mat.add(() {
    String _title = "1 - 20 (extenso)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listNumber1t20,
        '/LessonNumbersFull',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "30 - 100 (extenso)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber30t100,
      '/LessonNumbersFull',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "1 - 10 (ordinais)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber1t10Ordinal,
      '/LessonNumbersFull',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "20 - 100 (ordinais)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber20t100Ordinal,
      '/LessonNumbersFull',
    );
  } ());

  listModulesYear2Mat.add(() {
    String _title = "1 - 20 (extenso)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber1t20,
        '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "30 - 100 (extenso)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber30t100,
        '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "1 - 10 (ordinais)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.EXERCISE,
        _year,
        _subject,
        listNumber1t10Ordinal,
        '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "20 - 100 (ordinais)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listNumber20t100Ordinal,
      '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "1 - 20 (extenso)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listNumber1t20,
      '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "30 - 100 (extenso)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listNumber30t100,
      '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "1 - 10 (ordinais)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listNumber1t10Ordinal,
      '/ModuleNumbers2Word',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "20 - 100 (ordinais)";
    Yr _year = Yr.TWO;
    Sub _subject = Sub.MATH;
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listNumber20t100Ordinal,
      '/ModuleNumbers2Word',
    );
  } ());

  subjectPor = Subject(Sub.PORTUGUESE, "Português", listModulesYear2Por);
  subjectMat = Subject(Sub.MATH, "Matemática", listModulesYear2Mat);

  listSubjects = [];
  listSubjects.add(subjectPor);
  listSubjects.add(subjectMat);

  year = Year(
      Yr.TWO,
      "2º Ano",
      Colors.yellow.shade200,
      listSubjects);
  listYears.add(year);

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
      color: !unlock?Colors.white:Colors.grey[350]
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
  var temp = 2;

  navigationLanguage = temp;

  if (temp == null) navigationLanguage=2;
  return navigationLanguage;// portuguese as default
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

void audioPlay(Object itemId, [int duration=100]) {
  AudioCache audioCache = AudioCache();
  if (Platform.isIOS)
    audioCache.fixedPlayer?.notificationService.startHeadlessService();
  audioStop();
  t1 = Timer(Duration(milliseconds: duration), () async {
    audioPlayer = await audioCache.play('audios/$itemId.mp3');
  });
}

void audioPlayOnset(String onset) {
  Word testWord = alphabetOnsetList.firstWhere((word) => word.title.startsWith(onset));
  audioPlay(testWord.id);
}

void audioStop() {
  audioPlayer.stop();
  t1?.cancel();
  t2?.cancel();
  t3?.cancel();
}

Future<SharedPreferences> getPrefs() async {
  if (prefs == null) prefs = await SharedPreferences.getInstance();
  return prefs;
}

ElevatedButton getImageTile(int id) {
  return ElevatedButton(
      onPressed: () => audioPlay(id),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white
      ),
      child: Stack(
        children: [
          getImage(id,200),
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

ElevatedButton getTextTile(Word word) {
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
              child: getText(word.value),
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

Text getText(String text) {
  return Text(
    text,
    style: TextStyle(
        color: Colors.deepOrange,
        fontSize: 100,
    ),
  );
}

printDebug (String text) {
  if (debugMode) print(text);
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
