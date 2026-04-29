class AppStrings {
  AppStrings._();

  // Tab labels
  static const String inbox = '收集箱';
  static const String calendar = '日历';
  static const String matrix = '矩阵';

  // Actions
  static const String newTask = '新建任务';
  static const String save = '保存';
  static const String delete = '删除';
  static const String cancel = '取消';
  static const String confirm = '确认';

  // Hints
  static const String quickAddHint = '有什么需要完成的？';
  static const String titleHint = '任务标题';
  static const String descriptionHint = '添加描述...';

  // Empty states
  static const String inboxEmpty = '收集箱是空的';
  static const String inboxEmptySubtitle = '点击下方输入框添加任务';
  static const String noTasksForDay = '当天没有任务';
  static const String dropTasksHere = '拖拽任务到此处';

  // Quadrant labels
  static const String doFirst = '立刻执行';
  static const String schedule = '计划安排';
  static const String delegate = '委派他人';
  static const String eliminate = '直接删除';

  // Quadrant descriptions
  static const String doFirstDesc = '紧急且重要';
  static const String scheduleDesc = '不紧急但重要';
  static const String delegateDesc = '紧急但不重要';
  static const String eliminateDesc = '不紧急且不重要';

  // Matrix axis
  static const String urgent = '紧急';
  static const String notUrgent = '不紧急';
  static const String important = '重要';
  static const String notImportant = '不重要';

  // Errors
  static const String genericError = '出了点问题';
  static const String retry = '重试';
  static const String deleteConfirmation = '确定删除这个任务？';
  static const String deleteConfirmationDesc = '此操作无法撤销。';
}
