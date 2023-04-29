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
    switch (fieldTypeMain as dynamic) {
      case FieldType.VAL1:
        label = word.val1;
        break;
      default:
        label = word.title;
        break;
    }
    return label;
  }

}
