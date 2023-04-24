library globals;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:analog_clock/analog_clock.dart';

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
late List<Word> alphabetLetterList;
late List<Word> letterOnsetList;
late List<Word> listOnsetConsonants; // list of alphabet letters used for onset lesson
late List<Word> lettersMatchCase;
late List<Word> valOrderNumbers;
late List<Word> valOrderVowels;
late List<Word> valOrderAlphabet;
late List<Word> listSyllables;
late List<Map<String, List<Word>>> mapSyllableMatch;
late List<Map<String, List<Word>>> mapWordMatch;
late List<Word> listDirections;
late List<Word> listDaysOfTheWeek;
late List<Word> listMonthsOfTheYear;
late List<Word> listSeasonsOfTheYear;
late List<List<Word>> listGenderNumber;
late List<Word> listTimeLessonHour;
late List<Word> listTimeLessonMinutes;
late List<Word> listTimeHour;
late List<Word> listTimeMinutes;
late List<Word> listTimeTest;

late Map<String, dynamic> parsedWords;

final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Timer? t1,t2,t3 = Timer(Duration(seconds: 1), () {});

late Widget adWidget;

//index 0 = year 1; index 1 = year 2;
List<int> expandedId = [Sub.PORTUGUESE.index, Sub.PORTUGUESE.index];

late SharedPreferences prefs;

String percentUnlock = "80";

Future<Map<String, dynamic>> getConfigAssets() async {
  return _assetsConfig;
}

enum ModuleType {
  LESSON,
  EXERCISE,
  TEST,
  REPORT
}

enum WordField {
  TITLE,
  SYLLABLES
}

enum Sub {
  PORTUGUESE,
  MATH,
  SCIENCE,
  OTHERS,
}

enum Yr {
  ONE,
  TWO,
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
  listNumber1t20 = [];
  listNumber30t100 = [];
  listNumber1t10Ordinal = [];
  listNumber20t100Ordinal = [];
  alphabetOnsetList = [];
  alphabetLetterList = [];
  letterOnsetList = [];
  listOnsetConsonants = [];
  lettersMatchCase = [];
  valOrderNumbers = [];
  valOrderVowels = [];
  valOrderAlphabet = [];
  mapSyllableMatch = [];
  mapWordMatch = [];
  listYears = [];
  listDirections = [];
  listDaysOfTheWeek = [];
  listMonthsOfTheYear = [];
  listSeasonsOfTheYear = [];
  listGenderNumber = [];
  listTimeLessonHour = [];
  listTimeLessonMinutes = [];
  listTimeHour = [];
  listTimeMinutes = [];
  listTimeTest = [];

  printDebug("******** init 2");

  settingsNavigationLanguage.clear();

  listSyllables.clear();

  printDebug("******** init 3");

  getNavigationLanguage();

  printDebug("******** init 4");
  await populate();
  printDebug("******** init 4.1");
  getYear1Pt();
  printDebug("******** init 4.2");
  getYear1Mt();
  printDebug("******** init 4.3");
  getYear2Pt();
  printDebug("******** init 4.4");
  getYear2Mt();

  getYear2Sc();

  printDebug("******** init 5");
  expandedId.asMap().forEach((index, value) => prefs.getInt("expandedId-$index")??Sub.PORTUGUESE.index);
  printDebug("******** init 6");
  print("expandedId-0: " + expandedId[0].toString());
  print("expandedId-1: " + expandedId[1].toString());

  percentUnlock = prefs.getString('percentUnlock')??percentUnlock;

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
    String syllables = parsedWords['LIST']['CATEGORY']['VOCABULARY'][key];
    String title = syllables.replaceAll('-', '');
    Word word = Word(id, title);
    word.syllables = syllables;
    listVocab.add(word);
  });

  printDebug("******** populate 4");

  // populate vocab list
  parsedWords['LIST']['CATEGORY']['DAYS-OF-THE-WEEK'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['DAYS-OF-THE-WEEK'][key];
    Word word = Word(id, title);
    listDaysOfTheWeek.add(word);
  });

  // populate vocab list
  parsedWords['LIST']['CATEGORY']['DIRECTIONS'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['DIRECTIONS'][key];
    Word word = Word(id, title);
    listDirections.add(word);
  });

  // populate vocab list
  parsedWords['LIST']['CATEGORY']['MONTHS-OF-THE-YEAR'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['MONTHS-OF-THE-YEAR'][key];
    Word word = Word(id, title, (id-3600).toString());
    listMonthsOfTheYear.add(word);
  });

  printDebug("******** populate 5");

  parsedWords['LIST']['CATEGORY']['SEASONS-OF-THE-YEAR'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['SEASONS-OF-THE-YEAR'][key];
    Word word = Word(id, title);
    listSeasonsOfTheYear.add(word);
  });

  printDebug("******** populate 6");

  parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'].keys.forEach((key1){
    List<Word> listWord = [];
    parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'][key1].asMap().keys.forEach((key2){
      parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'][key1][key2].keys.forEach((key3) {
        int id = int.parse(key3);
        String title = parsedWords['LIST']['CATEGORY']['GENDER-NUMBER'][key1][key2][key3].toString();
        listWord.add(Word(id,title,key2.toString()));
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

  // populate alphabet onset
  parsedWords['LIST']['CATEGORY']['ALPHABET-LETTER-SOUND'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['ALPHABET-LETTER-SOUND'][key];
    Word word = Word(id, title, title);
    alphabetLetterList.add(word);
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

  parsedWords['LIST']['CATEGORY']['TIME-LESSON-HOUR'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['TIME-LESSON-HOUR'][key];
    Word word = Word(id, title);
    listTimeLessonHour.add(word);
  });

  parsedWords['LIST']['CATEGORY']['TIME-LESSON-MINUTES'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['TIME-LESSON-MINUTES'][key];
    Word word = Word(id, title);
    listTimeLessonMinutes.add(word);
  });

  parsedWords['LIST']['CATEGORY']['TIME-HOUR'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['TIME-HOUR'][key];
    Word word = Word(id, title);
    listTimeHour.add(word);
  });

  parsedWords['LIST']['CATEGORY']['TIME-MINUTES'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['TIME-MINUTES'][key];
    Word word = Word(id, title);
    listTimeMinutes.add(word);
  });

  parsedWords['LIST']['CATEGORY']['TIME-TEST'].keys.forEach((key){
    int id = int.parse(key);
    String title = parsedWords['LIST']['CATEGORY']['TIME-TEST'][key];
    Word word = Word(id, title);
    listTimeTest.add(word);
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
}

void getYear1Pt() {
  Yr _year = Yr.ONE;
  Sub _subject = Sub.PORTUGUESE;
  printDebug("******** init 4.1.1");
  List<Subject> listSubjects = [];
  printDebug("******** init 4.1.2");
  List<Module> listModulesYear1Por = [];

  Year year = Year(
      _year,
      "1º Ano",
      Colors.red.shade200,
      listSubjects);

  printDebug("******** init 4.1.3");

  listYears.add(year);

  // module 0
  listModulesYear1Por.add(() {
    String _title = "Alfabeto (Imagens)";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabet,
      '/LessonAlphabet',
      numberQuestions: 26
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Alfabeto (Letras)";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabetLetterList,
      '/LessonAlphabetLetters',
      numberQuestions: 26
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Vogais";
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
    String _title = "Som das Letras";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      alphabetLetterList,
      '/ModuleSound2Words',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Som inicial / Letras";
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
    int _modulePos = listModulesYear1Por.length;
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
  } ());
  listModulesYear1Por.add(() {
    String _title = "Letras (Antes e Depois)";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      alphabetLetterList,
      '/ModuleBeforeAndAfter',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Imagem / Letras";
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
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      letterOnsetList,
      '/ModuleLetters2Onset',
      useNavigation:false,
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Maiúscula / Minúscula";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      lettersMatchCase,
      '/ModuleMatchCase',
      isVisibleTarget: true,
      useNavigation:false,
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Sílabas";
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
    int _modulePos = listModulesYear1Por.length;
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
  } ());
  listModulesYear1Por.add(() {
    String _title = "Sílabas / Palavras";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      [],
      '/LessonSyllables2Words',
      noLock: true,
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Som / Sílabas";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listSyllables,
      '/ModuleSound2Words',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Palavras / Sílabas";
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
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listSyllables,
      '/ModuleSound2Words',
    );
  } ());
  listModulesYear1Por.add(() {
    String _title = "Palavra / Sílabas";
    int _modulePos = listModulesYear1Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      syllableUnique.where((word) => word.title.length == 4).toList(),
      '/ModuleSyllablesWord',
    );
  } ());

  listYears[_year.index].subjects.add(Subject(_subject, "Português", listModulesYear1Por));

}

void getYear1Mt() {
  Yr _year = Yr.ONE;
  Sub _subject = Sub.MATH;
  List<Module> listModulesYear1Mat = [];

  listModulesYear1Mat.add(() {
    String _title = "1-10";
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
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('NUMBERS');
    int _modulePos = listModulesYear1Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listNumber1t20.where((word) => word.id <= 154).toList(),
      '/ModuleNumbers2Picture',
      useNavigation: false,
    );
  } ());
  listModulesYear1Mat.add(() {
    String _title = getAssetsVocab('ORDER-NUMBERS');
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
    String _title = "Números (Antes e Depois)";
    int _modulePos = listModulesYear1Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listNumber1t20.where((word) => word.id <= 154).toList(),
      '/ModuleBeforeAndAfter',
    );
  } ());
  listModulesYear1Mat.add(() {
    String _title = getAssetsVocab('ORDER-NUMBERS');
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
  listModulesYear1Mat.add(() {
    String _title = "Números (Antes e Depois)";
    int _modulePos = listModulesYear1Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listNumber1t20.where((word) => word.id <= 154).toList(),
      '/ModuleBeforeAndAfter',
    );
  } ());

  listYears[_year.index].subjects.add(Subject(_subject, "Matemática", listModulesYear1Mat));

}

void getYear2Pt() {
  Yr _year = Yr.TWO;
  Sub _subject = Sub.PORTUGUESE;
  List<Subject> listSubjects = [];
  List<Module> listModulesYear2Por = [];

  Year year = Year(
      _year,
      "2º Ano",
      Colors.yellow.shade200,
      listSubjects);
  listYears.add(year);

  listModulesYear2Por.add(() {
    String _title = "Alfabeto (Cursiva)";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabetLetterList,
      '/LessonAlphabetCursive',
    );
  } ());

  listModulesYear2Por.add(() {
    String _title = "Alfabeto (Palavras)";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabet,
      '/LessonWordsAndPicture',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('ONSET') + " / " + getAssetsVocab('WORDS');
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
    String _title = "Alfabeto (Sílabas)";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      alphabet,
      '/LessonWordsAndPicture',
      misc: WordField.SYLLABLES
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = "Sílabas Iniciais";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      mapWordMatch,
      '/LessonWordsConsonantsVowels',
      misc: WordField.TITLE
    );
  } ());

  listModulesYear2Por.add(() {
    String _title = "Número de Sílabas";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listVocab.where((word) => word.title.length < 10).toList(),
      '/ModuleSyllablesCount',
    );
  } ());

  listModulesYear2Por.add(() {
    String _title = "Forca";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listVocab.where((word) => word.title.length <=4 && !(word.title.contains(RegExp(r'[çéáúãóõ]')))).toList(),
      '/LessonHangman',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS');
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
    String _title = getAssetsVocab('PICTURE') + " / " + getAssetsVocab('WORDS') + " (cursiva)";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listVocab.where((word) => word.title.length <=5).toList(),
      '/ModuleWords2Picture',
      fontFamily: "Maria_lucia",
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
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
    String _title = "Caça-Palavras";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      alphabet.where((word) => word.title.length <=6).toList(),
      '/LessonWordSearch',
      noLock: true,
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + " 1";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      alphabet.where((word) => word.title.length >3 && word.title.length <=6).toList(),
      '/ModuleSpelling01',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + " 2";
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
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet.where((word) => word.title.length <=5).toList(),
      '/ModuleWords2Picture',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('WORD') + " / " + getAssetsVocab('PICTURES');
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet,
      '/ModuleWord2Pictures',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + " 1";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      alphabet.where((word) => word.title.length <=6 && word.title.length >3).toList(),
      '/ModuleSpelling01',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = getAssetsVocab('SPELLING') + ' 2';
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.TEST,
        _year,
        _subject,
        alphabet.where((word) => word.title.length <=6).toList(),
        '/ModuleSpelling02',
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = "Masculino / Feminino";
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listGenderNumber,
        '/LessonWordPairs',
        misc: [0,1]
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = "Singular / Plural";
    int _modulePos = listModulesYear2Por.length;
    return Module(
        _modulePos,
        _title,
        ModuleType.LESSON,
        _year,
        _subject,
        listGenderNumber,
        '/LessonWordPairs',
        misc: [0,2]
    );
  } ());
  listModulesYear2Por.add(() {
    String _title = "Gênero & Número";
    int _modulePos = listModulesYear2Por.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listGenderNumber,
      '/ModuleGenderNumber',
    );
  } ());

  listYears[_year.index].subjects.add(Subject(_subject, "Português", listModulesYear2Por));

}

void getYear2Mt() {
  Yr _year = Yr.TWO;
  Sub _subject = Sub.MATH;
  List<Module> listModulesYear2Mat = [];

  listModulesYear2Mat.add(() {
    String _title = "1 - 20 (extenso)";
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber1t20,
      '/LessonWordAndNumber',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "1 - 20 (extenso)";
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
    String _title = "1 - 20 (extenso)";
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
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber30t100,
      '/LessonWordAndNumber',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "30 - 100 (extenso)";
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
    String _title = "30 - 100 (extenso)";
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
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber1t10Ordinal,
      '/LessonWordAndNumber',
    );
  } ());
  listModulesYear2Mat.add(() {
    String _title = "1 - 10 (ordinais)";
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
    String _title = "1 - 10 (ordinais)";
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
    int _modulePos = listModulesYear2Mat.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listNumber20t100Ordinal,
      '/LessonWordAndNumber',
    );
  } ());

  listModulesYear2Mat.add(() {
    String _title = "20 - 100 (ordinais)";
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
    String _title = "20 - 100 (ordinais)";
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

  listYears[_year.index].subjects.add(Subject(_subject, "Matemática", listModulesYear2Mat));

}

void getYear2Sc() {
  Yr _year = Yr.TWO;
  Sub _subject = Sub.SCIENCE;
  List<Module> listModulesYear2Sci = [];

  listModulesYear2Sci.add(() {
    String _title = "Esquerda / Direita";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listDirections,
      '/LessonWordsAndPicture',
      loop:true,
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Esquerda / Direita";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listDirections,
      '/ModuleLeftRight',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Esquerda / Direita";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listDirections,
      '/ModuleLeftRight',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Dias da Semana";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listDaysOfTheWeek,
      '/LessonWords',
      loop:true,
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Dias da Semana (Antes e Depois)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listDaysOfTheWeek,
      '/ModuleBeforeAndAfterDays',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Dias da Semana (Antes e Depois)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listDaysOfTheWeek,
      '/ModuleBeforeAndAfterDays',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Meses do Ano";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listMonthsOfTheYear,
      '/LessonWordAndNumber',
      loop:true,
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Número do Mês";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listMonthsOfTheYear,
      '/ModuleWord2Numbers',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Meses do Ano (Antes e Depois)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listMonthsOfTheYear,
      '/ModuleBeforeAndAfterDays',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Meses do Ano (Antes e Depois)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listMonthsOfTheYear,
      '/ModuleBeforeAndAfterDays',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Estações do Ano";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listSeasonsOfTheYear,
      '/LessonWordsAndPicture',
      loop:true,
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Estações do Ano (Antes & Depois)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listSeasonsOfTheYear,
      '/ModuleBeforeAndAfterDays',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Estações do Ano (Antes & Depois)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listSeasonsOfTheYear,
      '/ModuleBeforeAndAfterDays',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Relógio Análogo (horas)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listTimeLessonHour,
      '/LessonClock',
      loop: true,
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Relógio Análogo (minutos)";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listTimeLessonMinutes,
      '/LessonClock',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Relógio: Análogo & Digital";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.LESSON,
      _year,
      _subject,
      listTimeLessonHour,
      '/LessonClockDigital',
      useNavigation: false,
      noLock: true,
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Relógio: Exercício 1";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.EXERCISE,
      _year,
      _subject,
      listTimeTest,
      '/ModuleClock',
    );
  } ());

  listModulesYear2Sci.add(() {
    String _title = "Relógio: Teste 1";
    int _modulePos = listModulesYear2Sci.length;
    return Module(
      _modulePos,
      _title,
      ModuleType.TEST,
      _year,
      _subject,
      listTimeTest,
      '/ModuleClock',
    );
  } ());

  listYears[_year.index].subjects.add(Subject(_subject, "Ciências", listModulesYear2Sci));

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
  navigationLanguage = 2;
  return navigationLanguage;// portuguese as default
}

playTime(String time) {
  int hr = int.parse(time.substring(0,2));
  int min = int.parse(time.substring(3,5));
  audioPlayer.stop();
  String strHr = (400+hr).toString();
  String strHrEnding = "horas";
  String strMin = (600+min).toString();
  if (min == 0) {
    if (hr == 1) strHrEnding = "hora";
    if (hr >  1) strHrEnding = "horas";
    audioPlayer.open(
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
    audioPlayer.open(
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

void audioPlay(Object itemId) async {
//  AudioCache audioCache = AudioCache();
  if (Platform.isIOS)
//    audioCache.fixedPlayer?.notificationService.startHeadlessService();
  audioStop();
  audioPlayer.open(Audio("assets/audios/$itemId.mp3"));
}

void audioPlayOnset(String onset) {
  Word testWord = alphabetOnsetList.firstWhere((word) => word.title.startsWith(onset));
  print("onset3: " + testWord.title);
  audioPlay(testWord.id);
}

void audioStop() {
  audioPlayer.stop();
  t1?.cancel();
  t2?.cancel();
  t3?.cancel();
}

Widget getClock(String time, [double padding=8.0]) {
  print("Time: $time");
  int hr = int.parse(time.substring(0,2));
  int mn = int.parse(time.substring(3,5));
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

printDebug (String text) {
  if (debugMode) print(text);
}

int getUnlockModuleIndex (int _year, int _subject) {
  return prefs.getInt('unlockModuleIndex-$_year-$_subject')??0;
}

setUnlockModuleIndex (int newIndex, [int? _year, int? _subject]) async {
  await prefs.setInt('unlockModuleIndex-$_year-$_subject', newIndex);
}

