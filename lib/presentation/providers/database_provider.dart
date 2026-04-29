import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/database_helper.dart';

part 'database_provider.g.dart';

@riverpod
DatabaseHelper database(AutoDisposeProviderRef<DatabaseHelper> ref) {
  return DatabaseHelper.instance;
}
