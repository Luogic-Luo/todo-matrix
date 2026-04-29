import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_constants.dart';
import 'migrations/migration_v1.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper? _instance;
  static Database? _database;

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);
    debugPrint('Database path: $path');

    return openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: (db, version) async {
        debugPrint('Creating database tables...');
        await MigrationV1.run(db);
        debugPrint('Database tables created.');
      },
    );
  }

  /// For testing: inject a custom database instance.
  static void setDatabase(Database db) {
    _database = db;
  }

  /// Close and reset the database connection.
  static Future<void> reset() async {
    await _database?.close();
    _database = null;
  }
}
