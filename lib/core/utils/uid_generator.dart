import 'package:uuid/uuid.dart';

class UidGenerator {
  UidGenerator._();

  static const _uuid = Uuid();

  static String generate() => _uuid.v4();
}
