class Word {
  late String title;
  late int id;
  late String val1;
  late String val2;
  late String val3;
  late bool processed;
  late bool containsAudio;
  late bool containsImage;

  Word(int id, String title, [String val1 = '', bool processed = false]) {
    this.title = title;
    this.id = id;
    this.val1 = val1;
    this.processed = processed;
  }

}