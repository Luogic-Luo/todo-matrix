import '../../domain/entities/task.dart';
import '../models/task_model.dart';

class TaskMapper {
  TaskMapper._();

  static TaskModel toModel(Task task) => TaskModel.fromEntity(task);

  static Task toEntity(TaskModel model) => model.toEntity();

  static List<Task> toEntityList(List<TaskModel> models) =>
      models.map(toEntity).toList();

  static List<TaskModel> toModelList(List<Task> entities) =>
      entities.map(toModel).toList();
}
