import '../database_constants.dart';

/// V1 schema migration: creates the initial tasks table.
class MigrationV1 {
  MigrationV1._();

  static Future<void> run(db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.tableTasks} (
        ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
        ${DatabaseConstants.columnTitle} TEXT NOT NULL,
        ${DatabaseConstants.columnDescription} TEXT DEFAULT '',
        ${DatabaseConstants.columnStatus} TEXT NOT NULL DEFAULT 'inbox',
        ${DatabaseConstants.columnPriority} TEXT NOT NULL DEFAULT 'p4',
        ${DatabaseConstants.columnQuadrant} TEXT NOT NULL DEFAULT 'doFirst',
        ${DatabaseConstants.columnDueDate} INTEGER,
        ${DatabaseConstants.columnCompletedAt} INTEGER,
        ${DatabaseConstants.columnCreatedAt} INTEGER NOT NULL,
        ${DatabaseConstants.columnUpdatedAt} INTEGER NOT NULL,
        ${DatabaseConstants.columnSortOrder} INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_due_date
      ON ${DatabaseConstants.tableTasks}(${DatabaseConstants.columnDueDate})
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_status
      ON ${DatabaseConstants.tableTasks}(${DatabaseConstants.columnStatus})
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_quadrant
      ON ${DatabaseConstants.tableTasks}(${DatabaseConstants.columnQuadrant})
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_tasks_sort_order
      ON ${DatabaseConstants.tableTasks}(${DatabaseConstants.columnSortOrder})
    ''');
  }
}
