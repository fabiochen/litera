import 'package:litera/baseModule.dart';
import 'package:litera/globals.dart';

class LessonWordsAndPicture extends BaseModule {
  @override
  _LessonWordsAndPictureState createState() => _LessonWordsAndPictureState();
}

class _LessonWordsAndPictureState extends BaseModuleState<LessonWordsAndPicture> {

  @override
  String getMainLabel(word) {
    audioPlay(word.id);
    String label;
    switch (misc as dynamic) {
      case WordField.SYLLABLES:
        label = word.syllables;
        break;
      default:
        label = word.title;
        break;
    }
    return label;
  }

}
