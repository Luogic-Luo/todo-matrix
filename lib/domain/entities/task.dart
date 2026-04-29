import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/task_status.dart';
import '../enums/task_priority.dart';
import '../enums/eisenhower_quadrant.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    @Default('') String description,
    @Default(TaskStatus.inbox) TaskStatus status,
    @Default(TaskPriority.p4) TaskPriority priority,
    @Default(EisenhowerQuadrant.doFirst) EisenhowerQuadrant quadrant,
    DateTime? dueDate,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int sortOrder,
  }) = _Task;

  const Task._();

  bool get isCompleted => status == TaskStatus.done;
  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      !isCompleted;
}
