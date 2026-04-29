import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/eisenhower_quadrant.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../mappers/task_mapper.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _datasource;

  TaskRepositoryImpl(this._datasource);

  @override
  Future<Task?> getTaskById(String id) async {
    final model = await _datasource.getById(id);
    if (model == null) return null;
    return TaskMapper.toEntity(model);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final models = await _datasource.getAll();
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final models = await _datasource.getByStatus(status.name);
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<List<Task>> getTasksByQuadrant(EisenhowerQuadrant quadrant) async {
    final models = await _datasource.getByQuadrant(quadrant.name);
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<List<Task>> getTasksByDueDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(
          const Duration(milliseconds: 1),
        );
    final models = await _datasource.getByDueDate(
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    );
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<List<Task>> getOverdueTasks() async {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));
    final models = await _datasource.getOverdue(
      endOfToday.millisecondsSinceEpoch,
    );
    return TaskMapper.toEntityList(models);
  }

  @override
  Future<void> createTask(Task task) async {
    await _datasource.insert(TaskMapper.toModel(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await _datasource.update(TaskMapper.toModel(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await _datasource.delete(id);
  }

  @override
  Future<void> moveTaskToQuadrant(
    String taskId,
    EisenhowerQuadrant quadrant,
    DateTime updatedAt,
  ) async {
    final model = await _datasource.getById(taskId);
    if (model == null) return;

    final updated = model.copyWith(
      quadrant: quadrant.name,
      updatedAt: updatedAt.millisecondsSinceEpoch,
    );
    await _datasource.update(updated);
  }

  @override
  Future<void> reorderTasksInQuadrant(
    EisenhowerQuadrant quadrant,
    int oldIndex,
    int newIndex,
  ) async {
    final tasks = await _datasource.getByQuadrant(quadrant.name);
    if (tasks.isEmpty) return;

    final mutableList = tasks.toList();
    final moved = mutableList.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex--;
    mutableList.insert(newIndex, moved);

    final updates = <Map<String, dynamic>>[];
    for (var i = 0; i < mutableList.length; i++) {
      updates.add({
        'id': mutableList[i].id,
        'sort_order': i,
      });
    }
    await _datasource.updateSortOrders(updates);
  }
}
