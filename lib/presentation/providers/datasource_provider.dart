import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'database_provider.dart';
import '../../data/datasources/task_local_datasource.dart';

part 'datasource_provider.g.dart';

@riverpod
TaskLocalDataSource taskLocalDataSource(AutoDisposeProviderRef<TaskLocalDataSource> ref) {
  return TaskLocalDataSource(ref.watch(databaseProvider));
}
