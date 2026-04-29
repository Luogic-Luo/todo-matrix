import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'datasource_provider.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

part 'repository_provider.g.dart';

@riverpod
TaskRepository taskRepository(AutoDisposeProviderRef<TaskRepository> ref) {
  return TaskRepositoryImpl(ref.watch(taskLocalDataSourceProvider));
}
