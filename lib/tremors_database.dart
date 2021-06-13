import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkinson_detection_app/tremor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TremorsDatabase {
  TremorsDatabase._init();

  static final TremorsDatabase instance = TremorsDatabase._init();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB('tremors.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTremors(
    ${TremorFields.id} $idType,
    ${TremorFields.recordedDateTime} $textType
    )
    ''');
  }

  Future<Tremor> create(Tremor tremor) async {
    final Database db = await instance.database;

    final int id = await db.insert(tableTremors, tremor.toJson());
    return tremor.copy(id: id);
  }

  Future<Tremor> readTremor(int id) async {
    final Database db = await instance.database;

    final List<Map<String, Object>> maps = await db.query(tableTremors,
        columns: TremorFields.values,
        where: '${TremorFields.id} = ?',
        whereArgs: <int>[id]);

    if (maps.isNotEmpty) {
      return Tremor.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Tremor>> readAllTremors() async {
    final Database db = await instance.database;
    final String orderBy = '${TremorFields.recordedDateTime} ASC';
    final List<Map<String, Object>> result = await db.rawQuery('SELECT * FROM $tableTremors ORDER BY $orderBy');
    /*final List<Map<String, Object>> result =
        await db.query(tableTremors, orderBy: orderBy);*/

    return result
        .map((Map<String, Object> json) => Tremor.fromJson(json))
        .toList();
  }

  Future<int> update(Tremor tremor) async {
    final Database db = await instance.database;

    return db.update(
      tableTremors,
      tremor.toJson(),
      where: '${TremorFields.id} = ?',
      whereArgs: <int>[tremor.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await instance.database;

    return await db.delete(
      tableTremors,
      where: '${TremorFields.id} = ?',
        whereArgs: <int>[id],
    );
  }

  Future<void> close() async {
    final Database db = await instance.database;

    db.close();
  }
}
