class Book {
  int id;
  String book_name;
  String author;
  int price;
 int get getId => id;

 set setId(int id) => this.id = id;

 String get bookname => book_name;

 set bookname(String value) => book_name = value;

 String get getAuthor => author;

 set setAuthor(String author) => this.author = author;

 int get getPrice => price;

 set setPrice(int price) => this.price = price;
  Book();
  Book.withId(this.id, this.book_name, this.author, this.price);
  Book.withoutId(this.book_name, this.author, this.price);

  Map<String, dynamic> toMap() =>
      {'id': id, 'book_name': book_name, 'author': author, 'price': price};
  Book.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    book_name = map['book_name'];
    author = map['author'];
    price = map['price'];
  }
}
