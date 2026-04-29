import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_provider.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/eisenhower_quadrant.dart';
import '../../core/utils/uid_generator.dart';

part 'task_providers.g.dart';

// ── Query providers ──

@riverpod
Future<List<Task>> allTasks(AutoDisposeFutureProviderRef<List<Task>> ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getAllTasks();
}

@riverpod
Future<List<Task>> inboxTasks(AutoDisposeFutureProviderRef<List<Task>> ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksByStatus(TaskStatus.inbox);
}

@riverpod
Future<List<Task>> tasksByQuadrant(
  AutoDisposeFutureProviderRef<List<Task>> ref,
  EisenhowerQuadrant quadrant,
) async {
  final repo = ref.watch(taskRepositoryProvider);
  final tasks = await repo.getTasksByQuadrant(quadrant);
  return tasks.where((t) => !t.isCompleted).toList();
}

@riverpod
Future<List<Task>> tasksByDate(AutoDisposeFutureProviderRef<List<Task>> ref, DateTime date) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksByDueDate(date);
}

@riverpod
Future<List<Task>> doneTasks(AutoDisposeFutureProviderRef<List<Task>> ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksByStatus(TaskStatus.done);
}

@riverpod
Future<Task?> taskById(AutoDisposeFutureProviderRef<Task?> ref, String id) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTaskById(id);
}

// ── Mutation notifier ──

@riverpod
class TaskActions extends _$TaskActions {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createTask({
    required String title,
    String description = '',
    DateTime? dueDate,
    TaskStatus status = TaskStatus.inbox,
  }) async {
    state = const AsyncValue.loading();
    final repo = ref.read(taskRepositoryProvider);
    final now = DateTime.now();
    final task = Task(
      id: UidGenerator.generate(),
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    await repo.createTask(task);
    _invalidateAll();
    state = const AsyncValue.data(null);
  }

  Future<void> updateTask(Task updatedTask) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(taskRepositoryProvider);
      await repo.updateTask(
        updatedTask.copyWith(updatedAt: DateTime.now()),
      );
      _invalidateAll();
    });
  }

  Future<void> deleteTask(String taskId) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(taskRepositoryProvider);
      await repo.deleteTask(taskId);
      _invalidateAll();
    });
  }

  Future<void> moveTaskToQuadrant(
    String taskId,
    EisenhowerQuadrant quadrant,
  ) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(taskRepositoryProvider);
      await repo.moveTaskToQuadrant(taskId, quadrant, DateTime.now());
      _invalidateAll();
    });
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final repo = ref.read(taskRepositoryProvider);
    final task = await repo.getTaskById(taskId);
    if (task == null) return;

    final newStatus =
        task.isCompleted ? TaskStatus.todo : TaskStatus.done;
    await repo.updateTask(
      task.copyWith(
        status: newStatus,
        completedAt:
            newStatus == TaskStatus.done ? DateTime.now() : null,
        updatedAt: DateTime.now(),
      ),
    );
    _invalidateAll();
  }

  Future<void> reorderTasksInQuadrant(
    EisenhowerQuadrant quadrant,
    int oldIndex,
    int newIndex,
  ) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.reorderTasksInQuadrant(quadrant, oldIndex, newIndex);
    // Only invalidate the specific quadrant
    ref.invalidate(tasksByQuadrantProvider(quadrant));
  }

  void _invalidateAll() {
    ref.invalidate(allTasksProvider);
    ref.invalidate(inboxTasksProvider);
    ref.invalidate(doneTasksProvider);
    ref.invalidate(tasksByQuadrantProvider);
    ref.invalidate(tasksByDateProvider);
    ref.invalidate(taskByIdProvider);
  }
}
