/// Table and column name constants for the tasks table.
class DatabaseConstants {
  DatabaseConstants._();

  static const String tableTasks = 'tasks';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnStatus = 'status';
  static const String columnPriority = 'priority';
  static const String columnQuadrant = 'quadrant';
  static const String columnDueDate = 'due_date';
  static const String columnCompletedAt = 'completed_at';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnSortOrder = 'sort_order';

  static const String databaseName = 'todo_app.db';
  static const int databaseVersion = 1;

  static const List<String> allColumns = [
    columnId,
    columnTitle,
    columnDescription,
    columnStatus,
    columnPriority,
    columnQuadrant,
    columnDueDate,
    columnCompletedAt,
    columnCreatedAt,
    columnUpdatedAt,
    columnSortOrder,
  ];
}
