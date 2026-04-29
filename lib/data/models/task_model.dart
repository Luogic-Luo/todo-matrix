import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/enums/eisenhower_quadrant.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default('inbox') String status,
    @Default('p4') String priority,
    @Default('doFirst') String quadrant,
    @JsonKey(name: 'due_date') int? dueDate,
    @JsonKey(name: 'completed_at') int? completedAt,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'updated_at') required int updatedAt,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromMap(Map<String, dynamic> map) =>
      _$TaskModelFromJson(map);

  const TaskModel._();

  Map<String, dynamic> toMap() => toJson();

  /// Convert from domain entity to data model.
  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        status: task.status.name,
        priority: task.priority.name,
        quadrant: task.quadrant.name,
        dueDate: task.dueDate?.millisecondsSinceEpoch,
        completedAt: task.completedAt?.millisecondsSinceEpoch,
        createdAt: task.createdAt.millisecondsSinceEpoch,
        updatedAt: task.updatedAt.millisecondsSinceEpoch,
        sortOrder: task.sortOrder,
      );

  /// Convert from data model to domain entity.
  Task toEntity() => Task(
        id: id,
        title: title,
        description: description,
        status: TaskStatus.values.firstWhere((e) => e.name == status),
        priority: TaskPriority.values.firstWhere((e) => e.name == priority),
        quadrant:
            EisenhowerQuadrant.values.firstWhere((e) => e.name == quadrant),
        dueDate:
            dueDate != null ? DateTime.fromMillisecondsSinceEpoch(dueDate!) : null,
        completedAt: completedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(completedAt!)
            : null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
        sortOrder: sortOrder,
      );
}
