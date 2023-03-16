library globals;

import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info/package_info.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dart:convert';
import 'dart:async';
import 'package:litera/word.dart';

import 'package:shared_preferences/shared_preferences.dart';

String appOralLanguage;
String devName;
String devEmail;

int navigationLanguage;

String buildNumber;
String version;

List<MapEntry> settingsNavigationLanguage = [];
Map<String, dynamic> _assetsConfig;

Color appBarColorLight = Colors.teal[200];
Color appBarColor = Colors.teal;
Color appBarColorDark = Colors.teal[800];

Color menuColorLight = Colors.teal[200];
Color menuColor = Colors.teal;
Color menuColorDark = Colors.teal[800];

List<Word> alphabet;
List<Word> listWordOnset;
List<Word> listVowels;
List<Word> listAlphabet;
List<Word> listNumber1t10;
List<Word> listNumber11t20;
List<Word> listNumber30t100;
List<Word> listNumber1t10Ordinal;
List<Word> listNumber20t100Ordinal;
List<Word> listVocab;
List<Word> alphabetOnsetList;
List<Word> letterOnsetList;
List<Word> listOnsetConsonants; // list of alphabet letters used for onset lesson
List<Word> lettersMatchCase;
List<Word> valOrderNumbers;
List<Word> valOrderVowels;
List<Word> valOrderAlphabet;
List<Word> listSyllables;
List<Map<String, List<Word>>> mapSyllableMatch;
List<Map<String, List<Word>>> mapWordMatch;

Map<String, dynamic> parsedWords;

AudioPlayer audioPlayer = AudioPlayer();
Timer t1,t2,t3;

Widget adWidget;

int expandedId = 1;
SharedPreferences prefs;

Future<Map<String, dynamic>> getConfigAssets() async {
  return _assetsConfig;
}

enum ModulesYear1Portuguese {
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
  Syllables_Test_SyllablesSound,
}
enum ModulesYear1Math {
  Numbers_Lesson_1_10,
  Numbers_Exercise_NumbersPicture,
  Numbers_Exercise_OrderNumbers,
  Numbers_Test_NumbersPicture,
  Numbers_Test_OrderNumbers,
  Numbers_Lesson_1_10_Full,
  Numbers_Lesson_11_20_Full,
  Numbers_Lesson_30_100_Full,
}

enum ModulesYear2Portuguese {
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
enum ModulesYear2Math {
  Numbers_Lesson_1_10_Full,
  Numbers_Lesson_11_20_Full,
  Numbers_Lesson_30_100_Full,
  Numbers_Lesson_1_10_Ordinals,
  Numbers_Lesson_20_100_Ordinals
}

Future populate() async {

  print("******** populate 1");

  await rootBundle.loadString('assets/config.json').then((value) {
    _assetsConfig = json.decode(value);
    devName = _assetsConfig['CONFIG']['DEVELOPER']['NAME'];
    devEmail = _assetsConfig['CONFIG']['DEVELOPER']['EMAIL'];
    appOralLanguage = _assetsConfig['CONFIG']['APP']['ORAL-LANGUAGE'];
    int langCount = _assetsConfig['CONFIG']['SETTINGS'].length;
    for (int i=0; i<langCount; i++) {
      settingsNavigationLanguage.add(MapEntry(i, _assetsConfig['CONFIG']['SETTINGS'][i]['NAVIGATION-LANGUAGE']));
    }
  });

  print("******** populate 2");

  try {
    String jsonString = await rootBundle.loadString("assets/words.json");
    parsedWords = json.decode(jsonString);
  } catch (e) {
    print(e.toString());
  }

  print("******** populate 3");

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
    //print("key:" + key.toString());
    final result = listVocab.where((element) => element.id == id);
    Word word;
    if (result.isNotEmpty) {
      word = result.first;
      // print("id:" + word.id.toString());
      // print("title:" + word.title);
      alphabet.add(word);
    } else {
      print("empty result");
    }
  });

  print("******** populate 4");

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

  print("******** populate 5");

  // populate number list
  parsedWords['LIST']['CATEGORY']['NUMBERS_1-10'].keys.forEach((key){
    int id = int.parse(key);
    //print('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_1-10'][id.toString()].keys.forEach((value) {
      //print('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_1-10'][id.toString()][value];
      //print('title: ' + title);
      Word word = Word(id, title, value);
      listNumber1t10.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_11-20'].keys.forEach((key){
    int id = int.parse(key);
    //print('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_11-20'][id.toString()].keys.forEach((value) {
      //print('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_11-20'][id.toString()][value];
      //print('title: ' + title);
      Word word = Word(id, title, value);
      listNumber11t20.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'].keys.forEach((key){
    int id = int.parse(key);
    //print('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'][id.toString()].keys.forEach((value) {
      //print('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_30-100'][id.toString()][value];
      //print('title: ' + title);
      Word word = Word(id, title, value);
      listNumber30t100.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'].keys.forEach((key){
    int id = int.parse(key);
    //print('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'][id.toString()].keys.forEach((value) {
      //print('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_1-10_ORDINAL'][id.toString()][value];
      //print('title: ' + title);
      Word word = Word(id, title, value);
      listNumber1t10Ordinal.add(word);
    });
  });

  parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'].keys.forEach((key){
    int id = int.parse(key);
    //print('key: ' + key);
    parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'][id.toString()].keys.forEach((value) {
      //print('value: ' + value);
      String title = parsedWords['LIST']['CATEGORY']['NUMBERS_20-100_ORDINAL'][id.toString()][value];
      //print('title: ' + title);
      Word word = Word(id, title, value);
      listNumber20t100Ordinal.add(word);
    });
  });

  print("******** populate 6");

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

  print("******** populate 7");

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

  print("******** populate 8");

  parsedWords['LIST']['CATEGORY']['SYLLABLE-MATCH'].forEach((key) {
    //print("key:"+key.toString());
    String _syllable = key['SYLLABLE'].toString();
    //print("syllable:"+syllable);
    List<Word> _listWords = [];
    key['WORDS'].forEach((key) {
      int id= int.parse(key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        //print("id:" + word.id.toString());
        //print("title:" + word.title);
        _listWords.add(word);
      }
    });
    print("");
    Map<String,List<Word>> map = {_syllable:_listWords};
    try {
      mapSyllableMatch.add(map);
    } catch (e) {
      print("Error:" + e.toString());
    }
  });

  parsedWords['LIST']['CATEGORY']['WORD-MATCH'].forEach((key) {
    //print("key:"+key.toString());
    String _syllable = key['SYLLABLE'].toString();
    //print("syllable:"+syllable);
    List<Word> _listWords = [];
    key['WORDS'].forEach((key) {
      int id= int.parse(key.toString());
      final result = listVocab.where((element) => element.id == id);
      Word word;
      if (result.isNotEmpty) {
        word = result.first;
        // print("id:" + word.id.toString());
        // print("title:" + word.title);
        _listWords.add(word);
      }
    });
    Map<String,List<Word>> map = {_syllable:_listWords};
    try {
      mapWordMatch.add(map);
    } catch (e) {
      print("Error:" + e.toString());
    }
  });

  print("******** populate 9");
  parsedWords['LIST']['CATEGORY']['WORD-ONSET'].forEach((key) {
    int id= int.parse(key.toString());
    //print("key:" + key.toString());
    final result = listVocab.where((element) => element.id == id);
    Word word;
    if (result.isNotEmpty) {
      word = result.first;
      //print("id:" + word.id.toString());
      //print("title:" + word.title);
      listWordOnset.add(word);
    } else {
      print("empty result");
    }
  });

}

Future init() async {

  print("******** init");

  prefs = await SharedPreferences.getInstance();

  alphabet = [];
  listWordOnset = [];
  listSyllables = [];
  listVowels = [];
  listAlphabet = [];
  listVocab = [];
  listNumber1t10 = [];
  listNumber11t20 = [];
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

  print("******** init 2");

  settingsNavigationLanguage?.clear();

  listSyllables?.clear();

  print("******** init 3");

  getNavigationLanguage();

  print("******** init 4");

  expandedId = prefs.getInt('expandedId')??1;
  print("******** init 5");
  await populate();
  print("******** finished populate");
}

Icon getLockIcon(bool isModuleLocked) {
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

Icon getLessonIcon() {
  return Icon(
    IconData(59404, fontFamily: 'LiteraIcons'),
    color: Colors.blue.shade500,
  );
}

Icon getExerciseIcon() {
  return Icon(
    IconData(58740, fontFamily: 'LiteraIcons'),
    color: Colors.yellow.shade200,
  );
}

Icon getTestIcon() {
  return Icon(
    IconData(59485, fontFamily: 'LiteraIcons'),
    color: Colors.red.shade200,
  );
}

Icon getReportIcon() {
  return Icon(
    IconData(59484, fontFamily: 'LiteraIcons'),
    color: Colors.white,
  );
}

String getAssetsVocab(String key) {
  return _assetsConfig['CONFIG']['VOCABULARY'][getNavigationLanguage()][key];
}

int getNavigationLanguage() {
  var temp = prefs.get("settings-language");

  navigationLanguage = temp;

  if (temp == null) navigationLanguage=2;
  return navigationLanguage;// portuguese as default
}

showBeginningAlertDialog(BuildContext context) {
  print('alert');
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
  print('alert');
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
    audioCache.fixedPlayer?.notificationService?.startHeadlessService();
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
  audioPlayer?.stop();
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image(
              image: AssetImage('assets/images/$id.png'),
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
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: Text(
                word.value,
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 100,
                  fontFamily: "Mynerve"
                ),
              ),
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
  print('********** onset tile 1 word:' + word.title);
  print('********** onset tile 2 word:' + alphabetOnsetList.length.toString());
  Word onset;
  try {
    onset = alphabetOnsetList.singleWhere((element) => element.title == word.title.substring(0,1));
    print('********** onset tile 3 word:' + onset.title);
  } catch (e) {
    print('********** onset error:' + e.toString());
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
