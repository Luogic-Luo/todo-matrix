import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/enums/task_priority.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../shared_widgets/priority_badge.dart';

class DayTaskList extends StatelessWidget {
  final List<Task> tasks;
  final DateTime selectedDay;

  const DayTaskList({
    super.key,
    required this.tasks,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.event_note,
        title: '当天没有任务',
        subtitle: '点击 + 添加任务',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const Gap(AppDimensions.paddingS),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return CalendarTaskTile(task: task);
      },
    );
  }
}

class CalendarTaskTile extends StatelessWidget {
  final Task task;

  const CalendarTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: () {
          context.pushNamed('taskDetail', pathParameters: {'id': task.id});
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? theme.colorScheme.outline
                      : _priorityColor(task.priority, theme),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
              ),
              const Gap(AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        decoration:
                            task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.description.isNotEmpty) ...[
                      const Gap(2),
                      Text(
                        task.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PriorityBadge(priority: task.priority),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(TaskPriority priority, ThemeData theme) {
    return switch (priority) {
      TaskPriority.p1 => Colors.red,
      TaskPriority.p2 => Colors.orange,
      TaskPriority.p3 => Colors.green,
      TaskPriority.p4 => theme.colorScheme.outline,
    };
  }
}
