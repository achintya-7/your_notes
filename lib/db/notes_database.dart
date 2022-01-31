// ignore_for_file: prefer_const_declarations

import 'package:notesapp/model/note.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!; // returns the database if there is one
    } else {
      _database = await _initDB(
          'notes.db'); // initializes a new database if there is no prior one
      return _database!;
    }
  }

  // Function to initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath,
        filePath); // joins the database path and our fileName to it {On Android, it is typically data/data//databases/{database_name}}
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Function to create new database if required
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NoteFields.id} $idType,
        ${NoteFields.isImportant} $boolType,
        ${NoteFields.description} $textType,
        ${NoteFields.title} $textType,
        ${NoteFields.time} $textType
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> read(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes, columns: NoteFields.values,
      where: '${NoteFields.id} = ?', // = ? is called SQP injection method
      whereArgs: [
        id
      ], // these 2 lines help in finding the required row whenm an id is given
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAll() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  // Function to close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
