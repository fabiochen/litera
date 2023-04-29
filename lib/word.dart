class Word {
  late String title;
  late int id;
  late String val1;
  late String val2;
  late bool processed;

  Word(int id, String title, [String val1 = '', bool processed = false]) {
    this.title = title;
    this.id = id;
    this.val1 = val1;
    this.processed = processed;
  }

}