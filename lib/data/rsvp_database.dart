import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RsvpDatabase {
  static const _table = 'rsvp_status';
  Database? _db;
  bool _unavailable = false;

  Future<Database?> get _database async {
    if (kIsWeb || _unavailable) return null;
    if (_db != null) return _db;
    try {
      _db = await openDatabase(
        join(await getDatabasesPath(), 'aluconnect.db'),
        version: 1,
        onCreate: (db, version) => db.execute(
          'CREATE TABLE $_table('
          'event_id TEXT PRIMARY KEY, '
          'going INTEGER NOT NULL DEFAULT 0, '
          'interested INTEGER NOT NULL DEFAULT 0, '
          'saved INTEGER NOT NULL DEFAULT 0)',
        ),
      );
    } catch (_) {
      _unavailable = true;
    }
    return _db;
  }

  Future<List<Map<String, Object?>>> fetchAll() async {
    final db = await _database;
    if (db == null) return [];
    return db.query(_table);
  }

  Future<void> save(
    String eventId, {
    required bool going,
    required bool interested,
    required bool saved,
  }) async {
    final db = await _database;
    if (db == null) return;
    if (!going && !interested && !saved) {
      await db.delete(_table, where: 'event_id = ?', whereArgs: [eventId]);
      return;
    }
    await db.insert(
      _table,
      {
        'event_id': eventId,
        'going': going ? 1 : 0,
        'interested': interested ? 1 : 0,
        'saved': saved ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clear() async {
    final db = await _database;
    if (db == null) return;
    await db.delete(_table);
  }
}
