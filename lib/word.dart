class Word {
  String title;
  int id;
  String value;
  bool processed;

  Word(int id, String title, [String value = '', bool processed = false]) {
    this.title = title;
    this.id = id;
    this.value = value;
    this.processed = processed;
  }

}