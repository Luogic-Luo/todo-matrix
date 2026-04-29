import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/enums/eisenhower_quadrant.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../shared_widgets/completion_checkbox.dart';
import '../../../shared_widgets/priority_badge.dart';
import '../../../providers/task_providers.dart';

Color _quadrantColor(EisenhowerQuadrant quadrant, ThemeData theme) {
  return switch (quadrant) {
    EisenhowerQuadrant.doFirst => Colors.red,
    EisenhowerQuadrant.schedule => const Color(0xFFD4A017),
    EisenhowerQuadrant.delegate => Colors.blue,
    EisenhowerQuadrant.eliminate => Colors.green,
  };
}

class InboxTaskTile extends ConsumerWidget {
  final Task task;

  const InboxTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      confirmDismiss: (_) async {
        await ref.read(taskActionsProvider.notifier).deleteTask(task.id);
        return false; // We handle removal via state invalidation
      },
      child: Card(
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
                        : _quadrantColor(task.quadrant, theme),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                ),
                const Gap(AppDimensions.paddingM),
                CompletionCheckbox(
                  isCompleted: task.isCompleted,
                  onToggle: () =>
                      ref.read(taskActionsProvider.notifier).toggleTaskCompletion(task.id),
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
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.colorScheme.outline
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.dueDate != null) ...[
                        const Gap(AppDimensions.paddingXs),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: task.isOverdue
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.outline,
                            ),
                            const Gap(AppDimensions.paddingXs),
                            Text(
                              DateFormat.yMMMd().format(task.dueDate!),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: task.isOverdue
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.outline,
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
