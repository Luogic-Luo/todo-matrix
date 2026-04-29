import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../domain/entities/task.dart';
import '../../../shared_widgets/completion_checkbox.dart';
import '../../../shared_widgets/priority_badge.dart';
import '../../../providers/task_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatrixTaskTile extends ConsumerWidget {
  final Task task;
  final bool compact;

  const MatrixTaskTile({
    super.key,
    required this.task,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final tile = Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingXs),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        onTap: () {
          context.pushNamed('taskDetail', pathParameters: {'id': task.id});
        },
        child: Padding(
          padding: EdgeInsets.all(
            compact ? AppDimensions.paddingS : AppDimensions.paddingM,
          ),
          child: Row(
            children: [
              CompletionCheckbox(
                isCompleted: task.isCompleted,
                size: compact ? 18 : 20,
                onToggle: () => ref
                    .read(taskActionsProvider.notifier)
                    .toggleTaskCompletion(task.id),
              ),
              const Gap(AppDimensions.paddingS),
              Expanded(
                child: Text(
                  task.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted
                        ? theme.colorScheme.outline
                        : null,
                    fontSize: compact ? 12 : 14,
                  ),
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!compact) ...[
                const Gap(AppDimensions.paddingXs),
                PriorityBadge(priority: task.priority, compact: true),
              ],
            ],
          ),
        ),
      ),
    );

    return LongPressDraggable<Task>(
      data: task,
      delay: const Duration(milliseconds: 200),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: SizedBox(
          width: 160,
          child: Card(
            margin: EdgeInsets.zero,
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Text(
                task.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: tile,
      ),
      child: tile,
    );
  }
}
