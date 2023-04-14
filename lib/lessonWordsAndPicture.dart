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
    return super.getMainLabel(word);
  }

}
