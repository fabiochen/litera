import 'package:litera/baseModule.dart';
import 'package:litera/word.dart';
import 'package:litera/globals.dart';

class LessonWords extends BaseModule {
  @override
  _LessonWordsState createState() => _LessonWordsState();
}

class _LessonWordsState extends BaseModuleState<LessonWords> {

  Comparator<Word> criteria = (a, b) => a.title.compareTo(b.title);

  @override
  String getMainLabel() {
    audioPlay(wordMain.id);
    return super.getMainLabel();
  }

}
