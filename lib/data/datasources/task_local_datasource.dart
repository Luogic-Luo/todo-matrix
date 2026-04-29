import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/database_constants.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  final DatabaseHelper _dbHelper;

  TaskLocalDataSource(this._dbHelper);

  Future<Database> get _db => _dbHelper.database;

  Future<TaskModel?> getById(String id) async {
    final db = await _db;
    final rows = await db.query(
      DatabaseConstants.tableTasks,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return TaskModel.fromMap(rows.first);
  }

  Future<List<TaskModel>> getAll() async {
    final db = await _db;
    final rows = await db.query(
      DatabaseConstants.tableTasks,
      orderBy: '${DatabaseConstants.columnSortOrder} ASC, '
          '${DatabaseConstants.columnCreatedAt} DESC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<List<TaskModel>> getByStatus(String status) async {
    final db = await _db;
    final rows = await db.query(
      DatabaseConstants.tableTasks,
      where: '${DatabaseConstants.columnStatus} = ?',
      whereArgs: [status],
      orderBy: '${DatabaseConstants.columnSortOrder} ASC, '
          '${DatabaseConstants.columnCreatedAt} DESC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<List<TaskModel>> getByQuadrant(String quadrant) async {
    final db = await _db;
    final rows = await db.query(
      DatabaseConstants.tableTasks,
      where: '${DatabaseConstants.columnQuadrant} = ?',
      whereArgs: [quadrant],
      orderBy: '${DatabaseConstants.columnSortOrder} ASC, '
          '${DatabaseConstants.columnCreatedAt} DESC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<List<TaskModel>> getByDueDate(int startOfDay, int endOfDay) async {
    final db = await _db;
    final rows = await db.query(
      DatabaseConstants.tableTasks,
      where: '${DatabaseConstants.columnDueDate} >= ? AND '
          '${DatabaseConstants.columnDueDate} <= ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: '${DatabaseConstants.columnDueDate} ASC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<List<TaskModel>> getOverdue(int now) async {
    final db = await _db;
    final rows = await db.query(
      DatabaseConstants.tableTasks,
      where: '${DatabaseConstants.columnDueDate} < ? AND '
          '${DatabaseConstants.columnStatus} != ?',
      whereArgs: [now, 'done'],
      orderBy: '${DatabaseConstants.columnDueDate} ASC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  Future<void> insert(TaskModel task) async {
    final db = await _db;
    debugPrint('Inserting task: ${task.title}');
    await db.insert(
      DatabaseConstants.tableTasks,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Task inserted successfully.');
  }

  Future<void> update(TaskModel task) async {
    final db = await _db;
    await db.update(
      DatabaseConstants.tableTasks,
      task.toMap(),
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete(
      DatabaseConstants.tableTasks,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateSortOrders(List<Map<String, dynamic>> updates) async {
    final db = await _db;
    final batch = db.batch();
    for (final update in updates) {
      batch.update(
        DatabaseConstants.tableTasks,
        {'sort_order': update['sort_order'] as int},
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [update['id'] as String],
      );
    }
    await batch.commit(noResult: true);
  }
}
