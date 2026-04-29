import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/enums/eisenhower_quadrant.dart';
import '../../../providers/task_providers.dart';
import 'matrix_task_tile.dart';

class QuadrantCard extends ConsumerWidget {
  final EisenhowerQuadrant quadrant;

  const QuadrantCard({super.key, required this.quadrant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksByQuadrantProvider(quadrant));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = _quadrantBgColor(quadrant, isDark);

    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) {
        return details.data.quadrant != quadrant;
      },
      onAcceptWithDetails: (details) {
        ref
            .read(taskActionsProvider.notifier)
            .moveTaskToQuadrant(details.data.id, quadrant);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: 200.ms,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: isHovering
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              _QuadrantHeader(quadrant: quadrant),
              Expanded(
                child: tasksAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  error: (e, _) => Center(
                    child: Text(
                      e.toString(),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  data: (tasks) => _buildTaskList(context, tasks, ref),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    List<Task> tasks,
    WidgetRef ref,
  ) {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Text(
            '拖拽任务到此处',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return MatrixTaskTile(
          task: task,
          compact: tasks.length > 4,
        ).animate().fadeIn(
              duration: 300.ms,
              delay: (index * 50).ms,
            );
      },
    );
  }

  Color _quadrantBgColor(EisenhowerQuadrant q, bool isDark) {
    if (isDark) {
      return switch (q) {
        EisenhowerQuadrant.doFirst => AppColors.doFirstDark,
        EisenhowerQuadrant.schedule => AppColors.scheduleDark,
        EisenhowerQuadrant.delegate => AppColors.delegateDark,
        EisenhowerQuadrant.eliminate => AppColors.eliminateDark,
      };
    }
    return switch (q) {
      EisenhowerQuadrant.doFirst => AppColors.doFirst,
      EisenhowerQuadrant.schedule => AppColors.schedule,
      EisenhowerQuadrant.delegate => AppColors.delegate,
      EisenhowerQuadrant.eliminate => AppColors.eliminate,
    };
  }
}

class _QuadrantHeader extends StatelessWidget {
  final EisenhowerQuadrant quadrant;

  const _QuadrantHeader({required this.quadrant});

  Color _quadrantColor(EisenhowerQuadrant q) {
    return switch (q) {
      EisenhowerQuadrant.doFirst => Colors.red,
      EisenhowerQuadrant.schedule => const Color(0xFFD4A017),
      EisenhowerQuadrant.delegate => Colors.blue,
      EisenhowerQuadrant.eliminate => Colors.green,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _quadrantColor(quadrant);

    return Container(
      height: AppDimensions.quadrantHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withAlpha(40),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(_quadrantIcon(quadrant),
              size: AppDimensions.iconS,
              color: color),
          const Gap(AppDimensions.paddingS),
          Expanded(
            child: Text(
              quadrant.description,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _quadrantIcon(EisenhowerQuadrant q) {
    return switch (q) {
      EisenhowerQuadrant.doFirst => Icons.priority_high,
      EisenhowerQuadrant.schedule => Icons.calendar_today,
      EisenhowerQuadrant.delegate => Icons.person_add,
      EisenhowerQuadrant.eliminate => Icons.cancel_outlined,
    };
  }
}
