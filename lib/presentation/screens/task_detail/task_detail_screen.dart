import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../domain/enums/task_priority.dart';
import '../../../domain/enums/eisenhower_quadrant.dart';
import '../../providers/task_providers.dart';
import 'widgets/task_form.dart';

enum TaskDetailMode { create, edit }

class TaskDetailScreen extends ConsumerStatefulWidget {
  final TaskDetailMode mode;
  final String? taskId;

  const TaskDetailScreen({
    super.key,
    required this.mode,
    this.taskId,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.p4;
  EisenhowerQuadrant _quadrant = EisenhowerQuadrant.doFirst;
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get _isEditing => widget.mode == TaskDetailMode.edit;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && widget.taskId != null) {
      _isInitialized = true;
      _loadTask();
    }
    if (widget.mode == TaskDetailMode.create) {
      _isInitialized = true;
      final uri = GoRouterState.of(context).uri;
      final dueDateParam = uri.queryParameters['dueDate'];
      if (dueDateParam != null) {
        final ms = int.tryParse(dueDateParam);
        if (ms != null) {
          _dueDate = DateTime.fromMillisecondsSinceEpoch(ms);
        }
      }
    }
  }

  Future<void> _loadTask() async {
    if (widget.taskId == null) return;

    final taskAsync = ref.read(taskByIdProvider(widget.taskId!));
    final task = taskAsync.valueOrNull;
    if (task != null) {
      _titleCtrl.text = task.title;
      _descCtrl.text = task.description;
      _dueDate = task.dueDate;
      _priority = task.priority;
      _quadrant = task.quadrant;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing && widget.taskId != null) {
      final taskAsync = ref.watch(taskByIdProvider(widget.taskId!));
      return taskAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(),
          body: const LoadingWidget(),
        ),
        error: (e, _) => Scaffold(
          appBar: AppBar(),
          body: AppErrorWidget(
            message: e.toString(),
            onRetry: () =>
                ref.invalidate(taskByIdProvider(widget.taskId!)),
          ),
        ),
        data: (task) {
          if (task != null && _titleCtrl.text.isEmpty) {
            _titleCtrl.text = task.title;
            _descCtrl.text = task.description;
            _dueDate = task.dueDate;
            _priority = task.priority;
            _quadrant = task.quadrant;
          }
          return _buildScaffold();
        },
      );
    }

    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑任务' : AppStrings.newTask),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskForm(
              titleCtrl: _titleCtrl,
              descCtrl: _descCtrl,
              dueDate: _dueDate,
              priority: _priority,
              quadrant: _quadrant,
              onDueDateChanged: (date) => setState(() => _dueDate = date),
              onPriorityChanged: (p) => setState(() => _priority = p),
              onQuadrantChanged: (q) => setState(() => _quadrant = q),
            ),
            const Gap(AppDimensions.paddingXl),
            FilledButton.icon(
              onPressed: _isLoading ? null : _save,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isEditing ? AppStrings.save : '创建任务'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入任务标题')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final taskActions = ref.read(taskActionsProvider.notifier);

      if (_isEditing && widget.taskId != null) {
        final taskAsync = ref.read(taskByIdProvider(widget.taskId!));
        final existingTask = taskAsync.valueOrNull;
        if (existingTask != null) {
          final updated = existingTask.copyWith(
            title: title,
            description: _descCtrl.text.trim(),
            dueDate: _dueDate,
            priority: _priority,
            quadrant: _quadrant,
            updatedAt: DateTime.now(),
          );
          await taskActions.updateTask(updated);
        }
      } else {
        await taskActions.createTask(
          title: title,
          description: _descCtrl.text.trim(),
          dueDate: _dueDate,
        );
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('错误：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmation),
        content: const Text(AppStrings.deleteConfirmationDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _delete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    if (widget.taskId == null) return;
    try {
      await ref.read(taskActionsProvider.notifier).deleteTask(widget.taskId!);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('错误：$e')),
        );
      }
    }
  }
}
