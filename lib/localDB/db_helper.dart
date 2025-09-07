import 'dart:convert';

import 'package:dot_planner/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static const int _dbVersion = 2;

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          color INTEGER,
          created_at TEXT,
          updated_at TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE note_blocks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          note_id INTEGER,
          type TEXT,
          data TEXT,
          FOREIGN KEY(note_id) REFERENCES notes(id) ON DELETE CASCADE
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE note_blocks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            note_id INTEGER,
            type TEXT,
            data TEXT,
            FOREIGN KEY(note_id) REFERENCES notes(id) ON DELETE CASCADE
          )
        ''');
        }
      },
    );
  }

  // ----------------- CRUD for simple notes -----------------
  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('notes', note);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: 'updated_at DESC');
  }

  Future<int> updateNote(Map<String, dynamic> note, int id) async {
    final db = await database;
    return await db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTotalNotes() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM notes');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ----------------- Blocks-aware methods -----------------
  Future<int> insertBlock(int noteId, Map<String, dynamic> block) async {
    final db = await database;
    return await db.insert('blocks', {
      'note_id': noteId,
      'type': block['type'],
      'data': block['data'],
      'position': block['position'],
    });
  }

  Future<int> insertNoteWithBlocks(
    Map<String, dynamic> note,
    List<Map<String, dynamic>> blocks,
  ) async {
    final db = await database;
    return await db.transaction<int>((txn) async {
      // 1️⃣ Insert note
      final noteId = await txn.insert('notes', note);

      // 2️⃣ Insert blocks with noteId
      for (var block in blocks) {
        final blockWithNoteId = {...block, 'note_id': noteId};
        await txn.insert('note_blocks', blockWithNoteId);
      }

      return noteId;
    });
  }

  Future<List<Map<String, dynamic>>> getNotesWithBlocks() async {
    final db = await database;

    final notesData = await db.query('notes', orderBy: 'updated_at DESC');
    List<Map<String, dynamic>> result = [];

    for (var noteMap in notesData) {
      final noteId = noteMap['id'] as int;

      final blocks = await db.query(
        'note_blocks', // correct table
        where: 'note_id = ?',
        whereArgs: [noteId],
        orderBy: 'id ASC',
      );

      result.add({'note': Note.fromMap(noteMap), 'blocks': blocks});
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllNotesWithBlocks() async {
    final db = await database;

    final notes = await db.query('notes', orderBy: 'updated_at DESC');
    final List<Map<String, dynamic>> result = [];

    for (var note in notes) {
      final noteId = note['id'] as int;
      final blocks = await db.query(
        'note_blocks', // Correct table name
        where: 'note_id = ?',
        whereArgs: [noteId],
        orderBy: 'position ASC',
      );

      result.add({
        'note': Map<String, dynamic>.from(note),
        'blocks': List<Map<String, dynamic>>.from(blocks),
      });
    }

    return result;
  }

  Future<int> deleteBlocksForNote(int noteId) async {
    final db = await database;
    return await db.delete('blocks', where: 'note_id = ?', whereArgs: [noteId]);
  }
}
