import '../entities/task.dart';
import '../enums/task_status.dart';
import '../enums/eisenhower_quadrant.dart';

/// Abstract repository interface for task operations.
/// Defined in the domain layer with zero external dependencies.
abstract class TaskRepository {
  Future<Task?> getTaskById(String id);

  Future<List<Task>> getAllTasks();

  Future<List<Task>> getTasksByStatus(TaskStatus status);

  Future<List<Task>> getTasksByQuadrant(EisenhowerQuadrant quadrant);

  Future<List<Task>> getTasksByDueDate(DateTime date);

  Future<List<Task>> getOverdueTasks();

  Future<void> createTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);

  Future<void> moveTaskToQuadrant(
    String taskId,
    EisenhowerQuadrant quadrant,
    DateTime updatedAt,
  );

  Future<void> reorderTasksInQuadrant(
    EisenhowerQuadrant quadrant,
    int oldIndex,
    int newIndex,
  );
}
