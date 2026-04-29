/// The four quadrants of the Eisenhower Matrix.
enum EisenhowerQuadrant {
  doFirst,   // 紧急且重要
  schedule,  // 不紧急但重要
  delegate,  // 紧急但不重要
  eliminate; // 不紧急且不重要

  String get label {
    switch (this) {
      case doFirst:   return '立刻执行';
      case schedule:  return '计划安排';
      case delegate:  return '委派他人';
      case eliminate: return '直接删除';
    }
  }

  String get shortLabel {
    switch (this) {
      case doFirst:   return '执行';
      case schedule:  return '安排';
      case delegate:  return '委派';
      case eliminate: return '删除';
    }
  }

  String get description {
    switch (this) {
      case doFirst:   return '紧急且重要';
      case schedule:  return '不紧急但重要';
      case delegate:  return '紧急但不重要';
      case eliminate: return '不紧急且不重要';
    }
  }
}
