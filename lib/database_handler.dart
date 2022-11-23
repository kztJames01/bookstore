import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'books.dart';

class DatabaseHandler {
  String DBNAME = 'NoteDatabase';
  String TABLE_NAME = 'Notes';
  String COLUMN_ID = 'id';
  String COLUMN_NOTETITLE = 'noteTitle';
  String COLUMN_CATEGORY = 'category';
  String COLUMN_NOTE = 'note';
  late Database _database;
  late DatabaseHandler handler;
  

  Future<Database> initdatabase() async {
    String dir = await getDatabasesPath();
    String path = join(dir, DBNAME);
    _database =
        await openDatabase(path, version: 1, onCreate: ((db, version) async {
      String sql =
          'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY NOT NULL,$COLUMN_NOTETITLE TEXT NOT NULL,$COLUMN_CATEGORY TEXT NOT NULL,$COLUMN_NOTE TEXT NOT NULL)';
      await db.execute(sql);
    }));
    return _database;
  }

  Future<int> insertData(Book book) async {
    await initdatabase();
    return await _database.insert(TABLE_NAME, book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteData(int id) async {
    await initdatabase();
    return await _database.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Book book) async {
    await initdatabase();
    return await _database.update(TABLE_NAME, book.toMap(),
        where: 'id = ?', whereArgs: [book.id]);
  }

  Future<List<Book>> selectAllbooks() async {
    await initdatabase();
    var result = await _database.query(TABLE_NAME);

    List<Book> allbooks = result.map((e) => Book.fromMap(e)).toList();
    return allbooks;
  }

  Future<List<Book>> selectSpecific(String book) async {
    await initdatabase();
    var result = await _database
        .query(TABLE_NAME, where: '$COLUMN_CATEGORY = ?', whereArgs: [book]);

    List<Book> specific = result.map((e) => Book.fromMap(e)).toList();
    return specific;
  }

  Future<List<Book>> search(String book) async {
    await initdatabase();
    var result = await _database
        .query(TABLE_NAME, where: '$COLUMN_NOTETITLE = ?', whereArgs: [book]);

    List<Book> allbooks = result.map((e) => Book.fromMap(e)).toList();
    print(allbooks.length);
    return allbooks;
  }
}
