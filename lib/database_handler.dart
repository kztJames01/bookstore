import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'books.dart';

class DatabaseHandler {
  String DBNAME = 'BookStore';
  String TABLE_NAME = 'Books';
  String COLUMN_ID = 'id';
  String COLUMN_BOOK_NAME = 'book_name';
  String COLUMN_AUTHOR = 'author';
  String COLUMN_PRICE = 'price';
  static Database _database;
  static DatabaseHandler handler;
  DatabaseHandler._createInstance();
  factory DatabaseHandler() {
    if (handler == null) {
      handler = DatabaseHandler._createInstance();
    }
    return handler;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initdatabase();
    }
    return _database;
  }

  Future<String> databasePath() async {
    return await getDatabasesPath();
  }

  Future<Database> initdatabase() async {
    String dir = await getDatabasesPath();
    String path = join(dir, DBNAME);
    return openDatabase(path, version: 1, onCreate: createdatabase);
  }

  void createdatabase(Database db, int index) {
    String sql =
        'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY UNIQUE NOT NULL,$COLUMN_BOOK_NAME TEXT NOT NULL,$COLUMN_AUTHOR TEXT NOT NULL,$COLUMN_PRICE INTEGER NOT NULL);';
    db.execute(sql);
  }

  Future<int> insertData(Book book) async {
    var db = await database;
    return await db.insert(TABLE_NAME, book.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteData(int id) async {
    var db = await database;
    return await db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Book book) async {
    var db = await database;
    return await db.update(TABLE_NAME, book.toMap(),
        where: 'id = ?', whereArgs: [book.id]);
  }

  Future<List<Book>> selectAllbooks() async {
    var db = await database;
    var result = await db.query(TABLE_NAME);

    List<Book> allbooks = result.map((e) => Book.fromMap(e)).toList();
    return allbooks;
  }
  Future<List<Book>> selectSpecific(String book) async {
    var db = await database;
    var result = await db.query(TABLE_NAME,where: '$COLUMN_BOOK_NAME = ?', whereArgs: [book]);

    List<Book> specific = result.map((e) => Book.fromMap(e)).toList();
    return specific;
  }

  Future<List<Book>> search(String book) async {
    var db = await database;
    var result = await db
        .query(TABLE_NAME, where: '$COLUMN_BOOK_NAME = ?', whereArgs: [book]);

    List<Book> allbooks = result.map((e) => Book.fromMap(e)).toList();
    print(allbooks.length);
    return allbooks;
  }
}
