class Book {
  int id = 0;
  String noteTitle = 'T';
  String category = 'T';
  String note = 'T';
  int get getId => id;

  set setId(int id) => this.id = id;

  String get gettitle => noteTitle;

  set setTitle(String noteTitle) => this.noteTitle = noteTitle;

  String get getcategory => category;

  set setcategory(String category) => this.category = category;

  String get getNote => note;

  set setNote(String note) => this.note = note;

  Book();
  Book.withId(this.id, this.noteTitle, this.category, this.note);
  Book.withoutId(this.noteTitle, this.category, this.note);

  Map<String, dynamic> toMap() =>
      {'id': id, 'noteTitle': noteTitle, 'category': category, 'note': note};
  Book.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    noteTitle = map['noteTitle'];
    category = map['category'];
    note = map['note'];
  }
}
