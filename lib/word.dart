class Word {
  late String title;
  late int id;
  late String value;
  late bool processed;
  late String syllables;

  Word(int id, String title, [String value = '', bool processed = false]) {
    this.title = title;
    this.id = id;
    this.value = value;
    this.processed = processed;
  }

}