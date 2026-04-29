import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_provider.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/enums/eisenhower_quadrant.dart';
import '../../core/utils/uid_generator.dart';

part 'task_providers.g.dart';

int _quadrantSortValue(EisenhowerQuadrant q) {
  return switch (q) {
    EisenhowerQuadrant.doFirst => 0,
    EisenhowerQuadrant.schedule => 1,
    EisenhowerQuadrant.delegate => 2,
    EisenhowerQuadrant.eliminate => 3,
  };
}

int _compareByQuadrantAndPriority(Task a, Task b) {
  final qCompare =
      _quadrantSortValue(a.quadrant).compareTo(_quadrantSortValue(b.quadrant));
  if (qCompare != 0) return qCompare;
  return a.priority.index.compareTo(b.priority.index);
}

// ── Query providers ──

@riverpod
Future<List<Task>> allTasks(AutoDisposeFutureProviderRef<List<Task>> ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getAllTasks();
}

@riverpod
Future<List<Task>> inboxTasks(AutoDisposeFutureProviderRef<List<Task>> ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  final tasks = await repo.getTasksByStatus(TaskStatus.inbox);
  tasks.sort(_compareByQuadrantAndPriority);
  return tasks;
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
  final tasks = await repo.getTasksByDueDate(date);
  tasks.sort((a, b) {
    final cmp = (a.isCompleted ? 1 : 0).compareTo(b.isCompleted ? 1 : 0);
    if (cmp != 0) return cmp;
    return _compareByQuadrantAndPriority(a, b);
  });
  return tasks;
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
    EisenhowerQuadrant quadrant = EisenhowerQuadrant.doFirst,
    TaskPriority priority = TaskPriority.p4,
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
      quadrant: quadrant,
      priority: priority,
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
    ref.invalidate(tasksByQuadrantProvider(quadrant));
  }

  Future<void> reorderInboxTasks(
    int oldIndex,
    int newIndex,
  ) async {
    state = await AsyncValue.guard(() async {
      final repo = ref.read(taskRepositoryProvider);
      await repo.reorderInboxTasks(oldIndex, newIndex);
      ref.invalidate(inboxTasksProvider);
    });
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
