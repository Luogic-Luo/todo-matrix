/// Priority levels for tasks.
enum TaskPriority {
  p1, // 紧急
  p2, // 高
  p3, // 中
  p4; // 低

  String get label {
    switch (this) {
      case p1: return 'P1 - 紧急';
      case p2: return 'P2 - 高';
      case p3: return 'P3 - 中';
      case p4: return 'P4 - 低';
    }
  }

  String get shortLabel {
    switch (this) {
      case p1: return 'P1';
      case p2: return 'P2';
      case p3: return 'P3';
      case p4: return 'P4';
    }
  }

  /// Whether this priority is considered urgent (P1-P2).
  bool get isUrgent => this == p1 || this == p2;

  /// Whether this priority is considered important (P1, P3).
  bool get isImportant => this == p1 || this == p3;
}
