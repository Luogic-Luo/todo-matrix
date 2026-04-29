/// Represents the status of a task in its lifecycle.
enum TaskStatus {
  inbox,       // Not yet triaged (lives in Inbox only)
  todo,        // Active, not started
  inProgress,  // Currently working on
  done;        // Completed

  String get label {
    switch (this) {
      case inbox:      return 'Inbox';
      case todo:       return 'To Do';
      case inProgress: return 'In Progress';
      case done:       return 'Done';
    }
  }
}
